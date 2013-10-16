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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [NSKeyedUnarchiver unarchiveObjectWithFile:[Data getPathToArchive]];
    
    if (![startLabel length])
        startLabel = @"location";
    if (![destLabel length])
        destLabel = @"location";
    
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    Data *data = [[Data alloc] init];
    data.startLabel = startLabel;
    data.destLabel = destLabel;
    data.routeLabel = routeLabel;
    useDefaultSwitch == TRUE ? data.useDefault = @"YES" : @"NO";
    includeReturnSwitch == TRUE ? data.includeReturn = @"YES" : @"NO";
    data.repeatLabel = repeatLabel;
    data.repeat_default_label = repeat_default_label;
    data.remindLabel = remindLabel;
    data.remind_default_label = remind_default_label;
    
    [NSKeyedArchiver archiveRootObject:data toFile:[Data getPathToArchive]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     
    Data *data = [[Data alloc] init];
    data.startLabel = startLabel;
    data.destLabel = destLabel;
    data.routeLabel = routeLabel;
    useDefaultSwitch == TRUE ? data.useDefault = @"YES" : @"NO";
    includeReturnSwitch == TRUE ? data.includeReturn = @"YES" : @"NO";
    data.repeatLabel = repeatLabel;
    data.repeat_default_label = repeat_default_label;
    data.remindLabel = remindLabel;
    data.remind_default_label = remind_default_label;
    
    [NSKeyedArchiver archiveRootObject:data toFile:[Data getPathToArchive]];
}

@end
