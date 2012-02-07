//
//  KTSession.m
//  KeyTaps
//
//  Created by Robert Hurring on 1/11/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "KTSession.h"

@implementation KTSession

@synthesize date, endDate;
@synthesize taps;

- (id)initWithCoder:(NSCoder *)coder
{
  return [self 
          initWithTaps:[coder decodeObjectForKey:@"taps"]
          andDate:[coder decodeObjectForKey:@"date"] 
          andEndDate:[coder decodeObjectForKey:@"endDate"]];
}

- (id)initWithTaps:(NSNumber *)myTaps andDate:(NSDate *)myDate andEndDate:(NSDate *)endDate
{
  if(self = [super init])
  {
    self.taps = myTaps;
    self.date = myDate;
  }
  return self;
}

-  (id)init
{
  return [self initWithTaps:[NSNumber numberWithUnsignedLong:0] andDate:[NSDate date] andEndDate:nil];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:date forKey:@"date"];
  [encoder encodeObject:taps forKey:@"taps"];
  [encoder encodeObject:endDate forKey:@"endDate"];
}

-(void) increment
{
  taps = [NSNumber numberWithUnsignedLong:[taps unsignedLongValue]+1];
}

@end
