//
//  KTSession.m
//  KeyTaps
//
//  Created by Robert Hurring on 1/11/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "KTSession.h"

@implementation KTSession

@synthesize date;
@synthesize taps;

- (id)initWithCoder:(NSCoder *)coder {
  return [self 
          initWithTaps:[coder decodeObjectForKey:@"taps"] 
          andDate:[coder decodeObjectForKey:@"date"]];
}

- (id)initWithTaps:(NSNumber *)myTaps andDate:(NSDate *)myDate
{
  if(self = [super init])
  {
    self.taps = [myTaps longLongValue];
    self.date = myDate;
  }
  return self;
}

-  (id)init
{
  return [self initWithTaps:[NSNumber numberWithLongLong:0] andDate:[[NSDate alloc] init]];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:date forKey:@"date"];
  [encoder encodeObject:[NSNumber numberWithLongLong:taps] forKey:@"taps"];
}

-(void) increment
{
  taps++;
}

-(void) reset
{
  taps = 0LL;
  date = [[NSDate alloc] init];
}

@end
