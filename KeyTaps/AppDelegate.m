//
//  AppDelegate.m
//  KeyTaps
//
//  Created by Rob Hurring on 1/9/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "KeyTaps.h"
#import "KTSession.h"

@implementation AppDelegate

@synthesize keyTaps;
@synthesize dataFile;

@synthesize charCountLabel;
@synthesize lastResetLabel;
@synthesize lifetimeLabel;
@synthesize resetPanel;
@synthesize appMenu;
@synthesize statusItem;
@synthesize monitor;
@synthesize menuImage;
@synthesize menuImageAlt;
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

  dataFile = [[self applicationSupportDirectory] stringByAppendingPathComponent:DATA_FILE];
  keyTaps = [[KeyTaps alloc] initWithDataFile:dataFile];
  [self update];
  
  [self startMonitoring];
}

-(void) applicationWillTerminate:(NSNotification *)notification
{
  [self stopMonitoring];
  [keyTaps saveToFile:dataFile];
  [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

# pragma mark Event Monitoring

-(void) startMonitoring
{
  monitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event)
  {
    [keyTaps increment];
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
  [keyTaps reset:NO];
  [resetPanel setIsVisible:NO];
  [self update];
}

-(IBAction) resetLifetime:(id)sender
{
  [keyTaps reset:YES];
  [resetPanel setIsVisible:NO];
  [self update];
}

-(void) update
{
  NSString *output = [numberFormatter stringFromNumber:[keyTaps getTaps]];
  [charCountLabel setTitleWithMnemonic:output];
  
  output = [numberFormatter stringFromNumber:[keyTaps getLifetime]];
  [lifetimeLabel setTitleWithMnemonic:output];
  
  output = [dateFormatter stringFromDate:[keyTaps getLastReset]];
  [lastResetLabel setTitleWithMnemonic:[NSString stringWithFormat:@"Chars since %@", output]];
}

# pragma mark Persistence

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