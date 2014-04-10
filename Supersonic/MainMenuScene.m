//
//  MainMenuScene.m
//  Supersonic
//
//  Created by John King on 4/9/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //set background color
        self.backgroundColor=[SKColor whiteColor];
        
        //spawns the play button
        SKSpriteNode *playButton =[SKSpriteNode spriteNodeWithImageNamed:@"buttonscale.png"];
        playButton.name = @"playButton";
        playButton.position =CGPointMake(CGRectGetMidX(self.frame)-64, CGRectGetMidY(self.frame));
        playButton.size = CGSizeMake(80, 32);
        playButton.centerRect = CGRectMake(36.0/80.0,5.0/32.0,4.0/80.0,22.0/32.0);
        [self addChild:playButton];
        SKLabelNode *playLabel = [SKLabelNode labelNodeWithFontNamed:@"Times"];
        [playButton addChild:playLabel];
        playLabel.text = @"Play";
        playLabel.fontSize = 10;
        playLabel.position = CGPointMake(playLabel.position.x, playLabel.position.y-5);
        
        //spawns the sprite selection menu button
        SKSpriteNode *spriteSelectButton =[SKSpriteNode spriteNodeWithImageNamed:@"buttonscale.png"];
        spriteSelectButton.name = @"spriteSelectButton";
        spriteSelectButton.position =CGPointMake(CGRectGetMidX(self.frame)+64, CGRectGetMidY(self.frame));
        spriteSelectButton.size = CGSizeMake(80, 32);
        spriteSelectButton.centerRect = CGRectMake(36.0/80.0,5.0/32.0,4.0/80.0,22.0/32.0);
        [self addChild:spriteSelectButton];
        SKLabelNode *spriteSelectLabel = [SKLabelNode labelNodeWithFontNamed:@"Times"];
        [spriteSelectButton addChild:spriteSelectLabel];
        spriteSelectLabel.text = @"Sprites";
        spriteSelectLabel.fontSize = 10;
        spriteSelectLabel.position = CGPointMake(spriteSelectLabel.position.x, spriteSelectLabel.position.y-5);
        return self;
    }
    return NULL;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes) {
        //presents the game scene
        if ([node.name isEqualToString:@"playButton"]) {
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MainGameScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }
        
        //presents the sprite selection scene
        if ([node.name isEqualToString:@"spriteSelectButton"]) {
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [SpriteSelectScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }
    }
}
@end
