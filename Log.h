//
//  Log.h
//  lumberjack
//
//  Created by Jerry Cheung on 8/11/10.
//  Copyright 2010 University of California, Berkeley. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "LogController.h"

@interface Log : NSDocument
{
  LogController *logController;
  
  NSURL *url;
  NSFileHandle *file;
  NSInteger offset;
  BOOL checking;
  NSString *readBuffer; // should be char*
}

@property (nonatomic, retain) LogController *logController;
@end
