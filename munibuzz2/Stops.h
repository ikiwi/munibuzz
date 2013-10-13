//
//  Stops.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stops : NSObject
{
    NSString *num;
    NSString *name;
}

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *name;

+ (id)stopsId:(NSString*)num name:(NSString*)name;

@end
