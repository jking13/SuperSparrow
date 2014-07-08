//
//  AppDelegate.h
//  Supersonic
//
//  Created by John King on 4/6/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chartboost.h"
@import AVFoundation;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *playerData;
@property (strong, nonatomic) Chartboost *cb;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@property BOOL isGameOverScreen;
@end
