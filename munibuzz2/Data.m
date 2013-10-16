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

+(void)saveData:(Data *)aData
{
    [NSKeyedArchiver archiveRootObject:aData toFile:[Data getPathToArchive]];
}

+(Data *)getData
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Data getPathToArchive]];
}

-(id)init
{
    self = [super init];
    if (self) {
        NSLog(@"initializing data");
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

+ (NSString *)getPathToArchive
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingString:@"data.model"];
}
@end
