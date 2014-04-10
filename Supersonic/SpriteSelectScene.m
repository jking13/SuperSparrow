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
static NSString *selectedSpriteName;
static SKShapeNode *selected;

@implementation SpriteSelectScene
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //set background color
        self.backgroundColor=[SKColor whiteColor];
        
        //bring in data
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.playerData = appDelegate.playerData;
        
        //instantiate sprites
        //I know this seems like a stupid way to do this, but it is actually the easiest way to ensure order
        selected = [[SKShapeNode alloc] init];
        sprites = [[NSMutableArray alloc] init];
        
        NSString *selectedSpriteType = [self.playerData objectForKey:@"SelectedSprite"];
        NSString *spriteString = @"BlackSprite";
        NSString *spriteType = [self.playerData objectForKey:spriteString];
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        sprite.name=spriteString;
        sprite.zPosition=2;
        [sprites addObject:sprite];
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"YellowSprite";
        spriteType = [self.playerData objectForKey:spriteString];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"BlueSprite";
        spriteType = [self.playerData objectForKey:spriteString];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"GreenSprite";
        spriteType = [self.playerData objectForKey:spriteString];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"PurpleSprite";
        spriteType = [self.playerData objectForKey:spriteString];
        sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteType];
        [sprites addObject:sprite];
        sprite.name=spriteString;
        sprite.zPosition=2;
        if ([selectedSpriteType isEqualToString:spriteString]) {
            selectedSprite = sprite;
        }
        spriteString = @"RedSprite";
        spriteType = [self.playerData objectForKey:spriteString];
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
            [self addChild:node];
            column++;
            if (column==4) {
                column=1;
                row=2;
            }
        }
        
        //draw the selection box
        [self drawBoxAroundSelectedSprite];
        [self addChild:selected];
        
        //spawns the return to main menu button
        SKSpriteNode *mainMenuButton =[SKSpriteNode spriteNodeWithImageNamed:@"buttonscale.png"];
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
        
        
        return self;
    }
    return NULL;
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
        if (node.zPosition!=2) {
            return;
        }
        //select the correct sprite
        [self.playerData setObject:node.name forKey:@"SelectedSprite"];
        selectedSprite = (SKSpriteNode*)node;
        [self drawBoxAroundSelectedSprite];
        
    }
}

//draws the selection box
-(void)drawBoxAroundSelectedSprite{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, selectedSprite.frame);
    selected.lineWidth = 1.0;
    selected.strokeColor = [SKColor blackColor];
    selected.glowWidth = 0.5;
    selected.path=path;
}
@end
