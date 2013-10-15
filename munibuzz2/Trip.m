//
//  Trip.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Trip.h"

@implementation Trip
@synthesize name;
@synthesize desc;
@synthesize cell;

+ (id)tripId:(NSString *)name desc:(NSString *)desc cell:(UITableViewCell *)cell
{
    Trip *newTrip = [[self alloc] init];
    newTrip.name = name;
    newTrip.desc = desc;
    newTrip.cell = cell;
    return newTrip;
}

@end
