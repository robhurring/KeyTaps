//
//  KeyTaps.h
//  KeyTaps
//
//  Created by Robert Hurring on 1/11/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATA_FILE @"KeyTaps.plist"

@class KTSession;

@interface KeyTaps : NSObject

@property (retain) NSMutableArray *sessions;
@property (retain) KTSession *currentSession;
@property (assign) long long lifetimeCache;

-(id) initWithDataFile:(NSString *)path;
-(void) save:(NSString *)path;
-(void) increment;

@end
