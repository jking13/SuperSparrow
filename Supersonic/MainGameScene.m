//
//  MainGameScene.m
//  Supersonic
//
//  Created by John King on 4/7/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "MainGameScene.h"


static NSString * const playerFile = @"PlayerPlaceholder.png"; //name of the png for the player sprite
static BOOL playerSelected = false; //true if the user has clicked on the player sprite


@implementation MainGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //set background color
        self.backgroundColor=[SKColor whiteColor];
        //initialize player sprite and add it to the scene
        self.playerNode = [SKSpriteNode spriteNodeWithImageNamed:playerFile];
        [self.playerNode setPosition:CGPointMake(size.width/2, size.height / 2)];
        [self addChild:self.playerNode];
        return self;
    }
    return NULL;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //if we touch the player node we set player selected to true
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    if ((SKSpriteNode *)[self nodeAtPoint:touchLocation]==self.playerNode)
        playerSelected=true;
    else
        playerSelected=false;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //if the player is selected we move the playernode to the new point
    if(!playerSelected)
        return;
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInNode:self];
	self.playerNode.position=touchLocation;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //the player is obviously no longer selected
    playerSelected=false;
}

@end
