//
//  AppDelegate.h
//  KeyTaps
//
//  Created by Rob Hurring on 1/9/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyTaps.h"

#define DATA_FILE @"KeyTaps.plist"

@class KeyTaps;

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

@property (retain) KeyTaps *keyTaps;
@property (retain) NSString *dataFile;

-(IBAction) showResetPanel:(id)sender;
-(IBAction) resetSession:(id)sender;
-(IBAction) resetLifetime:(id)sender;

-(void) startMonitoring;
-(void) stopMonitoring;

-(void) updateSessions;
-(void) update;
- (NSString *)applicationSupportDirectory;

@end
