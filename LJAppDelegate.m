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
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithBool:NO], @"defaultIsPinned",
      [NSNumber numberWithInt:0], @"defaultStartupLoad", nil]];
  }
  return self;
}

- (void)applicationDidFinishLaunching
{
  applicationHasStarted = YES;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
  int startupLoad = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultStartupLoad"];
  if (!applicationHasStarted && startupLoad == 0) {
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    NSArray *urls = [dc recentDocumentURLs];

    // if file is moved, renamed, or removed, it's updated in 'recently opened'
    if ([urls count] > 0) {
      NSURL *mostRecentURL = [urls objectAtIndex:0];
      [dc openDocumentWithContentsOfURL:mostRecentURL display:YES error:NULL];
      return NO;
    }
  } else if (startupLoad == 2) {
    return NO;
  }
  return YES;
}

@end
