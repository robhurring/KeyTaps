//
//  KTSessionPanelController.m
//  KeyTaps
//
//  Created by Robert Hurring on 1/12/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "KTSessionPanelController.h"
#import "AppDelegate.h"
#import "KTApp.h"

@interface KTSessionPanelController (PrivateMethods)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end

@implementation KTSessionPanelController

@synthesize sessionPanel, tapsLabel, delegate;

- (id)initWithDelegate:(AppDelegate *)appDelegate
{
  if(self = [self initWithNibName:@"KTSessionPanel" bundle:nil])
  {
    self.delegate = appDelegate;
    [self.delegate.keyTaps addObserver:self forKeyPath:kTapsChangedEvent options:NSKeyValueChangeReplacement context:nil];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
      [self loadView];
    }
    
    return self;
}

- (void)showPanel
{
  [self.sessionPanel setIsVisible:YES];
}

- (IBAction)resetSession:(id)sender
{
  [delegate reset:NO];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:kTapsChangedEvent])
  {
    NSString *output = [delegate.numberFormatter stringFromNumber:[delegate.keyTaps getTaps]];
    [tapsLabel setTitleWithMnemonic:output];
  }
}

@end
