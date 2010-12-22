//
//  LogController.h
//  lumberjack
//
//  Created by Jerry Cheung on 12/10/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#define kLinesAvailable @"LinesAvailable"

@interface LogController : NSWindowController {
  WebView *logView;
}

@property (nonatomic, retain) IBOutlet WebView *logView;

@end
