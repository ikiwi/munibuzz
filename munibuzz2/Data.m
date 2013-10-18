//
//  Data.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/15/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Data.h"
#import "AppDelegate.h"

@implementation Data

+(void)saveData:(Data *)aData filename:(NSString *)filename
{
    [NSKeyedArchiver archiveRootObject:aData toFile:[Data getPathToArchive:filename]];
}

+(void)saveAll:(NSArray *)aArray
{
    Data *tmp;
    
    for (NSInteger idx = 0; idx < totalTrip; idx++)
    {
        tmp = [aArray objectAtIndex:idx];
        [Data saveData:tmp filename:[NSString stringWithFormat:@"data%ld.model",idx]];
    }
}

+(void)removeData:(NSInteger)slot
{
    NSString *sf;
    NSString *df = [NSString stringWithFormat:@"data%ld.model",slot];
    Data *src;
    Data *dst = [Data getData:df];
    for (NSInteger idx = slot+1; idx < totalTrip; idx++) {
        sf = [NSString stringWithFormat:@"data%ld.model",idx];
        src = [Data getData:sf];
        [Data saveData:src filename:df];
        df = sf;
        dst = src;
    }
    src.startLabel = src.destLabel;
    [Data saveData:src filename:sf];
    totalTrip--;
}
+(Data *)getData:(NSString *)filename
{
    Data *retrievedData = (Data*)[NSKeyedUnarchiver unarchiveObjectWithFile:[Data getPathToArchive:filename]];
    if (retrievedData.startLabel == retrievedData.destLabel)
        return nil;
    else return retrievedData;
}

+(NSMutableArray *)getAll
{
    Data *tmp;
    NSMutableArray *tmpArray;
    NSInteger idx;
    
    for (idx = 0; idx < totalTrip; idx++)
    {
        NSLog(@"getting stuff from data%ld", idx);
        tmp = [Data getData:[NSString stringWithFormat:@"data%ld.model",idx]];
        if (tmp == nil) break;
        [tmpArray addObject:tmp];
    }
    totalTrip = idx;
    
    return tmpArray;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.startLabel = [NSMutableString stringWithString:@"location"];
        self.destLabel = [NSMutableString stringWithString:@"location"];
        self.routeLabel = [NSMutableString stringWithString:@""];
        self.useDefault = [NSMutableString stringWithString:@"YES"];
        self.includeReturn = [NSMutableString stringWithString:@"NO"];
        self.repeatLabel = [NSMutableString stringWithString:@""];
        self.repeat_default_label = [NSMutableString stringWithString:@""];
        self.remindLabel = [NSMutableString stringWithString:@""];
        self.remind_default_label = [NSMutableString stringWithString:@""];
    }
    return self;
}

-(Data *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.startLabel = [aDecoder decodeObjectForKey:@"startLabel"];
        self.destLabel = [aDecoder decodeObjectForKey:@"destLabel"];
        self.routeLabel = [aDecoder decodeObjectForKey:@"routeLabel"];
        self.useDefault = [aDecoder decodeObjectForKey:@"useDefault"];
        self.includeReturn = [aDecoder decodeObjectForKey:@"includeReturn"];
        self.repeatLabel = [aDecoder decodeObjectForKey:@"repeatLabel"];
        self.repeat_default_label = [aDecoder decodeObjectForKey:@"repeat_default_label"];
        self.remindLabel = [aDecoder decodeObjectForKey:@"remindLabel"];
        self.remind_default_label = [aDecoder decodeObjectForKey:@"remind_default_label"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)anEncoder {
    [anEncoder encodeObject:self.startLabel forKey:@"startLabel"];
    [anEncoder encodeObject:self.destLabel forKey:@"destLabel"];
    [anEncoder encodeObject:self.routeLabel forKey:@"routeLabel"];
    [anEncoder encodeObject:self.useDefault forKey:@"useDefault"];
    [anEncoder encodeObject:self.includeReturn forKey:@"includeReturn"];
    [anEncoder encodeObject:self.repeatLabel forKey:@"repeatLabel"];
    [anEncoder encodeObject:self.repeat_default_label forKey:@"repeat_default_label"];
    [anEncoder encodeObject:self.remindLabel forKey:@"remindLabel"];
    [anEncoder encodeObject:self.remind_default_label forKey:@"remind_default_label"];
}

+ (NSString *)getPathToArchive:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingString:filename];
}
@end
