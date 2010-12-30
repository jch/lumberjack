//
//  Log.h
//  lumberjack
//
//  Created by Jerry Cheung on 8/11/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "LogController.h"

@interface Log : NSDocument
{
  LogController *logController;

  NSString *absolutePath;
  NSURL *absoluteURL;

  NSFileHandle *file;
  BOOL isChecking;
  NSString *readBuffer; // should be char*
}

@property (nonatomic, retain) LogController *logController;
@property (nonatomic) BOOL isChecking;
@property (nonatomic, retain) NSString *absolutePath;
@property (nonatomic, retain) NSURL *absoluteURL;
@property (nonatomic, retain) NSFileHandle *file;
@property (nonatomic, retain) NSString *readBuffer;


// TODO: hold an internal NSRunLoop reference for each open doc. start/stop as needed.
- (void) startChecking;
//- (void) stopChecking;
//- (void) close;
- (void) checkFile;
- (void) handleData:(NSNotification*)aNotification;
- (void) logFileStats;
@end
