//
//  redButton.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "redButton.h"
#import "buzzData.h"

@implementation redButton
@synthesize buzz;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}


@end
