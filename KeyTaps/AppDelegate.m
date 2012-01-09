//
//  AppDelegate.m
//  KeyTaps
//
//  Created by Rob Hurring on 1/9/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize keyTaps;
@synthesize menuLabel;
@synthesize appMenu;
@synthesize statusItem;
@synthesize monitor;
@synthesize formatter;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu: appMenu];
  [statusItem setHighlightMode:YES];
  [statusItem setTarget:self];
  
  formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

  [self load];
  [self startMonitoring];
}

-(IBAction)quit:(id)sender
{
  [self applicationWillTerminate:nil];
  exit(0);
}

-(IBAction) reset:(id)sender
{
  [self reset];
}

-(void) applicationWillTerminate:(NSNotification *)notification
{
  [self stopMonitoring];
  [self save];
  [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

# pragma mark Event Monitoring

-(void) startMonitoring
{
  monitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event)
  {
    keyTaps++;
    [self update];
  }];
}

-(void)reset
{
  keyTaps = 0LL;
  [self save];
  [self update];
}

-(void) update
{
  NSString *output = [formatter stringFromNumber:[NSNumber numberWithLongLong:keyTaps]];
  [statusItem setTitle:[NSString stringWithFormat:@"%@ chars", output]];
  [menuLabel setTitle:[NSString stringWithFormat:@"%@ KeyTaps", output]];
}

-(void) stopMonitoring
{
  if(monitor)
    [NSEvent removeMonitor:monitor];
}

# pragma mark Persistence

-(void) load
{
  NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"data.plist"];
  NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:filePath];
  NSNumber *taps = [data objectForKey:@"taps"];
  
  if(taps)
    keyTaps = [taps longLongValue];
  else
    keyTaps = 0LL;
    
  [self update];
}

-(void) save
{
  NSDictionary *data = [NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:keyTaps] forKey:@"taps"];
  NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"data.plist"];

  [data writeToFile:filePath atomically: YES];
}

@end
