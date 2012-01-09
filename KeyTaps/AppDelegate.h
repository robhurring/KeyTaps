//
//  AppDelegate.h
//  KeyTaps
//
//  Created by Rob Hurring on 1/9/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (retain) id monitor;
@property (retain) IBOutlet NSMenu *appMenu;
@property (retain) IBOutlet NSTextField *charCountLabel;
@property (retain) IBOutlet NSTextField *lastResetLabel;

@property (retain) NSNumberFormatter *formatter;
@property (retain) NSStatusItem *statusItem;
@property (retain) NSImage *menuImage;
@property (retain) NSImage *menuImageAlt;

@property (retain) NSDate *lastReset;
@property (assign) long long keyTaps;

-(IBAction) reset:(id)sender;

-(void) startMonitoring;
-(void) stopMonitoring;

-(void) update;
-(void) reset;
-(void) save;
-(void) load;

@end
