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

-(id)init
{
    self = [super init];
    return self;
}

-(Data *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        startLabel = [aDecoder decodeObjectForKey:@"startLabel"];
        destLabel = [aDecoder decodeObjectForKey:@"destLabel"];
        routeLabel = [aDecoder decodeObjectForKey:@"routeLabel"];
        useDefault = [aDecoder decodeObjectForKey:@"useDefault"];
        includeReturn = [aDecoder decodeObjectForKey:@"includeReturn"];
        repeatLabel = [aDecoder decodeObjectForKey:@"repeatLabel"];
        repeat_default_label = [aDecoder decodeObjectForKey:@"repeat_default_label"];
        remindLabel = [aDecoder decodeObjectForKey:@"remindLabel"];
        remind_default_label = [aDecoder decodeObjectForKey:@"remind_default_label"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)anEncoder {
    [anEncoder encodeObject:startLabel forKey:@"startLabel"];
    [anEncoder encodeObject:destLabel forKey:@"destLabel"];
    [anEncoder encodeObject:routeLabel forKey:@"routeLabel"];
    [anEncoder encodeObject:useDefault forKey:@"useDefault"];
    [anEncoder encodeObject:includeReturn forKey:@"includeReturn"];
    [anEncoder encodeObject:repeatLabel forKey:@"repeatLabel"];
    [anEncoder encodeObject:repeat_default_label forKey:@"repeat_default_label"];
    [anEncoder encodeObject:remindLabel forKey:@"remindLabel"];
    [anEncoder encodeObject:remind_default_label forKey:@"remind_default_label"];
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
