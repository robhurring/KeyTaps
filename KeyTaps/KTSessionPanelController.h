//
//  KTSessionPanelController.h
//  KeyTaps
//
//  Created by Robert Hurring on 1/12/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppDelegate;

@interface KTSessionPanelController : NSViewController

@property (retain) IBOutlet NSPanel *sessionPanel;
@property (retain) IBOutlet NSTextField *tapsLabel;
@property (assign) AppDelegate *delegate;

- (id)initWithDelegate:(AppDelegate *)appDelegate;
- (void)showPanel;
- (IBAction)resetSession:(id)sender;

@end
