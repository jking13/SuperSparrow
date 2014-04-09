//
//  Ceiling.h
//  Supersonic
//
//  Created by John King on 4/8/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Ceiling : NSObject
@property (nonatomic,strong) SKSpriteNode *leftCeiling;//left portion of the ceiling
@property (nonatomic,strong) SKSpriteNode *rightCeiling;//right portion of the ceiling

-(void)initWithSize:(CGSize) size;//create the ceiling nodes, size should be the screen size
@end
