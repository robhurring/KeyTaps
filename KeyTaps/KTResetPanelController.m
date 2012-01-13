//
//  KTResetViewController.m
//  KeyTaps
//
//  Created by Robert Hurring on 1/13/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "KTResetPanelController.h"
#import "AppDelegate.h"

@implementation KTResetPanelController

@synthesize delegate;
@synthesize resetPanel;

- (id)initWithDelegate:(AppDelegate *)appDelegate
{
  if(self = [self initWithNibName:@"KTResetPanel" bundle:nil])
  {
    self.delegate = appDelegate;
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      [self loadView];
    }
    
    return self;
}

- (IBAction)resetSession:(id)sender
{
  [delegate reset:NO];
  [self hidePanel];
}

- (IBAction)resetLifetime:(id)sender
{
  [delegate reset:YES];
  [self hidePanel];
}

- (void)showPanel
{
  [resetPanel setIsVisible:YES];
}

- (void)hidePanel
{
  [resetPanel setIsVisible:NO];  
}

@end
