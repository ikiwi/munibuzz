//
//  customButton.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/16/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customButton : UIButton
@property UILocalNotification *alarm;
@property UILocalNotification *alarm2;
@property BOOL isOn;
@property BOOL alarmOn;
@property BOOL alarm2On;
-(void)setBackground;
@end
