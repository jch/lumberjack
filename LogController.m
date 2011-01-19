//
//  LogController.m
//  lumberjack
//
//  Created by Jerry Cheung on 12/10/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import "LogController.h"
#import "Log.h"

@implementation LogController

@synthesize logView;

-(id) init
{
  self = [super initWithWindowNibName:@"Log"];
  canPin = YES;
  NSLog(@"LC: init %@", [self document]);
  return self;
}

- (void) awakeFromNib {
  NSLog(@"LC: awakeFrom Nib %@", [self document]);
  [self composeInterface];

  NSURL *url = [[self document] fileURL];

  
  NSString *splashPath = [[NSBundle mainBundle] pathForResource:@"splash" ofType:@"html" inDirectory:@"html"];
  NSString *indexPath = [[NSBundle mainBundle] pathForResource: @"log" ofType: @"html" inDirectory:@"html"];
  NSString *filePath = (url ? indexPath : splashPath);
  NSURL *baseURL = [NSURL fileURLWithPath:[splashPath stringByDeletingLastPathComponent]];

  NSString *html = [NSString stringWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
  [[logView mainFrame] loadHTMLString: html baseURL: baseURL];

  // register for linesAvailable notifications and kick off the check loop:
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linesAvailable:) name:kLinesAvailable object:[self document]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(togglePin:) name:kTogglePin object:nil];
}

- (void) composeInterface
{
  [(AVWindow*)[self window] setTitlebarAccessoryView:pinView];
}

//- (void)keyDown:(NSEvent *)theEvent
//{
////  NSAlphaShiftKeyMask = 1 << 16,
////  NSShiftKeyMask      = 1 << 17,
////  NSControlKeyMask    = 1 << 18,
////  NSAlternateKeyMask  = 1 << 19,
////  NSCommandKeyMask    = 1 << 20,
////  NSNumericPadKeyMask = 1 << 21,
////  NSHelpKeyMask       = 1 << 22,
////  NSFunctionKeyMask   = 1 << 23,
////  NSDeviceIndependentModifierFlagsMask = 0xffff0000U
//  // n - 35
//  // p - 45
//  // j - 38
//  // k - 40
//  NSLog(@"key down: %u %u", [theEvent keyCode], [theEvent modifierFlags]);
//  if ([theEvent keyCode] == 38) {
//    // down: j or cntrl-n
//    [self nextLogEntry];
//  } else if (<#condition#>) {
//    <#statements#>
//  } else {
//    [super keyDown:theEvent];
//  }
//}


#pragma mark -
#pragma mark Notification Handlers

- (void) linesAvailable:(NSNotification*)aNotification
{
  NSArray *lines = [[aNotification userInfo] objectForKey:@"lines"];
  for(NSString* e in lines) {
    [[logView windowScriptObject] evaluateWebScript:@"if(Lumberjack.currentEntryEmpty()) { Lumberjack.prependEntry() }"];
    for(NSString *line in [e componentsSeparatedByString:@"\n"]) {    
      line = [line stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      NSString *js = [NSString stringWithFormat:@"Lumberjack.process(\"%@\")", line];
      [[logView windowScriptObject] evaluateWebScript:js];
    }
  }
  [[logView windowScriptObject] evaluateWebScript:@"$.scrollTo('.entry:last', 500, {over:{bottom:0}});"];
}

- (void) togglePin:(NSNotification*)aNotification
{
  NSLog(@"toggling pin %@", aNotification);
  canPin = [[[aNotification userInfo] valueForKey:kTogglePin] boolValue];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
  NSString *title = [NSString stringWithFormat:@"%@/%@",
                     [[self document] projectName],
                     [[[[self document] fileURL] pathComponents] lastObject]];
  title = [[self document] projectName] ? title : @"Lumberjack";
  return title;
}

#pragma mark -
#pragma mark Window Delegate

- (void)windowDidResignMain:(NSNotification *)notification
{
  NSLog(@"resigning window: %@", notification);
  if (canPin && [[self document] isPinned]) {
    [[self window] setLevel:NSFloatingWindowLevel];
  } else {
    [[self window] setLevel:NSNormalWindowLevel];
  }
}

#pragma mark -
#pragma mark WebView frameDelegate Methods
- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame
{
  NSLog(@"before resources loaded");
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
  NSLog(@"after resources loaded");
  NSString *js = [NSString stringWithFormat:@"Lumberjack.setup({projectRoot: \"%@\"});", [[self document] projectRootURL]];
  NSLog(@"set project root js: %@", js);
  [[logView windowScriptObject] evaluateWebScript:js];
  [[self document] startChecking]; // NSDocument doesn't know checkFile, but can't cast b/c then would need to import
}

//- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
//  if(![frame parentFrame]) {
//    NSLog(@"REALODING didstartprovisional!!!!!");
//    // There is no parent frame so this is the main frame.
//  }
//}

#pragma mark -
#pragma mark WebView WebPolicyDelegate

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id)listener {
  NSLog(@"policy delegate %@", [[request URL] absoluteString]);
  if([[[request URL] absoluteString] rangeOfString:@"Lumberjack.app"].location != NSNotFound) {
    [listener use];
  } else {
    [listener ignore];
    [[NSWorkspace sharedWorkspace] openURL:[request URL]];
  }
}


@end
