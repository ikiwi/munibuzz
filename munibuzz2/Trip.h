//
//  Trip.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject
{
    NSString *name;
    NSString *desc;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

+ (id)tripId:(NSString*)name desc:(NSString*)desc;
@end
