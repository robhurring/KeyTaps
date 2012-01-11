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
@synthesize lifetimeCache;

-(id) initWithDataFile:(NSString *)path
{
  if(self = [self init])
  {
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    self.currentSession = [unarchiver decodeObjectForKey:@"currentSession"];
    self.sessions = [unarchiver decodeObjectForKey:@"sessions"];
      
    [unarchiver finishDecoding];
  }
  
  return self;
}

-(id) init
{
  if(self = [super init])
  {
    lifetimeCache = 0LL;
    currentSession = [[KTSession alloc] init];
    sessions = [NSMutableArray array];
    [sessions addObject:[[KTSession alloc] initWithTaps:[NSNumber numberWithLongLong:10] andDate:[[NSDate alloc] init]]];
  }
  
  return self;
}

-(void) save:(NSString *)path
{
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];          

  [archiver encodeObject:currentSession forKey:@"currentSession"];
  [archiver encodeObject:sessions forKey:@"sessions"];
  [archiver finishEncoding];
  
  [data writeToFile:path atomically:YES];
}

-(void) increment
{
  lifetimeCache++;
  [currentSession increment];
}

@end
