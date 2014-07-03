//
//  AppDelegate.m
//  Supersonic
//
//  Created by John King on 4/6/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"
@interface AppDelegate () <ChartboostDelegate>
@end
#define debugResetData 0
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"SuperSparrow" withExtension:@"wav"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    //load paths
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    //load saved user data
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"PlayerData.plist"];
    
    NSMutableDictionary *pdata = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    //if no saved data load default data
    if (!pdata||debugResetData) {
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"PlayerData" ofType:@"plist"];
        
        pdata = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    }
    self.playerData = pdata;
    
    [Appirater setAppId:@"567173760"];//this needs to be changed to our app id
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:25];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"PlayerData.plist"];
    
    [self.playerData writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*Chartboost *cb = [Chartboost sharedChartboost];
    
    cb.appId = @"534b32061873da0206baec0c";
    cb.appSignature = @"67d555ac0a323c2dbd02478edb63aafd627231ba";
    
    // Required for use of delegate methods. See "Advanced Topics" section below.
    cb.delegate = self;
    
    // Begin a user session. Must not be dependent on user actions or any prior network requests.
    // Must be called every time your app becomes active.
    [cb startSession];
    
    // Cache an interstitial at the default location
    [cb cacheInterstitial];
    
    [cb cacheMoreApps];*/
}

/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache interstitials
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
    
  //  [[Chartboost sharedChartboost] cacheInterstitial:location];
}

/*
 * didDismissMoreApps
 *
 * This is called when the more apps page is dismissed
 *
 * Is fired on:
 * - More Apps click
 * - More Apps close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache the more apps page
 */

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    
    //[[Chartboost sharedChartboost] cacheMoreApps];
}

@end
