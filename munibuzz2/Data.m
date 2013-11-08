//
//  Data.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/15/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Data.h"
#import "AppDelegate.h"

NSString *DATADIR = @"munibuzz";

@implementation Data

+(void)saveData:(Data *)aData
       filename:(NSString *)filename
{
    if (aData == nil) return;
    [NSKeyedArchiver archiveRootObject:aData toFile:[Data getPathToArchive:filename]];
}

+(void)saveAll:(NSArray *)aArray
{
    Data *tmp;
    for (NSInteger idx = 0; idx < totalTrip; idx++)
    {
        tmp = [aArray objectAtIndex:idx];
        [Data saveData:tmp filename:[NSString stringWithFormat:@"data%d.model",idx]];
    }
}

+(void)removeData:(NSInteger)slot
{
    NSString *sf;
    NSString *df = [NSString stringWithFormat:@"data%d.model",slot];
    Data *src;
    Data *dst = [Data getData:df];
    for (NSInteger idx = slot+1; idx < totalTrip; idx++) {
        sf = [NSString stringWithFormat:@"data%d.model",idx];
        src = [Data getData:sf];
        [Data saveData:src filename:df];
        df = sf;
        dst = src;
    }
    //resetting startlabel & destlabel to indicate obsolete data
    dst.startLabel = [NSMutableString stringWithString:DEFAULTLABEL];
    dst.destLabel = [NSMutableString stringWithString:DEFAULTLABEL];
    [Data saveData:dst filename:df];
    totalTrip--;
}

+(Data *)getData:(NSString *)filename
{
    Data *retrievedData = (Data*)[NSKeyedUnarchiver unarchiveObjectWithFile:
                                  [Data getPathToArchive:filename]];
    if ([retrievedData.startLabel isEqualToString:DEFAULTLABEL] &&
        [retrievedData.destLabel isEqualToString:DEFAULTLABEL]) {
        return nil;
    }
    return retrievedData;
}

+(NSMutableArray *)getAll
{
    Data *tmp;
    NSMutableArray *tmpArray;
    NSInteger idx;
    
    for (idx = 0; idx < MAXTRIPS; idx++)
    {
        tmp = [Data getData:[NSString stringWithFormat:@"data%d.model",idx]];
        if (tmp == nil || [tmp.startLabel isEqual:[NSMutableString stringWithString:DEFAULTLABEL]])
            break;
        [tmpArray addObject:tmp];
    }
    totalTrip = idx;
    
    return tmpArray;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.startLabel = [NSMutableString stringWithString:DEFAULTLABEL];
        self.startStopTag = [NSMutableString stringWithString:@"0"];
        self.startStopId = [NSMutableString stringWithString:@"0"];
        self.destLabel = [NSMutableString stringWithString:DEFAULTLABEL];
        self.routeId = [NSMutableString stringWithString:@" "];
        self.dirTag = [NSMutableString stringWithString:@" "];
#ifdef USEDEFAULT
        self.useDefault = [NSMutableString stringWithString:@"YES"];
#endif
#ifdef REPEAT
        self.repeatLabel = [NSMutableString stringWithString:@"Never"];
        self.repeat_default_label = [NSMutableString stringWithString:@""];
#endif
        self.remindLabel = [NSMutableString stringWithString:@"None"];
#ifdef USEDEFAULT
        self.remind_default_label = [NSMutableString stringWithString:@""];
#endif
        self.alarm = [NSMutableString stringWithString:@""];
    }
    return self;
}

-(Data *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.startLabel = [aDecoder decodeObjectForKey:@"startLabel"];
        self.startStopTag = [aDecoder decodeObjectForKey:@"startStopTag"];
        self.startStopId = [aDecoder decodeObjectForKey:@"startStopId"];
        self.destLabel = [aDecoder decodeObjectForKey:@"destLabel"];
        self.routeId = [aDecoder decodeObjectForKey:@"routeId"];
        self.dirTag = [aDecoder decodeObjectForKey:@"dirTag"];
#ifdef USEDEFAUT
        self.useDefault = [aDecoder decodeObjectForKey:@"useDefault"];
#endif
#ifdef REPEAT
        self.repeatLabel = [aDecoder decodeObjectForKey:@"repeatLabel"];
        self.repeat_default_label = [aDecoder decodeObjectForKey:@"repeat_default_label"];
#endif
        self.remindLabel = [aDecoder decodeObjectForKey:@"remindLabel"];
#ifdef USEDEFAULT
        self.remind_default_label = [aDecoder decodeObjectForKey:@"remind_default_label"];
#endif
        self.alarm = [aDecoder decodeObjectForKey:@"alarm"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)anEncoder {
    [anEncoder encodeObject:self.startLabel forKey:@"startLabel"];
    [anEncoder encodeObject:self.startStopTag forKey:@"startStopTag"];
    [anEncoder encodeObject:self.startStopId forKey:@"startStopId"];
    [anEncoder encodeObject:self.destLabel forKey:@"destLabel"];
    [anEncoder encodeObject:self.routeId forKey:@"routeId"];
    [anEncoder encodeObject:self.dirTag forKey:@"dirTag"];
#ifdef USEDEFAULT
    [anEncoder encodeObject:self.useDefault forKey:@"useDefault"];
#endif
#ifdef REPEAT
    [anEncoder encodeObject:self.repeatLabel forKey:@"repeatLabel"];
    [anEncoder encodeObject:self.repeat_default_label forKey:@"repeat_default_label"];
#endif
    [anEncoder encodeObject:self.remindLabel forKey:@"remindLabel"];
#ifdef USEDEFAULT
    [anEncoder encodeObject:self.remind_default_label forKey:@"remind_default_label"];
#endif
}

+ (NSString *)getPathToArchive:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSError *error;
    docsDir = [docsDir stringByAppendingPathComponent:DATADIR];
    [[NSFileManager defaultManager] createDirectoryAtPath:
     docsDir withIntermediateDirectories:YES attributes:nil error:&error];
    
    return [docsDir stringByAppendingPathComponent:filename];
}

@end
