//
//  AppDelegate.m
//  KeyTaps
//
//  Created by Rob Hurring on 1/9/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "KTApp.h"
#import "KTSession.h"
#import "KTSessionCell.h"
#import "KTSessionPanelController.h"
#import "KTResetPanelController.h"

@interface AppDelegate (PrivateMethods)
- (void)setupMenu;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView;
- (NSString *)applicationSupportDirectory;
@end

@implementation AppDelegate

@synthesize keyTaps;
@synthesize sessionPanelController, resetPanelController;
@synthesize dataFile;
@synthesize numberFormatter, dateFormatter;

@synthesize appMenu, statusItem;
@synthesize menuImage, menuImageAlt;
@synthesize monitor;

@synthesize charCountLabel;
@synthesize lastResetLabel;
@synthesize sessionsTableView;
@synthesize lifetimeLabel;
@synthesize lifetimeCountLabel;

# pragma mark App Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
  
  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

  dataFile = [[self applicationSupportDirectory] stringByAppendingPathComponent:DATA_FILE];
  keyTaps = [[KTApp alloc] initWithDataFile:dataFile];

  sessionPanelController = [[KTSessionPanelController alloc] initWithDelegate:self];
  resetPanelController = [[KTResetPanelController alloc] initWithDelegate:self];
  
  [keyTaps addObserver:self forKeyPath:kTapsChangedEvent options:NSKeyValueChangeReplacement context:nil];
 
  [self setupMenu];
  [self update];
  [self startMonitoring];
}

- (void)setupMenu
{
  menuImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"keytap.png"]];
  menuImageAlt = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"keytap-alt.png"]];
  
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:appMenu];
  [statusItem setImage:menuImage];
  [statusItem setAlternateImage:menuImageAlt];
  
  [statusItem setHighlightMode:YES];
  [statusItem setTarget:self];
}

-(void) applicationWillTerminate:(NSNotification *)notification
{
  [self stopMonitoring];
  [keyTaps saveToFile:dataFile];
  [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
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

# pragma mark Event Monitoring

-(void) startMonitoring
{
  monitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event)
  {
    [keyTaps increment];
  }];
}

-(void) stopMonitoring
{
  if(monitor)
    [NSEvent removeMonitor:monitor];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:kTapsChangedEvent])
  {
    [self update];
  }
}

# pragma mark Table view data source

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
  return NO;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  return [keyTaps.sessions count];
}

- (NSTableCellView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  NSString *output, *sessionEndDate;
  NSDateFormatterStyle oldFormatterStyle;
  
  KTSession *session = [keyTaps.sessions objectAtIndex:row];
  KTSessionCell *cell = [tableView makeViewWithIdentifier:@"SessionCell" owner:self];
    
  output = [numberFormatter stringFromNumber:session.taps];
  [cell.tapsLabel setTitleWithMnemonic:[NSString stringWithFormat:@"%@ Chars", output]];

  oldFormatterStyle = [dateFormatter dateStyle];
  [dateFormatter setDateStyle:kCFDateFormatterShortStyle];
  
  output = [dateFormatter stringFromDate:session.date];
  sessionEndDate = [dateFormatter stringFromDate:session.endDate];
  
  if(sessionEndDate)
  {
    [cell.dateLabel setTitleWithMnemonic:[NSString stringWithFormat:@"%@ - %@", output, sessionEndDate]];  
  }else{
    [cell.dateLabel setTitleWithMnemonic:[NSString stringWithFormat:@"On %@", output, sessionEndDate]];  
  }
  
  [dateFormatter setDateStyle:oldFormatterStyle];

  return cell;
  
}

# pragma mark Actions

- (void)reset:(BOOL)all
{
  [keyTaps reset:all];
  [sessionsTableView reloadData];
  [self update];
}

- (IBAction)showSessionPanel:(id)sender
{
  [sessionPanelController showPanel];
}

- (IBAction)showResetPanel:(id)sender
{
  [resetPanelController showPanel];
}

# pragma mark UI

-(void) update
{
  NSString *output = [numberFormatter stringFromNumber:keyTaps.currentSession.taps];
  [charCountLabel setTitleWithMnemonic:output];
  
  output = [numberFormatter stringFromNumber:keyTaps.lifetime];
  [lifetimeCountLabel setTitleWithMnemonic:output];
  
  output = [dateFormatter stringFromDate:keyTaps.currentSession.date];
  [lastResetLabel setTitleWithMnemonic:[NSString stringWithFormat:@"Chars since %@", output]];

  NSDateFormatterStyle _old_style = [dateFormatter dateStyle];
  [dateFormatter setDateStyle:kCFDateFormatterShortStyle];
  
  output = [dateFormatter stringFromDate:keyTaps.lifetimeLastReset];
  [lifetimeLabel setTitleWithMnemonic:[NSString stringWithFormat:@"Lifetime (%@)", output]];
  [dateFormatter setDateStyle:_old_style];
}

@end