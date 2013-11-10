//
//  customButton.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/16/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customButton : UIButton {
    UILocalNotification *_alarm;
#ifdef REPEAT
    UILocalNotification *_alarm2;
#endif
    BOOL _isOn;
#ifdef REPEAT
    BOOL _alarmOn;
    BOOL _alarm2On;
#endif
}

@property UILocalNotification *alarm;
#ifdef REPEAT
@property UILocalNotification *alarm2;
#endif
@property BOOL isOn;
#ifdef REPEAT
@property BOOL alarmOn;
@property BOOL alarm2On;
#endif

-(void)setBackground;

@end
