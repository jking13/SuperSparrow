//
//  MainMenuScene.m
//  Supersonic
//
//  Created by John King on 4/9/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "Appirater.h"
SKNode *selectedButton;
@implementation MainMenuScene

NSString *fontName =@"Helvetica-Oblique";
- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    [Appirater appLaunched:YES];
}
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //bring in data
        selectedButton=NULL;
        
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
        
        //spawn the title logo background
        SKSpriteNode *logoBackground = [SKSpriteNode spriteNodeWithImageNamed:@"plain-blue-gradient.png"];
        [logoBackground setCenterRect:CGRectMake(25.0/100.0, 15.0/70.0, 50.0/100.0, 40.0/70.0)];
        [logoBackground setPosition:logo.position];
        [logoBackground setXScale:logo.size.width/100.0*2.3];
        [logoBackground setYScale:logo.size.height/70.0*2.3];
        [logoBackground setAlpha:0.3];
        //[self addChild:logoBackground];
        [self addChild:logo];
        
        //spawns the play button
        NSString *buttonScale = [self.playerData objectForKey:@"ButtonScale"];
        SKSpriteNode *playButton =[SKSpriteNode spriteNodeWithImageNamed:buttonScale];
        playButton.name = @"playButton";
        playButton.position =CGPointMake(CGRectGetMidX(self.frame)-64, CGRectGetMidY(self.frame)-50);
        playButton.size = CGSizeMake(80, 32);
        playButton.centerRect = CGRectMake(36.0/80.0,5.0/32.0,4.0/80.0,22.0/32.0);
        [self addChild:playButton];
        SKLabelNode *playLabel = [SKLabelNode labelNodeWithFontNamed:fontName];
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
        SKLabelNode *spriteSelectLabel = [SKLabelNode labelNodeWithFontNamed:fontName];
        [spriteSelectButton addChild:spriteSelectLabel];
        spriteSelectLabel.text = @"Characters";
        spriteSelectLabel.fontSize = 10;
        spriteSelectLabel.position = CGPointMake(spriteSelectLabel.position.x, spriteSelectLabel.position.y-5);
        
        //spawns the mute/unmute sound button
        if([[self.playerData objectForKey:@"isMuted"] isEqualToString:@"false"]) {
            
            SKSpriteNode *muteButton =[SKSpriteNode spriteNodeWithImageNamed:@"speaker.png"];
            muteButton.name = @"muteButton";
            muteButton.position =CGPointMake(CGRectGetMaxX(self.frame)-45,CGRectGetMaxY(self.frame)-37);
            muteButton.size = CGSizeMake(40, 32);
            [self addChild:muteButton];
        }
        else {
            SKSpriteNode *unmuteButton =[SKSpriteNode spriteNodeWithImageNamed:@"speaker2.png"];
            unmuteButton.name = @"unmuteButton";
            unmuteButton.position =CGPointMake(CGRectGetMaxX(self.frame)-45,CGRectGetMaxY(self.frame)-37);
            unmuteButton.size = CGSizeMake(40, 32);
            [self addChild:unmuteButton];
        }
        
        //spawns the mute/unmute music button
        if([[self.playerData objectForKey:@"isMusic"] isEqualToString:@"true"]) {
            
            SKSpriteNode *muteMusicButton =[SKSpriteNode spriteNodeWithImageNamed:@"music.png"];
            muteMusicButton.name = @"muteMusicButton";
            muteMusicButton.position =CGPointMake(CGRectGetMaxX(self.frame)-85,CGRectGetMaxY(self.frame)-37);
            muteMusicButton.size = CGSizeMake(30, 32);
            [self addChild:muteMusicButton];
        }
        else {
            SKSpriteNode *unmuteMusicButton =[SKSpriteNode spriteNodeWithImageNamed:@"nomusic.png"];
            unmuteMusicButton.name = @"unmuteMusicButton";
            unmuteMusicButton.position =CGPointMake(CGRectGetMaxX(self.frame)-85,CGRectGetMaxY(self.frame)-37);
            unmuteMusicButton.size = CGSizeMake(30, 32);
            [self addChild:unmuteMusicButton];
        }
        
        return self;
    }
    return NULL;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes)
        //presents the game scene
        if ([node.name isEqualToString:@"playButton"]||[node.name isEqualToString:@"spriteSelectButton"]||[node.name isEqualToString:@"muteButton"]||[node.name isEqualToString:@"unmuteButton"]||[node.name isEqualToString:@"muteMusicButton"]||[node.name isEqualToString:@"unmuteMusicButton"])
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
    if (selectedButton==NULL)
        return;
    selectedButton.position = CGPointMake(selectedButton.position.x-3, selectedButton.position.y+5);
    SKTransition *transition = [SKTransition fadeWithDuration:1];
    [transition setPausesOutgoingScene:true];
    [transition setPausesIncomingScene:true];
    if([[self.playerData objectForKey:@"isMuted"] isEqualToString:@"false"]) {
            [self runAction:[SKAction playSoundFileNamed:@"select.wav" waitForCompletion:NO]];
    }
        //presents the game scene
        if ([selectedButton.name isEqualToString:@"playButton"]) {
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MainGameScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene transition:transition];
        }
    
        //presents the sprite selection scene
        if ([selectedButton.name isEqualToString:@"spriteSelectButton"]) {
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [SpriteSelectScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene transition:transition];
        }
    if ([selectedButton.name isEqualToString:@"muteButton"]) {
        SKSpriteNode *unmuteButton =[SKSpriteNode spriteNodeWithImageNamed:@"speaker2.png"];
        unmuteButton.name = @"unmuteButton";
        unmuteButton.position =CGPointMake(CGRectGetMaxX(self.frame)-45,CGRectGetMaxY(self.frame)-37);
        unmuteButton.size = CGSizeMake(40, 32);
        [selectedButton removeFromParent];
        [self addChild:unmuteButton];
        [self.playerData setObject:@"true" forKey:@"isMuted"];
        
    }
    
    if ([selectedButton.name isEqualToString:@"unmuteButton"]) {
        SKSpriteNode *muteButton =[SKSpriteNode spriteNodeWithImageNamed:@"speaker.png"];
        muteButton.name = @"muteButton";
        muteButton.position =CGPointMake(CGRectGetMaxX(self.frame)-45,CGRectGetMaxY(self.frame)-37);
        muteButton.size = CGSizeMake(40, 32);
        [selectedButton removeFromParent];
        [self addChild:muteButton];
        [self.playerData setObject:@"false" forKey:@"isMuted"];
        
    }
    if ([selectedButton.name isEqualToString:@"muteMusicButton"]) {
        SKSpriteNode *unmuteMusicButton =[SKSpriteNode spriteNodeWithImageNamed:@"nomusic.png"];
        unmuteMusicButton.name = @"unmuteMusicButton";
        unmuteMusicButton.position =CGPointMake(CGRectGetMaxX(self.frame)-85,CGRectGetMaxY(self.frame)-37);
        unmuteMusicButton.size = CGSizeMake(30, 32);
        [selectedButton removeFromParent];
        [self addChild:unmuteMusicButton];
        [self.playerData setObject:@"false" forKey:@"isMusic"];
        
    }
    
    if ([selectedButton.name isEqualToString:@"unmuteMusicButton"]) {
        SKSpriteNode *muteMusicButton =[SKSpriteNode spriteNodeWithImageNamed:@"music.png"];
        muteMusicButton.name = @"muteMusicButton";
        muteMusicButton.position =CGPointMake(CGRectGetMaxX(self.frame)-85,CGRectGetMaxY(self.frame)-37);
        muteMusicButton.size = CGSizeMake(30, 32);
        [selectedButton removeFromParent];
        [self addChild:muteMusicButton];
        [self.playerData setObject:@"true" forKey:@"isMusic"];
        
    }
}
@end
