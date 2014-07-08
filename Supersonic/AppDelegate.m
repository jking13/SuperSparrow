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
    self.isGameOverScreen = false;
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
    
    [Appirater setAppId:@"896447818"];//this needs to be changed to our app id
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:15];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"PlayerData.plist"];
    
    [self.playerData writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    sleep(5);
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
- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.isGameOverScreen = false;
    [Chartboost startWithAppId:@"534b32061873da0206baec0c" appSignature:@"67d555ac0a323c2dbd02478edb63aafd627231ba" delegate:self];
    [[Chartboost sharedChartboost] cacheInterstitial:@"GameOver"];
}
- (BOOL)shouldDisplayInterstitial:(CBLocation)location
{
    return self.isGameOverScreen;
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
    
    [[Chartboost sharedChartboost] cacheInterstitial:location];
}
@end
