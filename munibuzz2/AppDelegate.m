//
//  AppDelegate.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/11/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "AppDelegate.h"
#import "NavController.h"
#import "Data.h"

NSInteger MAXTRIPS=20;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0) {
        [app cancelAllLocalNotifications];
    }

    totalTrip = MAXTRIPS;
    dataArray = [Data getAll];
    // Reset the Icon Alert Number back to Zero
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"muniBuzz:"
                          message:notification.alertBody
                          delegate:self
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    //    [alert release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
    if (useDefaultSwitch == TRUE) {
        [data.useDefault setString:@"YES"];
    } else {
        [data.useDefault setString:@"NO"];
    }
    if (includeReturnSwitch == TRUE) {
        [data.includeReturn setString:@"YES"];
    } else {
        [data.includeReturn setString:@"NO"];
    }
    */

    [Data saveAll:dataArray];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    dataArray = [Data getAll];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
    if (useDefaultSwitch == TRUE) {
        [data.useDefault setString:@"YES"];
    } else {
        [data.useDefault setString:@"NO"];
    }
    if (includeReturnSwitch == TRUE) {
        [data.includeReturn setString:@"YES"];
    } else {
        [data.includeReturn setString:@"NO"];
    }
    */
    
    [Data saveAll:dataArray];
}

@end
