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
@synthesize file, fileOffset;

#define kBytesToRead 500

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

- (void) startChecking
{
  
}

- (void) checkFile
{
  NSLog(@"=== check_file");
  if (self.isChecking) { return; }
  self.isChecking = true;
    
  // each iteration uses a fresh NSFileHandle, remove the old handler and close the old file
  [[NSNotificationCenter defaultCenter] removeObserver:self name: NSFileHandleReadToEndOfFileCompletionNotification object: self.file];
  [self.file closeFile];
    
  if (self.file = [NSFileHandle fileHandleForReadingFromURL:[self fileURL] error:nil]) {
    [self.file seekToFileOffset:self.fileOffset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(handleData:) name: NSFileHandleReadToEndOfFileCompletionNotification object: self.file];
  }
      
  // readInBackgroundAndNotify, and corresponding notification for incremental
  [self.file readToEndOfFileInBackgroundAndNotify];
}
     
- (void) handleData:(NSNotification*)aNotification {
  NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
  NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // OPTIMIZE: construct entire strings at a time.
  NSDictionary *retval = [NSDictionary dictionaryWithObjectsAndKeys:s, @"lines", nil];
  // TODO: break into lines, buffer partial lines
  [[NSNotificationCenter defaultCenter] postNotificationName:kLinesAvailable object:self userInfo:retval];
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

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
  // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.
  
  // You can also choose to override -readFromData:ofType:error, -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
  
  // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.

  // TODO: connect to [self fileURL] or 'data' and keep internal state to read from
  NSLog(@"log readFromURL");
  NSError *error = nil;
  self.file = [NSFileHandle fileHandleForReadingFromURL:absoluteURL error:&error];
  if (error)
    [NSApp presentError:error];
  else if(self.file == nil) {
    NSLog(@"no such file: %@", absoluteURL);
  }

  self.fileOffset = [file seekToEndOfFile] - kBytesToRead;
  if (self.fileOffset < 0) {
    self.fileOffset = 0;
  }

  if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
  return YES;
}



@end
