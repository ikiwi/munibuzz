//
//  AppDelegate.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/11/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString * startLabel;
NSString * destLabel;
NSString * routeLabel;
NSString * useDefault;
NSString * includeReturn;
NSString * repeatLabel;
NSString * repeat_default_label;
NSString * remindLabel;
NSString * remind_default_label;
BOOL useDefaultSwitch;
BOOL includeReturnSwitch;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
