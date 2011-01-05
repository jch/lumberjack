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
  NSFileHandle *file;
  BOOL isChecking;
  NSString *readBuffer; // should be char*
  NSTimer *timer; // periodically checks for log changes
}

@property (nonatomic) BOOL isChecking;
@property (nonatomic, retain) NSFileHandle *file;
@property (nonatomic, retain) NSString *readBuffer;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) BOOL isPinned;

- (void) startChecking;
- (void) checkFile;
- (void) handleData:(NSNotification*)aNotification;
- (void) logFileStats;
@end
