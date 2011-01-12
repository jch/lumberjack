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
      [NSNumber numberWithInt:1], @"defaultStartupLoad", nil]];
  }

  // Forced expiration - should read from Info.plist
  if ([self isExpired]) {
    NSRunAlertPanel(@"App Expired",@"Visit website http://whatcodecraves.com/lumberjack",@"OK",nil,nil);
    [NSApp terminate:self];
    return nil;
  }

  return self;
}

- (void)applicationDidFinishLaunching
{
  applicationHasStarted = YES;
  
  // Sparkle updates
  [checkForUpdatesMenuItem setTarget:[SUUpdater sharedUpdater]];
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

- (BOOL)isExpired
{
  NSDate *expiryDate = [NSDate dateWithNaturalLanguageString:@"2/6/2011"];
  NSDate *now = [NSDate date];
  
  return [now compare:expiryDate] == NSOrderedDescending;
}

@end
