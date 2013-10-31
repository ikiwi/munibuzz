//
//  Stops.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Stops.h"

@implementation Stops

@synthesize uniqueId = _uniqueId;
@synthesize sTag = _sTag;
@synthesize dTag = _dTag;
@synthesize title = _title;
@synthesize sId = _sId;
@synthesize rId = _rId;

+ (id)stopsId:(NSString *)sTag title:(NSString *)title sId:(NSString *)sId dTag:(NSString *)dTag rId:(NSString*)rId
{
    Stops *newStop = [[self alloc] init];
    newStop.sTag = sTag;
    newStop.title = title;
    newStop.sId = sId;
    newStop.dTag = dTag;
    newStop.rId = rId;
    return newStop;
}

@end
