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

NSInteger MAXTRIPS=20;
NSString *DEFAULTLABEL = @"location";

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
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"muniBuzz:"
                          message:notification.alertBody
                          delegate:self
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [BuzzViewController turnOffAlarm:notification];

    [alert show];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [Data saveAll:dataArray];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    dataArray = [Data getAll];
    NSLog(@"%d trips", totalTrip);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [Data saveAll:dataArray];
}

@end
