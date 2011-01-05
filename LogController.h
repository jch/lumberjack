//
//  LogController.h
//  lumberjack
//
//  Created by Jerry Cheung on 12/10/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "AVWindow.h"

#define kLinesAvailable @"LinesAvailable"

@interface LogController : NSWindowController {
  WebView *logView;
  IBOutlet NSView *pinView; // pin a window to stay on top
}

@property (nonatomic, retain) IBOutlet WebView *logView;

-(void) composeInterface;

@end
