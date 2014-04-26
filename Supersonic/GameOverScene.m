//
//  GameOverScene.m
//  Supersonic
//
//  Created by John King on 4/10/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "GameOverScene.h"
#import "AppDelegate.h"
#import "MainMenuScene.h"

@implementation GameOverScene

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
    
        //spawns the return to main menu button
        NSString *buttonScale = [self.playerData objectForKey:@"ButtonScale"];
        SKSpriteNode *mainMenuButton =[SKSpriteNode spriteNodeWithImageNamed:buttonScale];
        mainMenuButton.name = @"mainMenuButton";
        mainMenuButton.size = CGSizeMake(80, 32);
        mainMenuButton.position =CGPointMake(mainMenuButton.size.width/2+10, size.height-mainMenuButton.size.height/2-10);
        mainMenuButton.centerRect = CGRectMake(36.0/80.0,5.0/32.0,4.0/80.0,22.0/32.0);
        [self addChild:mainMenuButton];
        SKLabelNode *mainMenuLabel = [SKLabelNode labelNodeWithFontNamed:@"Times"];
        [mainMenuButton addChild:mainMenuLabel];
        mainMenuLabel.text = @"Main Menu";
        mainMenuLabel.fontSize = 10;
        mainMenuLabel.position = CGPointMake(mainMenuLabel.position.x, mainMenuLabel.position.y-5);
        
        //make the funny fact
        SKSpriteNode *fact = [[SKSpriteNode alloc] init];
        [fact setPosition:CGPointMake(self.size.width/2+100, self.size.height/2+150)];
        [fact setZRotation:M_1_PI/4];
        NSMutableDictionary *factsDict = [self.playerData objectForKey:@"Facts"];
        NSNumber *factNum = [factsDict objectForKey:@"Num"];
        int randomFactNum = arc4random() % [factNum intValue];
        randomFactNum++;
        NSMutableDictionary *factDict = [factsDict objectForKey:[NSString stringWithFormat:@"%d",randomFactNum]];
        int count = 1;
        NSString *factLine = [factDict objectForKey:[NSString stringWithFormat:@"%d",count]];
        while (factLine!=NULL) {
            SKLabelNode *factLabel;
            factLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
            factLabel.text=factLine;
            factLabel.fontColor = [UIColor blackColor];
            [factLabel setPosition:CGPointMake(fact.size.width/2, fact.size.height-factLabel.frame.size.height-factLabel.frame.size.height*count-1)];
            [fact addChild:factLabel];
            count++;
            factLine = [factDict objectForKey:[NSString stringWithFormat:@"%d",count]];
        }
        [self addChild:fact];
        
        return self;
    }
    return NULL;
}
-(void)setScoreAndFinishInit:(int) score
{
    
    self.lastScore=[NSNumber numberWithInt:score];
    NSNumber *highScore = [self.playerData objectForKey:@"HighScore"];
    if ([self.lastScore intValue]>[highScore intValue]) {
        [self.playerData setObject:self.lastScore forKey:@"HighScore"];
        highScore = self.lastScore;
    }
    
    //initialize score label and add to scene
    SKLabelNode *scoreNode;
    scoreNode = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
    scoreNode.text=[NSString stringWithFormat:@"Score: %d",score];
    scoreNode.fontColor = [UIColor blackColor];
    [scoreNode setPosition:CGPointMake(self.size.width/2-50, self.size.height/2-50)];
    [self addChild:scoreNode];
    
    //initialize high score label and add to scene
    score = [highScore intValue];
    SKLabelNode *highScoreNode;
    highScoreNode = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
    highScoreNode.text=[NSString stringWithFormat:@"High Score: %d",score];
    highScoreNode.fontColor = [UIColor blackColor];
    [highScoreNode setPosition:CGPointMake(self.size.width/2-100, self.size.height/2-100)];
    [self addChild:highScoreNode];
    
    
    [[Chartboost sharedChartboost] showInterstitial];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes){
        
        //present the main menu
        if ([node.name isEqualToString:@"mainMenuButton"]) {
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
            return;
        }
    }
}
@end
