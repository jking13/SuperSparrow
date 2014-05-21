//
//  SpriteSelectScene.m
//  Supersonic
//
//  Created by John King on 4/9/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "SpriteSelectScene.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"

static NSMutableArray *sprites;
static SKSpriteNode *selectedSprite;
SKSpriteNode *lightningBorder;
static NSString *selectedSpriteName;
SKNode *selectedButton;

@implementation SpriteSelectScene
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        selectedButton=NULL;
        //set background color
        self.backgroundColor=[SKColor whiteColor];
        
        //bring in data
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.playerData = appDelegate.playerData;
        
        //set background image
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"city.png"];
        background.xScale = 0.5;
        background.yScale = 0.5;
        [background setZPosition:-3];
        [self addChild:background];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        
        
        //instantiate sprites
        //I know this seems like a stupid way to do this, but it is actually the easiest way to ensure order
        sprites = [[NSMutableArray alloc] init];
        NSString *selectedSpriteType = [self.playerData objectForKey:@"SelectedSprite"];
        NSString *spriteString = @"SuperSparrow";
        NSMutableDictionary *spriteDict = [self.playerData objectForKey:spriteString];
        NSString *spriteType = [spriteDict objectForKey:@"1"];
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        sprite.name=spriteString;
        sprite.zPosition=2;
        [sprites addObject:sprite];
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"GreenSparrow";
        spriteDict = [self.playerData objectForKey:spriteString];
        spriteType = [spriteDict objectForKey:@"1"];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"BatSparrow";
        spriteDict = [self.playerData objectForKey:spriteString];
        spriteType = [spriteDict objectForKey:@"1"];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"PinkSparrow";
        spriteDict = [self.playerData objectForKey:spriteString];
        spriteType = [spriteDict objectForKey:@"1"];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"WolSparrow";
        spriteDict = [self.playerData objectForKey:spriteString];
        spriteType = [spriteDict objectForKey:@"1"];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"IronSparrow";
        spriteDict = [self.playerData objectForKey:spriteString];
        spriteType = [spriteDict objectForKey:@"1"];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        
        //put the sprites on the screen
        int row = 1;
        int column = 1;
        for (SKSpriteNode *node in sprites)
        {
            float x=(size.width*1/4)*column;
            float y=(size.height*1/3)*row;
            node.position=CGPointMake(x, y);
            SKSpriteNode * backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:[self.playerData objectForKey:@"SpriteBackground"]];
            [backgroundNode setPosition:node.position];
            [backgroundNode setZPosition:-2];
            [backgroundNode setBlendMode:SKBlendModeScreen];
            [self addChild:backgroundNode];
            [self addChild:node];
            column++;
            if (column==4) {
                column=1;
                row=2;
            }
        }
        
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
        
        //draw the lightning border
        
        NSMutableDictionary *ceilingDict = [self.playerData objectForKey:@"LightningBorder"];
        
        NSMutableArray *runArray = [[NSMutableArray alloc] init];
        SKAction *runAnimation;
        NSString *frameName;
        int count = 1;
        frameName = [ceilingDict objectForKey:[NSString stringWithFormat:@"%d",count]];
         lightningBorder = [SKSpriteNode spriteNodeWithImageNamed:frameName];
        while(frameName!=NULL)
        {
            SKTexture * runTexture = [SKTexture textureWithImageNamed:frameName];
            [runArray addObject:runTexture];
            count++;
            frameName = [ceilingDict objectForKey:[NSString stringWithFormat:@"%d",count]];
        }
        
        runAnimation = [SKAction animateWithTextures:runArray timePerFrame:0.1 resize:NO restore:NO];
        [lightningBorder runAction:[SKAction repeatActionForever:runAnimation]];
        [lightningBorder setZPosition:-1];
        [self addChild:lightningBorder];
        [self drawBoxAroundSelectedSprite];
        
        
        return self;
    }
    return NULL;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes)
        //presents the game scene
        if ([node.name isEqualToString:@"mainMenuButton"])
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
            selectedButton.position = CGPointMake(selectedButton.position.x-3, selectedButton.position.y+5);
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene transition:transition];
            return;
        }
        if (node.zPosition!=2) {
            continue;
        }
        //select the correct sprite
        [self.playerData setObject:node.name forKey:@"SelectedSprite"];
        selectedSprite = (SKSpriteNode*)node;
        [self drawBoxAroundSelectedSprite];
        
    }
}

//draws the selection box
-(void)drawBoxAroundSelectedSprite{
    lightningBorder.position = selectedSprite.position;
}
@end
