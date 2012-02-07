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
@synthesize lifetimeLastReset;

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
      lifetime = [unarchiver decodeObjectForKey:@"lifetime"];
      lifetimeLastReset = [unarchiver decodeObjectForKey:@"lifetimeLastReset"];
      [unarchiver finishDecoding];
      [self reverseSessions];
    }
  }
  
  return self;
}

-(id) init
{
  if(self = [super init])
  {
    lifetime = [NSNumber numberWithUnsignedLong:0L];
    lifetimeLastReset = [NSDate date];
    currentSession = [[KTSession alloc] init];
    sessions = [NSMutableArray array];
  }
  
  return self;
}

- (void)reverseSessions
{
  NSMutableArray *tmp;
  tmp = (NSMutableArray *)[[sessions reverseObjectEnumerator] allObjects];
  self.sessions = tmp;
}

-(void) saveToFile:(NSString *)dataFile
{
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];          
  
  [archiver encodeObject:currentSession forKey:@"currentSession"];
  [archiver encodeObject:sessions forKey:@"sessions"];
  [archiver encodeObject:lifetime forKey:@"lifetime"];
  [archiver encodeObject:lifetimeLastReset forKey:@"lifetimeLastReset"];
  [archiver finishEncoding];
  
  [data writeToFile:dataFile atomically:YES];
}

-(void) increment
{
  [self willChangeValueForKey:kTapsChangedEvent];
  lifetime = [NSNumber numberWithUnsignedLong:[lifetime unsignedLongValue]+1];
  [currentSession increment];
  [self didChangeValueForKey:kTapsChangedEvent];
}

-(void) reset:(BOOL)all
{
  [self willChangeValueForKey:kTapsChangedEvent];

  // set our end date for the current session
  currentSession.endDate = [NSDate date];
  
  // delete all sessions & the lifetime count
  if(all)
  {
    lifetime = [NSNumber numberWithUnsignedLong:0];
    lifetimeLastReset = [NSDate date];
    sessions = [NSMutableArray array];
    currentSession = [[KTSession alloc] init];
    return;
  }

  // add to our sessions list if we have >0 taps
  if([currentSession.taps unsignedLongValue] > 0)
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
      unsigned long tmp1, tmp2;
      tmp1 = [matched.taps unsignedLongValue];
      tmp2 = [currentSession.taps unsignedLongValue];
      matched.taps = [NSNumber numberWithUnsignedLong:tmp1 + tmp2];      
    }else{
      [sessions addObject:currentSession];  
      [self reverseSessions];
    }
    
    if([sessions count] > MAX_SESSIONS)
    {
      int end = (int)[sessions count] - MAX_SESSIONS;
      [sessions removeObjectsInRange:NSMakeRange(0, end)];
    }
  }

  currentSession = [[KTSession alloc] init];
  
  [self didChangeValueForKey:kTapsChangedEvent];
}

@end
