//
//  buzzData.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "buzzData.h"

@implementation buzzData

@synthesize buzzButton;
@synthesize buzzMinute;
@synthesize minute;

+ (id)buzzId:(UIButton*)buzzButton
  buzzMinute:(NSString*)buzzMinute
{
    buzzData *newBuzz = [[self alloc] init];
    
    newBuzz.buzzMinute = buzzMinute;
    newBuzz.buzzButton = buzzButton;
    newBuzz.buzzButton.backgroundColor = [UIColor redColor];
    newBuzz.buzzButton.tintColor = [UIColor whiteColor];
    [newBuzz.buzzButton setTitle:buzzMinute forState:UIControlStateNormal];

    return newBuzz;
}

@end
