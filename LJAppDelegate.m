//
//  LJAppDelegate.m
//  lumberjack
//
//  Created by Jerry Cheung on 12/30/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import "LJAppDelegate.h"


@implementation LJAppDelegate

- (id)init
{
  if (self = [super init]) {
    applicationHasStarted = NO;
  }
  return self;
}

- (void)applicationDidFinishLaunching
{
  applicationHasStarted = YES;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
  if (!applicationHasStarted) {
    NSLog(@"app not started!!!");
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    NSArray *urls = [dc recentDocumentURLs];

    // if file is moved, renamed, or removed, it's updated in 'recently opened'
    if ([urls count] > 0) {
      NSURL *mostRecentURL = [urls objectAtIndex:0];
      [dc openDocumentWithContentsOfURL:mostRecentURL display:YES error:NULL];
      return NO;
    }
  }
  return YES;
}

@end
