//
//  Stops.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Stops.h"

@implementation Stops

@synthesize num;
@synthesize name;

+ (id)stopsId:(NSString *)num name:(NSString *)name
{
    Stops *newStop = [[self alloc] init];
    newStop.num = num;
    newStop.name = name;
    return newStop;
}

@end
