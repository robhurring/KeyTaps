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
@property (retain) NSNumberFormatter *formatter;
@property (retain) NSStatusItem *statusItem;
@property (retain) IBOutlet NSMenu *appMenu;
@property (retain) IBOutlet NSMenuItem *menuLabel;
@property (assign) long long keyTaps;

-(IBAction) quit:(id)sender;
-(IBAction) reset:(id)sender;

-(void) startMonitoring;
-(void) stopMonitoring;

-(void) update;
-(void) reset;
-(void) save;
-(void) load;

@end
