//
//  Log.m
//  lumberjack
//
//  Created by Jerry Cheung on 8/11/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import "Log.h"

@implementation Log

@synthesize logController;
@synthesize isChecking;
@synthesize readBuffer;
@synthesize file;
@synthesize absolutePath, absoluteURL;

#define kBytesToRead 3000

- (id)init
{
  NSLog(@"log init");
  self = [super init];
  if (self) {
    self.isChecking = NO;
    self.readBuffer = [NSMutableString string];

    // Add your subclass-specific initialization here.
    // If an error occurs here, send a [self release] message and return nil.    
  }
  return self;
}

// schedule checkFile in a run loop indefinitely
- (void) startChecking
{
  if (!self.file) { return; }
  NSLog(@"### startChecking");
  [self checkFile];
  [NSTimer scheduledTimerWithTimeInterval:1.5
                                   target:self
                                 selector:@selector(checkFile)
                                 userInfo:nil
                                  repeats:YES];
}

- (void) logFileStats
{
  //NSString * const NSFileSize; - unsigned int bytes
  //NSString * const NSFileModificationDate; - NSDate
  NSLog(@"DEBUG: %@", self.absoluteURL.absoluteString);
  NSError *error = nil;
  NSString *path = @"/Users/jch/projects/beerpad/log/development.log";
  NSLog(@"DEBUG:\n  %@", [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error]);
  if (error)
    [NSApp presentError:error];
}

- (void) checkFile
{
  NSLog(@"=== check_file - checking %u", self.isChecking);
  if (self.isChecking) { return; }
  self.isChecking = YES;
  NSLog(@"=== check_file - %@", self.file);
  
  [self.file synchronizeFile]; // don't call offsetInFile after, will raise exception
  [self logFileStats];
  [self.file readToEndOfFileInBackgroundAndNotify];
}
     
- (void) handleData:(NSNotification*)aNotification {
  NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
  NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

  // TODO: buffer partial lines
  NSArray *lines = [s componentsSeparatedByString:@"\n"];
  NSDictionary *retval = [NSDictionary dictionaryWithObjectsAndKeys:lines, @"lines", nil];

  [[NSNotificationCenter defaultCenter] postNotificationName:kLinesAvailable object:self userInfo:retval];
  self.isChecking = NO;
}

- (void)makeWindowControllers
{
  self.logController = [[LogController alloc] init];
  [self addWindowController:logController];
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
  NSLog(@"log windowControllerDidLoadNib");
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
  [super windowControllerDidLoadNib:aController];
}

- (void)keyDown:(NSEvent *)theEvent {
  
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.
  // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
  // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
  
  if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
  // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.
  // You can also choose to override -readFromData:ofType:error, -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.   
  // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
  NSLog(@"log readFromURL");
  NSError *error = nil;

  self.absolutePath = [url absoluteString];
  self.absoluteURL = url;
  self.file = [NSFileHandle fileHandleForReadingFromURL:url error:&error];
  if (error)
    [NSApp presentError:error];
  else if(self.file == nil) {
    NSLog(@"no such file: %@", url);
  }

  unsigned long long fileOffset = [file seekToEndOfFile] - kBytesToRead;
  if (fileOffset < 0) {
    fileOffset = 0;
  }
  [self.file seekToFileOffset: fileOffset];

  if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
  [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(handleData:) name: NSFileHandleReadToEndOfFileCompletionNotification object: self.file];
  return YES;
}

@end
