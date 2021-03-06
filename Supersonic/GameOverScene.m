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
#import "MainGameScene.h"
#import "Appirater.h"
SKNode *selectedButton;
NSString *highScoreFont = @"Noteworthy-Bold";
NSString *factFont = @"GurmukhiMN-Bold";
NSString *deathFont = @"Cochin-BoldItalic";
@implementation GameOverScene


- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
    
        selectedButton = NULL;
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
        SKLabelNode *mainMenuLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Oblique"];
        [mainMenuButton addChild:mainMenuLabel];
        mainMenuLabel.text = @"Main Menu";
        mainMenuLabel.fontSize = 10;
        mainMenuLabel.position = CGPointMake(mainMenuLabel.position.x, mainMenuLabel.position.y-5);
        
        //spawns the return to replay button
        SKSpriteNode *replayButton =[SKSpriteNode spriteNodeWithImageNamed:buttonScale];
        replayButton.name = @"replayButton";
        replayButton.size = CGSizeMake(80, 32);
        replayButton.position =CGPointMake(mainMenuButton.frame.origin.x+mainMenuButton.frame.size.width+replayButton.size.width/2.0+10, mainMenuButton.position.y);
        replayButton.centerRect = CGRectMake(36.0/80.0,5.0/32.0,4.0/80.0,22.0/32.0);
        [self addChild:replayButton];
        SKLabelNode *replayLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Oblique"];
        [replayButton addChild:replayLabel];
        replayLabel.text = @"Play Again";
        replayLabel.fontSize = 10;
        replayLabel.position = CGPointMake(replayLabel.position.x, replayLabel.position.y-5);
        
        //make the funny fact
        SKSpriteNode *fact = [[SKSpriteNode alloc] init];
        fact.size = CGSizeMake(100.0, 120.0);
        [fact setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
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
            factLabel = [SKLabelNode labelNodeWithFontNamed:factFont];
            factLabel.text=factLine;
            factLabel.fontColor = [UIColor redColor];
            factLabel.fontSize = 25;
            float factheight = fact.size.height;
            [factLabel setPosition:CGPointMake((float)fact.size.width/2.0, factheight-30.0*count)];
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isGameOverScreen = true;
    
    self.lastScore=[NSNumber numberWithInt:score];
    NSNumber *highScore = [self.playerData objectForKey:@"HighScore"];
    NSNumber *deathCount = [self.playerData objectForKey:@"DeathCount"];
    deathCount = [NSNumber numberWithInt:([deathCount intValue]+1)];
    [self.playerData setObject:deathCount forKey:@"DeathCount"];
    if ([self.lastScore intValue]>[highScore intValue]) {
        [self.playerData setObject:self.lastScore forKey:@"HighScore"];
        highScore = self.lastScore;
    }
    
    
    
    //initialize score label and add to scene
    SKLabelNode *scoreNode;
    scoreNode = [SKLabelNode labelNodeWithFontNamed:highScoreFont];
    scoreNode.text=[NSString stringWithFormat:@"Score: %d",score];
    scoreNode.fontColor = [UIColor blueColor];
    scoreNode.fontSize = 30;
    [scoreNode setPosition:CGPointMake(self.size.width/2-50, self.size.height/2-50)];
    
    //initialize high score label and add to scene
    score = [highScore intValue];
    SKLabelNode *highScoreNode;
    highScoreNode = [SKLabelNode labelNodeWithFontNamed:highScoreFont];
    highScoreNode.text=[NSString stringWithFormat:@"High Score: %d",score];
    highScoreNode.fontColor = [UIColor blueColor];
    highScoreNode.fontSize = 30;
    [highScoreNode setPosition:CGPointMake(self.size.width/2-100, self.size.height/2-100)];
    
    SKSpriteNode *logoBackground = [SKSpriteNode spriteNodeWithImageNamed:@"plain-blue-gradient.png"];
    [logoBackground setCenterRect:CGRectMake(25.0/100.0, 15.0/70.0, 50.0/100.0, 40.0/70.0)];
    [logoBackground setPosition:CGPointMake(self.size.width/2-100, self.size.height/2-62)];
    [logoBackground setXScale:highScoreNode.frame.size.width/100.0*2.3];
    [logoBackground setYScale:(highScoreNode.frame.size.height+scoreNode.frame.size.height+20)/70.0*2.3];
    [logoBackground setAlpha:0.85];
    
    
    [self addChild:logoBackground];
    [self addChild:highScoreNode];
    [self addChild:scoreNode];
    
    
    //death count
    //initialize score label and add to scene
    SKLabelNode *deathNode;
    deathNode = [SKLabelNode labelNodeWithFontNamed:deathFont];
    deathNode.text=[NSString stringWithFormat:@"Fried Sparrows: %d",[deathCount intValue]];
    deathNode.fontColor = [UIColor redColor];
    deathNode.fontSize = 20;
    [deathNode setPosition:CGPointMake(logoBackground.position.x+logoBackground.size.width, deathNode.frame.size.height)];
    [self addChild:deathNode];
    
    Chartboost *cb = [Chartboost sharedChartboost];
    if([cb hasCachedInterstitial:@"GameOver"])
        [cb showInterstitial:@"GameOver"];
    [Appirater userDidSignificantEvent:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes)
        //presents the game scene
        if ([node.name isEqualToString:@"mainMenuButton"]||[node.name isEqualToString:@"replayButton"])
            selectedButton = node;
    selectedButton.position = CGPointMake(selectedButton.position.x+3, selectedButton.position.y-5);
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (selectedButton==NULL)
        return;
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    bool found = false;
    for (SKNode *node in nodes)
        //presents the game scene
        if ([node.name isEqualToString:selectedButton.name])
            found=true;
    if (!found)
    {
        selectedButton.position = CGPointMake(selectedButton.position.x-3, selectedButton.position.y+5);
        selectedButton=NULL;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (selectedButton!=NULL) {
        selectedButton.position = CGPointMake(selectedButton.position.x-3, selectedButton.position.y+5);
    }
    SKTransition *transition = [SKTransition fadeWithDuration:1];
    [transition setPausesOutgoingScene:true];
    [transition setPausesIncomingScene:true];
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes){
        
        //present the main menu
        if ([node.name isEqualToString:@"mainMenuButton"]) {
            if (selectedButton==NULL)
                return;
            if([[self.playerData objectForKey:@"isMuted"] isEqualToString:@"false"]) {
                    [self runAction:[SKAction playSoundFileNamed:@"select.wav" waitForCompletion:NO]];
            }
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            appDelegate.isGameOverScreen = false;
            [skView presentScene:scene transition:transition];
            
            return;
        }
        //replay
        if ([node.name isEqualToString:@"replayButton"]) {
            if (selectedButton==NULL)
                return;
            if([[self.playerData objectForKey:@"isMuted"] isEqualToString:@"false"]) {
                [self runAction:[SKAction playSoundFileNamed:@"select.wav" waitForCompletion:NO]];
            }            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MainGameScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            appDelegate.isGameOverScreen = false;
            [skView presentScene:scene transition:transition];
            return;
        }
    }
}
@end
