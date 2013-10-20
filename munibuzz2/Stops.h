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
    NSString *sTag;
    NSString *dTag;
    NSString *title;
    NSString *sId;
}

@property (nonatomic, copy) NSString *sTag;
@property (nonatomic, copy) NSString *dTag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sId;

+ (id)stopsId:(NSString*)sTag title:(NSString*)title sId:(NSString*)sId dTag:(NSString*)dTag;

@end
