//
//  MainGameScene.h
//  Supersonic
//
//  Created by John King on 4/7/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ceiling.h"

@interface MainGameScene : SKScene
@property (nonatomic, strong) SKSpriteNode *playerNode;//player sprite node
@property (strong, nonatomic) NSMutableDictionary *playerData;//saved player info
@property (strong, nonatomic) NSNumber *highScore;
@property (strong, nonatomic) NSNumber *safeSize;
@end
