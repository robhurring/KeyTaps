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
@synthesize resetPanel;
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
  
  NSString *tmp = [self applicationSupportDirectory];
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

-(IBAction) showResetPanel:(id)sender
{
  [resetPanel setIsVisible:YES];
}

-(IBAction) resetSession:(id)sender
{
  [self reset:NO];
  [resetPanel setIsVisible:NO];
}

-(IBAction) resetLifetime:(id)sender
{
  [self reset:YES];
  [resetPanel setIsVisible:NO];
}

-(void)reset:(BOOL)lifetime
{
  keyTaps = 0LL;

  if(lifetime)
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
  NSString *filePath = [[self applicationSupportDirectory] stringByAppendingPathComponent:DATA_FILE];
  NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:filePath];
  
  keyTaps = [[data objectForKey:@"taps"] longLongValue];
  lastReset = [data objectForKey:@"lastReset"];
  lifetimeTaps = [[data objectForKey:@"lifetime"] longLongValue];
  
  if(!keyTaps)
    keyTaps = 0LL;
  
  if(!lifetimeTaps)
    lifetimeTaps = keyTaps;
  
  if(!lastReset)
    lastReset = [[NSDate alloc] init];
      
  [self update];
}

-(void) save
{
  NSString *filePath = [[self applicationSupportDirectory] stringByAppendingPathComponent:DATA_FILE];

  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:[NSNumber numberWithLongLong:keyTaps] forKey:@"taps"];
  [data setObject:[NSNumber numberWithLongLong:lifetimeTaps] forKey:@"lifetime"];
  [data setObject:lastReset forKey:@"lastReset"];
  
  [data writeToFile:filePath atomically: YES];
}

- (NSString *)applicationSupportDirectory
{
  NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
  NSString *path = [basePath stringByAppendingPathComponent:executableName];

  // create directory if it doesn't exist
  NSFileManager *fileManager = [NSFileManager defaultManager];

  NSError *error;
  if(![fileManager fileExistsAtPath:path isDirectory:NULL])
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];

  if(error)
    NSLog(@"Couldn't create application support directory!");
  
  return path;
}

@end