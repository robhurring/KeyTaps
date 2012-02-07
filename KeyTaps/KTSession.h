//
//  KTSession.h
//  KeyTaps
//
//  Created by Robert Hurring on 1/11/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTSession : NSObject <NSCoding>

@property (retain) NSDate *date;
@property (retain) NSDate *endDate;
@property (retain) NSNumber *taps;

- (id)initWithCoder:(NSCoder *)coder;
- (id)initWithTaps:(NSNumber *)myTaps andDate:(NSDate *)myDate andEndDate:(NSDate *)endDate;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (void)increment;

@end
