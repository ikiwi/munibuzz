//
//  Stops.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Stops.h"

@implementation Stops

@synthesize sTag;
@synthesize dTag;
@synthesize title;
@synthesize sId;

+ (id)stopsId:(NSString *)sTag title:(NSString *)title sId:(NSString *)sId dTag:(NSString *)dTag
{
    Stops *newStop = [[self alloc] init];
    newStop.sTag = sTag;
    newStop.title = title;
    newStop.sId = sId;
    newStop.dTag = dTag;
    return newStop;
}

@end
