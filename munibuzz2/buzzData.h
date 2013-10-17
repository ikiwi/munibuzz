//
//  buzzData.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "customButton.h"

@interface buzzData : NSObject
{
    customButton *buzzButton;
    NSString *buzzMinute;
}

@property (nonatomic, strong) customButton *buzzButton;
@property (nonatomic, strong) NSString *buzzMinute;
@property (nonatomic, copy) NSString *minute;

+ (id)buzzId:(customButton*)buzzButton
  buzzMinute:(NSString*)buzzMinute;

@end
