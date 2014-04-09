//
//  MainGameScene.m
//  Supersonic
//
//  Created by John King on 4/7/14.
//  Copyright (c) 2014 John King. All rights reserved.
//  testing conflict resolution 1

#import "MainGameScene.h"


static NSString * const playerFile = @"PlayerPlaceholder.png"; //name of the png for the player sprite
static BOOL playerSelected = false; //true if the user has clicked on the player sprite
static BOOL firstTouch=false;//false until the user touches the screen for the first time.
static NSMutableArray *ceilings;//contains all of the active ceilings on the screen

@implementation MainGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //set background color
        self.backgroundColor=[SKColor whiteColor];
        
        //initialize player sprite and add it to the scene
        self.playerNode = [SKSpriteNode spriteNodeWithImageNamed:playerFile];
        [self.playerNode setPosition:CGPointMake(size.width / 2 - 50, size.height / 2 - 50)];
        [self addChild:self.playerNode];
        [self.playerNode setZPosition:1];
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
    
    //react if it is the first touch the user has input
    if(!firstTouch)
    {
        firstTouch=true;
        [self countDown:3];
    }
    
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

//runs the countdown animation and begins the game on completion
//parameter should be the start of the countdown
-(void)countDown:(int) count{
    
    //configure and add the countdown label
    SKLabelNode *countNode=[SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
    countNode.text=[NSString stringWithFormat:@"%d",count];
    countNode.fontColor=[UIColor blackColor];
    [countNode setPosition:CGPointMake(self.size.width/2, self.size.height / 2)];
    [self addChild:countNode];
    
    //configure the actions for the label
    SKAction *fade = [SKAction fadeOutWithDuration:1];
    SKAction *enlarge = [SKAction scaleTo:1.5 duration:0.25];
    SKAction *shrink = [SKAction scaleTo:0.5 duration:0.5];
    SKAction *sequence = [SKAction sequence:@[enlarge,shrink]];
    SKAction *group = [SKAction group:@[sequence,fade]];
    
    //run the action
    [countNode runAction:group completion:^{
        [countNode removeFromParent];
        if (count==1)
            [self spawnCeilings];
        else
            [self countDown:count-1];
    }];
    
}

-(void) spawnCeilings{
    //create and add ceiling objects
    Ceiling *ceiling = [Ceiling alloc];
    [ceiling initWithSize:self.size];
    [ceilings addObject:ceiling];
    [self addChild:ceiling.leftCeiling];
    [self addChild:ceiling.rightCeiling];
    
    //create the actions
    SKAction *timer = [SKAction scaleTo:1 duration:1];
    SKAction *moveCeilingToEnd = [SKAction moveToY:-10 duration:3];
    
    //run the actions and clean up
    [ceiling.leftCeiling runAction:moveCeilingToEnd completion:^{
        [ceilings removeObject:ceiling];
        [ceiling.leftCeiling removeFromParent];
    }];
    [ceiling.rightCeiling runAction:moveCeilingToEnd completion:^{
        [ceiling.rightCeiling removeFromParent];
    }];
    [ceiling.rightCeiling runAction:timer completion:^{
        [self spawnCeilings];
    }];
}

@end
