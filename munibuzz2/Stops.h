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
    int _key;
    NSString *_sTag;
    NSString *_dTag;
    NSString *_title;
    NSString *_sId;
    NSString *_rId;
}

@property (nonatomic,assign) int key;
@property (nonatomic, copy) NSString *sTag;
@property (nonatomic, copy) NSString *dTag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sId;
@property (nonatomic, copy) NSString *rId;

+ (id)stopsId:(int)key sTag:(NSString*)sTag title:(NSString*)title sId:(NSString*)sId dTag:(NSString*)dTag rId:(NSString*)rId;

@end
