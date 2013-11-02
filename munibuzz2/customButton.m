//
//  customButton.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/16/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "customButton.h"

@implementation customButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.titleLabel.text = @"-";
        self.tintColor = [UIColor whiteColor];
        self.alarm = [[UILocalNotification alloc] init];
        self.alarmOn = FALSE;
        self.alarm2 = [[UILocalNotification alloc] init];
        self.alarm2On = FALSE;
    }
    return self;
}

- (void)setBackground
{
    if (self.isOn) {
        [self setBackgroundColor:[UIColor orangeColor]];
    } else {
        [self setBackgroundColor:[UIColor redColor]];
    }
}

@end
