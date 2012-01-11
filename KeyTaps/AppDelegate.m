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
@synthesize lifetimeTaps;
@synthesize charCountLabel;
@synthesize lastResetLabel;
@synthesize lifetimeLabel;
@synthesize appMenu;
@synthesize statusItem;
@synthesize monitor;
@synthesize menuImage;
@synthesize menuImageAlt;
@synthesize lastReset;
@synthesize numberFormatter;
@synthesize dateFormatter;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  menuImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"keytap.png"]];
  menuImageAlt = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"keytap-alt.png"]];
  
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:appMenu];
  [statusItem setImage:menuImage];
  [statusItem setAlternateImage:menuImageAlt];
  
  [statusItem setHighlightMode:YES];
  [statusItem setTarget:self];
  
  numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
  
  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

  [self load];
  [self startMonitoring];
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
    lifetimeTaps++;
    [self update];
  }];
}

-(void) stopMonitoring
{
  if(monitor)
    [NSEvent removeMonitor:monitor];
}

# pragma mark Actions

-(IBAction) reset:(id)sender
{
  [self reset];
}

-(void)reset
{
  keyTaps = 0LL;
  lifetimeTaps = 0LL;
  lastReset = [[NSDate alloc] init];
  
  [self save];
  [self update];
}

-(void) update
{
  NSString *output = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:keyTaps]];
  [charCountLabel setTitleWithMnemonic:output];
  
  output = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:lifetimeTaps]];
  [lifetimeLabel setTitleWithMnemonic:output];
  
  output = [dateFormatter stringFromDate:lastReset];
  [lastResetLabel setTitleWithMnemonic:[NSString stringWithFormat:@"Chars since %@", output]];
}

# pragma mark Persistence

-(void) load
{
  NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"data.plist"];
  NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:filePath];
  
  keyTaps = [[data objectForKey:@"taps"] longLongValue];
  lastReset = [data objectForKey:@"lastReset"];
  lifetimeTaps = [[data objectForKey:@"lifetime"] longLongValue];
  
  if(!keyTaps)
    keyTaps = 0LL;
  
  if(!lifetimeTaps)
    lifetimeTaps = 0LL;
  
  if(!lastReset)
    lastReset = [[NSDate alloc] init];
      
  [self update];
}

-(void) save
{
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:[NSNumber numberWithLongLong:keyTaps] forKey:@"taps"];
  [data setObject:[NSNumber numberWithLongLong:lifetimeTaps] forKey:@"lifetime"];
  [data setObject:lastReset forKey:@"lastReset"];
   
  NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"data.plist"];

  [data writeToFile:filePath atomically: YES];
}

@end