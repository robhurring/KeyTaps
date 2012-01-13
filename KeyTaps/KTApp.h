//
//  KeyTaps.h
//  KeyTaps
//
//  Created by Robert Hurring on 1/11/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_SESSIONS 5
#define kTapsChangedEvent @"taps"

@class KTSession;

@interface KTApp : NSObject

@property (retain) NSMutableArray *sessions;
@property (retain) KTSession *currentSession;
@property (assign) long long lifetime;

-(id) initWithDataFile:(NSString *)path;
-(void) saveToFile:(NSString *)dataFile;
-(void) increment;
-(void) reset:(BOOL)all;

-(NSNumber *)getTaps;
-(NSDate *)getLastReset;
-(NSNumber *)getLifetime;

@end
