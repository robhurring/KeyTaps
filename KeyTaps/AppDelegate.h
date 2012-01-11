//
//  AppDelegate.h
//  KeyTaps
//
//  Created by Rob Hurring on 1/9/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DATA_FILE @"KeyTaps.plist"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (retain) id monitor;
@property (retain) IBOutlet NSMenu *appMenu;
@property (retain) IBOutlet NSTextField *charCountLabel;
@property (retain) IBOutlet NSTextField *lastResetLabel;
@property (retain) IBOutlet NSTextField *lifetimeLabel;
@property (retain) IBOutlet NSPanel *resetPanel;

@property (retain) NSNumberFormatter *numberFormatter;
@property (retain) NSDateFormatter *dateFormatter;

@property (retain) NSStatusItem *statusItem;
@property (retain) NSImage *menuImage;
@property (retain) NSImage *menuImageAlt;

@property (retain) NSDate *lastReset;

@property (assign) long long keyTaps;
@property (assign) long long lifetimeTaps;

-(IBAction) showResetPanel:(id)sender;
-(IBAction) resetSession:(id)sender;
-(IBAction) resetLifetime:(id)sender;

-(void) startMonitoring;
-(void) stopMonitoring;

-(void) update;
-(void) reset:(BOOL)lifetime;
-(void) save;
-(void) load;
- (NSString *)applicationSupportDirectory;

@end
