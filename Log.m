//
//  Log.m
//  lumberjack
//
//  Created by Jerry Cheung on 8/11/10.
//  Copyright 2010 University of California, Berkeley. All rights reserved.
//

#import "Log.h"

@implementation Log

@synthesize logController;

- (id)init
{
  self = [super init];
  if (self) {
    // Add your subclass-specific initialization here.
    // If an error occurs here, send a [self release] message and return nil.
    
  }
  return self;
}

- (void)makeWindowControllers
{
  self.logController = [[LogController alloc] init];
  [self addWindowController:logController];
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
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

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.
  
  // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
  
  // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.

  // TODO: connect to [self fileURL] or 'data' and keep internal state to read from
  if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
  return YES;
}

@end
