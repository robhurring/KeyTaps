//
//  KeyTaps.m
//  KeyTaps
//
//  Created by Robert Hurring on 1/11/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "KTApp.h"
#import "KTSession.h"

@implementation KTApp

@synthesize currentSession;
@synthesize sessions;
@synthesize lifetime;

-(id) initWithDataFile:(NSString *)path
{
  if(self = [self init])
  {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path])
    {
      NSData *data = [[NSData alloc] initWithContentsOfFile:path];
      NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
      
      currentSession = [unarchiver decodeObjectForKey:@"currentSession"];
      sessions = [unarchiver decodeObjectForKey:@"sessions"];
      lifetime = [[unarchiver decodeObjectForKey:@"lifetime"] longLongValue];      
      [unarchiver finishDecoding];
    }
  }
  
  return self;
}

-(id) init
{
  if(self = [super init])
  {
    lifetime = 0LL;
    currentSession = [[KTSession alloc] init];
    sessions = [NSMutableArray array];
  }
  
  return self;
}

-(void) saveToFile:(NSString *)dataFile
{
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];          
  
  [archiver encodeObject:currentSession forKey:@"currentSession"];
  [archiver encodeObject:sessions forKey:@"sessions"];
  [archiver encodeObject:[NSNumber numberWithLongLong:lifetime] forKey:@"lifetime"];
  [archiver finishEncoding];
  
  [data writeToFile:dataFile atomically:YES];
}

-(void) increment
{
  lifetime++;
  [currentSession increment];
}

-(void) reset:(BOOL)all
{
  // delete all sessions & the lifetime count
  if(all)
  {
    lifetime = 0LL;
    sessions = [NSMutableArray array];
    currentSession = [[KTSession alloc] init];
    return;
  }

  // add to our sessions list if we have >0 taps
  if(currentSession.taps > 0)
  {
    // get my "dateOnly"
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:currentSession.date];
    NSDate* currentDateOnly = [calendar dateFromComponents:components];
    
    // check all existing sessions and compare dates
    NSDate *compareDateOnly;
    KTSession *matched;
    for(KTSession *s in sessions)
    {
      if(s != currentSession)
      {
        components = [calendar components:flags fromDate:s.date];
        compareDateOnly = [calendar dateFromComponents:components];

        if(currentDateOnly == compareDateOnly)
        {
          matched = s;
          break;
        }
      }
    }

    // merge current session with existing taps
    if(matched)
    {
      matched.taps += currentSession.taps;
    }else{
      [sessions addObject:currentSession];      
    }
    
    if([sessions count] > MAX_SESSIONS)
    {
      int end = (int)[sessions count] - MAX_SESSIONS;
      [sessions removeObjectsInRange:NSMakeRange(0, end)];
    }
  }
      
  currentSession = [[KTSession alloc] init];
}

-(NSDate *)getLastReset
{
  return currentSession.date;
}

-(NSNumber *)getTaps
{
  return [NSNumber numberWithLongLong:currentSession.taps];
}

-(NSNumber *)getLifetime
{
  return [NSNumber numberWithLongLong:lifetime];
}

@end
