//
//  LogController.m
//  lumberjack
//
//  Created by Jerry Cheung on 12/10/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import "LogController.h"

@implementation LogController

@synthesize logView;

-(id) init
{
  self = [super initWithWindowNibName:@"Log"];
  NSLog(@"LC: init %@", [self document]);
  return self;
}

- (void) awakeFromNib {
  NSLog(@"LC: awakeFrom Nib %@", [self document]);
  NSURL *url = [[self document] fileURL];

  NSString *splashPath = [[NSBundle mainBundle] pathForResource: @"splash" ofType: @"html"];
  NSString *indexPath = [[NSBundle mainBundle] pathForResource: @"log" ofType: @"html"];
  NSString *filePath = (url ? indexPath : splashPath);
  NSURL *baseURL = [NSURL fileURLWithPath:[splashPath stringByDeletingLastPathComponent]];

  NSString *html = [NSString stringWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
  [[logView mainFrame] loadHTMLString: html baseURL: baseURL];

  // register for linesAvailable notifications and kick off the check loop:
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linesAvailable:) name:kLinesAvailable object:[self document]];
}

- (void) linesAvailable:(NSNotification*)aNotification
{
  NSArray *lines = [[aNotification userInfo] objectForKey:@"lines"];
  for(NSString* line in lines) {
    line = [line stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *js = [NSString stringWithFormat:@"Lumberjack.process(\"%@\")", line];
    [[logView windowScriptObject] evaluateWebScript:js];
    // NSLog(@"JSSSSS: %@", js);
    // NSLog(@"js returned: %@", );
  }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
  NSString *title = [[[[self document] fileURL] pathComponents] lastObject];
  title = title ? title : @"Lumberjack";
  return title;
}

#pragma mark WebView frameDelegate Methods
- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame
{
  NSLog(@"before resources loaded");
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
  NSLog(@"after resources loaded");
  [[self document] startChecking]; // NSDocument doesn't know checkFile, but can't cast b/c then would need to import
}

@end
