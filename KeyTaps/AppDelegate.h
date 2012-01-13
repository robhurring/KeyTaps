//
//  AppDelegate.h
//  KeyTaps
//
//  Created by Rob Hurring on 1/9/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTApp.h"

#define DATA_FILE @"KeyTaps.plist"
#define SESSION_CELL_HEIGHT CCFloat(33.0)

@class KTApp, KTSessionPanelController, KTResetPanelController;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (retain) id monitor;
@property (retain) IBOutlet NSMenu *appMenu;
@property (retain) IBOutlet NSTextField *charCountLabel;
@property (retain) IBOutlet NSTextField *lastResetLabel;
@property (retain) IBOutlet NSTextField *lifetimeLabel;
@property (retain) IBOutlet NSTableView *sessionsTableView;

@property (retain) NSNumberFormatter *numberFormatter;
@property (retain) NSDateFormatter *dateFormatter;

@property (retain) NSStatusItem *statusItem;
@property (retain) NSImage *menuImage;
@property (retain) NSImage *menuImageAlt;

@property (retain) KTApp *keyTaps;
@property (retain) NSString *dataFile;
@property (retain) KTSessionPanelController *sessionPanelController;
@property (retain) KTResetPanelController *resetPanelController;

- (IBAction)showResetPanel:(id)sender;
- (IBAction)showSessionPanel:(id)sender;

- (void)reset:(BOOL)all;
- (void)startMonitoring;
- (void)stopMonitoring;
- (void)update;

@end
