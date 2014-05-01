//
//  MainMenuScene.m
//  Supersonic
//
//  Created by John King on 4/9/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "MainMenuScene.h"
#import "AppDelegate.h"


@implementation MainMenuScene
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //bring in data
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.playerData = appDelegate.playerData;
        
        //set background image
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"city.png"];
        background.xScale = 0.5;
        background.yScale = 0.5;
        [self addChild:background];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //spawn the title logo
        NSString *logoString = [self.playerData objectForKey:@"TitleLogo"];
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:logoString];
        [logo setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100)];
        [self addChild:logo];
        
        //spawns the play button
        NSString *buttonScale = [self.playerData objectForKey:@"ButtonScale"];
        SKSpriteNode *playButton =[SKSpriteNode spriteNodeWithImageNamed:buttonScale];
        playButton.name = @"playButton";
        playButton.position =CGPointMake(CGRectGetMidX(self.frame)-64, CGRectGetMidY(self.frame)-50);
        playButton.size = CGSizeMake(80, 32);
        playButton.centerRect = CGRectMake(36.0/80.0,5.0/32.0,4.0/80.0,22.0/32.0);
        [self addChild:playButton];
        SKLabelNode *playLabel = [SKLabelNode labelNodeWithFontNamed:@"Times"];
        [playButton addChild:playLabel];
        playLabel.text = @"Play";
        playLabel.fontSize = 10;
        playLabel.position = CGPointMake(playLabel.position.x, playLabel.position.y-5);
        
        //spawns the sprite selection menu button
        SKSpriteNode *spriteSelectButton =[SKSpriteNode spriteNodeWithImageNamed:buttonScale];
        spriteSelectButton.name = @"spriteSelectButton";
        spriteSelectButton.position =CGPointMake(CGRectGetMidX(self.frame)+64, CGRectGetMidY(self.frame)-50);
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
    [self runAction:[SKAction playSoundFileNamed:@"select.wav" waitForCompletion:NO]];
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
