//
//  AppDelegate.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/11/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "AppDelegate.h"
#import "NavController.h"
#import "BuzzViewController.h"
#import "Data.h"
#import "customButton.h"
#import "RoutesDatabase.h"
#import "Stops.h"
#import <AudioToolbox/AudioToolbox.h>

NSInteger MAXTRIPS=20;
NSString *DEFAULTLABEL = @"location";
NSInteger alarmCount;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0) {
        [app cancelAllLocalNotifications];
    }
    alarmNotification = nil;

    totalTrip = MAXTRIPS;
    dataArray = [Data getAll];
    // Reset the Icon Alert Number back to Zero
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void) application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    AudioServicesPlaySystemSound (1304);

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"muniBuzz:"
                          message:notification.alertBody
                          delegate:self
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [alert show];
    [BuzzViewController turnOffAlarm:notification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    alarmCount = [eventArray count];
    [Data saveAll:dataArray];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [BuzzViewController recalAlarms:alarmCount];
    
    dataArray = [Data getAll];

    [buzz refresh];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [Data saveAll:dataArray];
}

@end
