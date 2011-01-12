//
//  LJAppDelegate.h
//  lumberjack
//
//  Created by Jerry Cheung on 12/30/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>

@interface LJAppDelegate : NSObject {
  BOOL applicationHasStarted;
  IBOutlet NSMenuItem *checkForUpdatesMenuItem;
}

- (BOOL)isExpired;

@end
