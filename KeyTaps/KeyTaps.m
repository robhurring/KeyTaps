//
//  KeyTaps.m
//  KeyTaps
//
//  Created by Robert Hurring on 1/11/12.
//  Copyright (c) 2012 Zerobased, LLC. All rights reserved.
//

#import "KeyTaps.h"
#import "KTSession.h"

#define MAX_SESSIONS 5;

@implementation KeyTaps

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
    
    NSLog(@"Current: %@", [NSNumber numberWithLongLong:currentSession.taps]);
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
  if(all)
    lifetime = 0LL;
  
  [currentSession reset];
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
