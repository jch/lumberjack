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

  NSFileHandle *file;
  NSInteger fileOffset;
  BOOL isChecking;
  NSString *readBuffer; // should be char*
}

@property (nonatomic, retain) LogController *logController;
@property (nonatomic) BOOL isChecking;
@property (nonatomic, retain) NSFileHandle *file;
@property (nonatomic) NSInteger fileOffset;
@property (nonatomic, retain) NSString *readBuffer;


// TODO: hold an internal NSRunLoop reference for each open doc. start/stop as needed.
- (void) startChecking;
//- (void) stopChecking;
//- (void) close;
- (void) checkFile;
- (void) handleData:(NSNotification*)aNotification;
@end
