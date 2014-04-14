//
//  GameOverScene.h
//  Supersonic
//
//  Created by John King on 4/10/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Chartboost.h"

@interface GameOverScene : SKScene <ChartboostDelegate>
@property (strong, nonatomic) NSMutableDictionary *playerData;//saved player info
@property (strong, nonatomic) NSNumber *lastScore;

-(void)setScoreAndFinishInit:(int) score;
@end
