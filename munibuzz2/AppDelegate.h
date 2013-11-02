//
//  AppDelegate.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/11/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
NSMutableArray* dataArray;
NSInteger totalTrip;
NSInteger MAXTRIPS;
BOOL useDefaultSwitch;
UILocalNotification *alarmNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
