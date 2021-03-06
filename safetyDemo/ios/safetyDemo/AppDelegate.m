/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import "RCTRootView.h"

#import <EstimoteSDK/EstimoteSDK.h>


//Add the ESTBeaconManagerDelegate protocol
@interface AppDelegate () <ESTBeaconManagerDelegate>
//Add a property to hold the beacon manager
@property (nonatomic) ESTBeaconManager *beaconManager;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  /**
   * Loading JavaScript code - uncomment the one you want.
   *
   * OPTION 1
   * Load from development server. Start the server from the repository root:
   *
   * $ npm start
   *
   * To run on device, change `localhost` to the IP address of your computer
   * (you can get this by typing `ifconfig` into the terminal and selecting the
   * `inet` value under `en0:`) and make sure your computer and iOS device are
   * on the same Wi-Fi network.
   */

  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];

  /**
   * OPTION 2
   * Load from pre-bundled file on disk. The static bundle is automatically
   * generated by the "Bundle React Native code and images" build step when
   * running the project on an actual device or running the project on the
   * simulator in the "Release" build configuration.
   */

//   jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"safetyDemo"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  //Magic proximity code.
  
  self.beaconManager = [ESTBeaconManager new];
  self.beaconManager.delegate = self;
  //Ask to listen and run ble in the background.
  [self.beaconManager requestAlwaysAuthorization];
  //Monitoring for our trigger or beacon
  [self.beaconManager startMonitoringForRegion:[[CLBeaconRegion alloc]
                                                initWithProximityUUID:[[NSUUID alloc]
                                                initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                                major:31702
                                                minor:28807
                                                identifier:@"firstRegion"]];
  [self.beaconManager startMonitoringForRegion:[[CLBeaconRegion alloc]
                                                initWithProximityUUID:[[NSUUID alloc]
                                                initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                                major:00000
                                                minor:00000
                                                identifier:@"secondRegion"]];
  [self.beaconManager startMonitoringForRegion:[[CLBeaconRegion alloc]
                                                initWithProximityUUID:[[NSUUID alloc]
                                                initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                                major:11111
                                                minor:11111
                                                identifier:@"thirdRegion"]];
  NSLog(@"Monitoring for Beacons");
  //Request permission to send notifications.
  [[UIApplication sharedApplication]
   registerUserNotificationSettings:[UIUserNotificationSettings
                                     settingsForTypes:UIUserNotificationTypeAlert
                                     categories:nil]];
  
  
  // TODO: put your App ID and App Token here
  // You can get them by adding your app on https://cloud.estimote.com/#/apps
  //[ESTConfig setupAppID:@"<#App ID#>" andAppToken:@"<#App Token#>"];
  
  //self.beaconNotificationsManager = [BeaconNotificationsManager new];
  //[self.beaconNotificationsManager enableNotificationsForBeaconID:
  // TODO: replace with UUID, major and minor of your own beacon
  //[[BeaconID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" major:1 minor:1]
  //                                                  enterMessage:@"Hello."
  //                                                   exitMessage:@"Goodbye."
  //];
  
  // NOTE: "exit" event has a built-in delay of 30 seconds, to make sure that the user has really exited the beacon's range. The delay is imposed by iOS and is non-adjustable.
  
  
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
  UILocalNotification *notification = [UILocalNotification new];
  NSLog(@"Alert about to be sent.");
  if ([region.identifier isEqualToString:@"firstRegion"]) {
    notification.alertBody =
    @"You have just entered a construction zone. "
    "Please check to make sure you are wearing all appropriate safety equipment.";
  } else if ([region.identifier isEqualToString:@"secondRegion"]) {
    notification.alertBody =
    @"You have just entered a construction zone. "
    "Please check to make sure you are wearing all appropriate safety equipment.";
  } else if ([region.identifier isEqualToString:@"thirdRegion"]) {
    notification.alertBody =
    @"You have just entered a construction zone. "
    "Please check to make sure you are wearing all appropriate safety equipment.";
  }
  NSLog(@"Alert Sent Detected");
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (void)beaconManager:(id)manager didExitRegion:(CLBeaconRegion *)region {
  UILocalNotification *notification = [UILocalNotification new];
  NSLog(@"Alert about to be sent.");
  if ([region.identifier isEqualToString:@"firstRegion"]) {
    notification.alertBody =
    @"You have just entered a construction zone. "
    "Please check to make sure you are wearing all appropriate safety equipment.";
  } else if ([region.identifier isEqualToString:@"secondRegion"]) {
    notification.alertBody =
    @"You have just entered a construction zone. "
    "Please check to make sure you are wearing all appropriate safety equipment.";
  } else if ([region.identifier isEqualToString:@"thirdRegion"]) {
    notification.alertBody =
    @"You have just entered a construction zone. "
    "Please check to make sure you are wearing all appropriate safety equipment.";
  }
  NSLog(@"Alert Sent Detected");
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


@end

