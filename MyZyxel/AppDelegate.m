//
//  AppDelegate.m
//  MyZyxel
//
//  Created by line on 2017/5/12.
//  Copyright © 2017年 Zyxel. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     Override point for customization after application launch.
//    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)
//    {
//        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil]];
//        [[UIApplication sharedApplication]registerForRemoteNotifications];
//    }
//    else
//    {
//        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
    [application registerUserNotificationSettings: [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert categories: nil]];
    if (launchOptions != nil)
    {
//        NSLog(@"Launched from notifciation");
        NSDictionary *notification  = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"%@", [[notification objectForKey: @"aps"]objectForKey: @"alert"]);
    }
    return YES;
}
// app open
- (void)application:(UIApplication *)application didReceiveLocalNotification:(NSDictionary *)userInfo
{
    NSLog(@"notification: %@", [[userInfo objectForKey: @"aps"]objectForKey: @"alert"]);
    if (application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Notification" message: [[userInfo objectForKey: @"aps"]objectForKey: @"alert"] delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactiv. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    
//    //NSLog(@"url=====%@ \n  sourceApplication=======%@ \n  annotation======%@", url, sourceApplication, annotation);
//    //NSLog(@"URL Scheme = %@", [url scheme]);
//    //NSLog(@"URL Query = %@", [url query]);
//    
//    AUTH_CALLBACK = [url query];
//    return YES;
//}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

// get device token
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString * deviceTokenStr = [[[[deviceToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    [public set_device_token: deviceTokenStr];
    notification_debug(@"device token = %@", deviceTokenStr);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0){
    notification_debug(@"error = %@", error);
}
@end

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
