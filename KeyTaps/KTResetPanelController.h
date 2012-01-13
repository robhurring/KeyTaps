//
//  KTResetViewController.h
//  KeyTaps
//
//  Created by Robert Hurring on 1/13/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppDelegate;

@interface KTResetPanelController : NSViewController

@property (assign) AppDelegate *delegate;
@property (retain) IBOutlet NSPanel *resetPanel;

- (id)initWithDelegate:(AppDelegate *)appDelegate;
- (IBAction)resetSession:(id)sender;
- (IBAction)resetLifetime:(id)sender;

- (void)showPanel;
- (void)hidePanel;
@end
