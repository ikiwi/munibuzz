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
        self.isOn = FALSE;
        [self setBackground];
        self.titleLabel.text = @"-";
        self.titleLabel.frame = CGRectMake(30, 0, 25, 25);
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        self.alarm = [[UILocalNotification alloc] init];
#ifdef REPEAT
        self.alarmOn = FALSE;
        self.alarm2 = [[UILocalNotification alloc] init];
        self.alarm2On = FALSE;
#endif
    }
    return self;
}

- (void)setBackground
{
    if (self.isOn) {
        [self setBackgroundImage:[UIImage imageNamed:@"alarmset.png"] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage imageNamed:@"alarmunset.png"] forState:UIControlStateNormal];
    }
}

@end
