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
  NSString *lines = [[aNotification userInfo] objectForKey:@"lines"];
  lines = [lines stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *js = [NSString stringWithFormat:@"Lumberjack.process(\"%@\")", lines];
  NSLog(@"JSSSSS: %@", js);
  NSLog(@"js returned: %@", [[logView windowScriptObject] evaluateWebScript:js]);
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
  NSString *title = [[[[self document] fileURL] pathComponents] lastObject];
  title = title ? title : @"Lumberjack";
  return title;
}

#pragma mark WebView frameDelegate Methods
//- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame
{
  NSLog(@"before resources loaded");
  //  NSLog("### %@", (NSString*) [[webView windowScriptObject] evaluateWebScript:@"$('.box:first').text()"]);
  //  NSArray *args = [NSArray arrayWithObjects:@".box:first", nil];
  //  NSLog(@"### %@", [[sender windowScriptObject] callWebScriptMethod:@"$" withArguments:args]);
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
  NSLog(@"after resources loaded");
  [[self document] checkFile];
  //NSArray *args = [NSArray arrayWithObjects:@".box:first", nil];
  //NSLog(@"### %@", [[sender windowScriptObject] callWebScriptMethod:@"$" withArguments:args]);
  //[[sender windowScriptObject] evaluateWebScript:@"crazy()"];
  // jQuery works, but $ doesn't
  //[[sender windowScriptObject] evaluateWebScript:@"jQuery('.box').hide()"];
  //[[sender windowScriptObject] evaluateWebScript:@"log('baz')"];
}

@end
