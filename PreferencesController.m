//
//  PreferencesController.m
//  lumberjack
//
//  Created by Jerry Cheung on 1/6/11.
//  Copyright 2011 Intridea. All rights reserved.
//

#import "PreferencesController.h"

@implementation PreferencesController

-(id) init {
  if (self = [super initWithWindowNibName:@"Preferences"]) {
    
  }
  return self;
}

-(void) showWindow:(id)sender {
  [[NSNotificationCenter defaultCenter]
   postNotificationName:kTogglePin
   object:self
   userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kTogglePin]];
  [super showWindow:sender];
}

#pragma mark -
#pragma mark Window Delegate

- (void)windowWillClose:(NSNotification *)notification {
  [[NSNotificationCenter defaultCenter]
   postNotificationName:kTogglePin
   object:self
   userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kTogglePin]];  
}

@end
