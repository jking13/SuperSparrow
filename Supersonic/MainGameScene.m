//
//  MainGameScene.m
//  Supersonic
//
//  Created by John King on 4/7/14.
//  Copyright (c) 2014 John King. All rights reserved.

#import "MainGameScene.h"
#import "AppDelegate.h"
#import "GameOverScene.h"

BOOL playerSelected; //true if the user has clicked on the player sprite
BOOL firstTouch;//false until the user touches the screen for the first time.
NSMutableArray *ceilings;//contains all of the active ceilings on the screen
NSMutableArray *scorableCeilings;//ceilings that are possible to add to the score
int scoreCount;
SKSpriteNode *lastStreak;
SKSpriteNode *moveBanner; //movement banner displayed on Main Game load
BOOL gameover;
NSString *streakFile;

@implementation MainGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        gameover = false;
        
        //initialize variables;
        ceilings = [[NSMutableArray alloc] init];
        scorableCeilings = [[NSMutableArray alloc] init];
        playerSelected = false;
        firstTouch = false;
        scoreCount = 0;
        
        //bring in data
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.playerData = appDelegate.playerData;
        NSString *spriteType = [self.playerData objectForKey:@"SelectedSprite"];
         NSMutableDictionary *spriteDict = [self.playerData objectForKey:spriteType];
        NSString *playerFile = [spriteDict objectForKey:@"1"];
        self.highScore = [self.playerData objectForKey:@"HighScore"];
        self.safeSize = [self.playerData objectForKey:@"Safezone"];
        
        //set background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
        background.xScale = 0.5;
        background.yScale = 0.5;
        [self addChild:background];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //initialize player sprite and add it to the scene
        NSMutableArray *runArray = [[NSMutableArray alloc] init];
        SKAction *runAnimation;
        NSString *frameName;
        int count = 1;
        frameName = [spriteDict objectForKey:[NSString stringWithFormat:@"%d",count]];
        // Running player animation
        while(count<5)
        {
            SKTexture * runTexture = [SKTexture textureWithImageNamed:frameName];
            [runArray addObject:runTexture];
            count++;
            frameName = [spriteDict objectForKey:[NSString stringWithFormat:@"%d",count]];
        }
        runAnimation = [SKAction animateWithTextures:runArray timePerFrame:0.2 resize:YES restore:NO];
        streakFile=frameName;
        
        self.playerNode = [SKSpriteNode spriteNodeWithImageNamed:playerFile];
        [self.playerNode runAction:[SKAction repeatActionForever:runAnimation]];
        [self.playerNode setPosition:CGPointMake(size.width / 2 - 50, size.height / 2 - 100)];
        [self addChild:self.playerNode];
        [self.playerNode setZPosition:1];
        
        //initialize "Tap to Move" banner and add to scene
        moveBanner = [SKSpriteNode spriteNodeWithImageNamed:@"movebanner.png"];
        [moveBanner setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
        moveBanner.xScale = 0.5;
        moveBanner.yScale = 0.5;
        [self addChild:moveBanner];
        SKAction *enlarge = [SKAction scaleTo:0.51 duration:0.25];
        SKAction *shrink = [SKAction scaleTo:0.49 duration:0.5];
        SKAction *group = [SKAction sequence:@[enlarge, shrink]];
        [moveBanner runAction:[SKAction repeatActionForever:group]];
        
        //initialize score label and add to scene
        self.scoreNode = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
        self.scoreNode.text=[NSString stringWithFormat:@"%d",scoreCount];
        self.scoreNode.fontColor = [UIColor blackColor];
        [self.scoreNode setPosition:CGPointMake(self.size.width - 40, self.size.height - (self.size.height-10))];
        [self addChild:self.scoreNode];
    
        lastStreak=NULL;

        return self;
    }
    return NULL;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (gameover) {
        return;
    }
    
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
        [moveBanner removeFromParent];
        [self countDown:3];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //if the player is selected we move the playernode to the new point
    //if(!playerSelected)
    //    return;
	//UITouch *touch = [touches anyObject];
	//CGPoint touchLocation = [touch locationInNode:self];
	//self.playerNode.position=touchLocation;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (gameover) {
        return;
    }
    
    //calculate if line between current position and touch intersect a ceiling and set player to that intersect if necessary
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    CGFloat dx = touchLocation.x - self.playerNode.position.x;
    /*CGFloat dy = touchLocation.y - self.playerNode.position.y;
    NSMutableArray *intersectCeilings = [[NSMutableArray alloc] init];
    NSMutableArray *orderedCeilings = [[NSMutableArray alloc] init];

    if(dy > 0)
    {
        for(Ceiling *ceiling in ceilings)
        {
            if(ceiling.leftCeiling.frame.origin.y < touchLocation.y&&ceiling.leftCeiling.frame.origin.y>self.playerNode.position.y)
                [intersectCeilings addObject: ceiling];
                
        }
        while(intersectCeilings.count > 0)
        {
            int min = self.size.height+100;//being cautious
            Ceiling *ceilingMin;
            
            for(Ceiling *ceiling in intersectCeilings)
            {
                if(ceiling.leftCeiling.frame.origin.y < min)
                {
                    min = ceiling.leftCeiling.frame.origin.y;
                    ceilingMin = ceiling;
                }
            }
            [intersectCeilings removeObject:ceilingMin];
            [orderedCeilings addObject:ceilingMin];
        }
    }
    else if (dy < 0)
    {
        for(Ceiling *ceiling in ceilings)
        {
            if(ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height > touchLocation.y&&ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height<self.playerNode.position.y)
                [intersectCeilings addObject: ceiling];
            
        }
        while(intersectCeilings.count > 0)
        {
            int max = 0;
            Ceiling *ceilingMax;
            
            for(Ceiling *ceiling in intersectCeilings)
            {
                if(ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height > max)
                {
                    max = ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height;
                    ceilingMax = ceiling;
                }
            }
            [intersectCeilings removeObject:ceilingMax];
            [orderedCeilings addObject:ceilingMax];
        }
    }
    for(Ceiling *ceiling in orderedCeilings)
    {
        //check top of left ceiling
        float dy2=ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height-self.playerNode.position.y;
        float dx2=dy2/dy*dx;
        if ((dx2+self.playerNode.position.x)>0&&(dx2+self.playerNode.position.x)<=ceiling.leftCeiling.frame.size.width) {
            [self.playerNode setPosition:CGPointMake(dx2+self.playerNode.position.x, ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height)];
            return;
        }
        
        //check top of right ceiling
        if ((dx2+self.playerNode.position.x)>=ceiling.rightCeiling.frame.origin.x&&(dx2+self.playerNode.position.x)<self.size.width) {
            [self.playerNode setPosition:CGPointMake(dx2+self.playerNode.position.x, ceiling.rightCeiling.frame.origin.y+ceiling.rightCeiling.frame.size.height)];
            
            return;
        }
        
        //check bottom of left ceiling
        dy2=ceiling.leftCeiling.frame.origin.y-self.playerNode.position.y;
        dx2=dy2/dy*dx;
        if ((dx2+self.playerNode.position.x)>0&&(dx2+self.playerNode.position.x)<=ceiling.leftCeiling.frame.size.width) {
            [self.playerNode setPosition:CGPointMake(dx2+self.playerNode.position.x, ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height)];
            
            return;
        }
        //check bottom of right ceiling
        if ((dx2+self.playerNode.position.x)>=ceiling.rightCeiling.frame.origin.x&&(dx2+self.playerNode.position.x)<self.size.width) {
            [self.playerNode setPosition:CGPointMake(dx2+self.playerNode.position.x, ceiling.rightCeiling.frame.origin.y+ceiling.rightCeiling.frame.size.height)];
            
            return;
        }
        //check right of left ceiling
        dx2=ceiling.leftCeiling.frame.origin.x+ceiling.leftCeiling.frame.size.width-self.playerNode.position.x;
        dy2=dx2/dx*dy2;
        if (dy2+self.playerNode.position.y>=ceiling.leftCeiling.frame.origin.y&&dy2+self.playerNode.position.y<=ceiling.leftCeiling.frame.origin.y+ceiling.leftCeiling.frame.size.height) {
            [self.playerNode setPosition:CGPointMake(dx2+self.playerNode.position.x, dy2+self.playerNode.position.y)];
            return;
        }
        //check left of right ceiling
        dx2=ceiling.rightCeiling.frame.origin.x-self.playerNode.position.x;
        dy2=dx2/dx*dy2;
        if (dy2+self.playerNode.position.y>=ceiling.rightCeiling.frame.origin.y&&dy2+self.playerNode.position.y<=ceiling.rightCeiling.frame.origin.y+ceiling.rightCeiling.frame.size.height) {
            [self.playerNode setPosition:CGPointMake(dx2+self.playerNode.position.x, dy2+self.playerNode.position.y)];
            return;
        }
    }*/
    [self.playerNode setPosition:CGPointMake(touchLocation.x, self.playerNode.position.y)];
    if (lastStreak!=NULL)
    {
        [lastStreak removeAllActions];
        [lastStreak removeFromParent];
        lastStreak=NULL;
    }
    if (dx>-70&&dx<70)
        return;
    lastStreak=[SKSpriteNode spriteNodeWithImageNamed:streakFile];
    lastStreak.centerRect = CGRectMake(70.0/139.0, 35.0/61.0, 10.0/139.0, 10.0/61.0);
    lastStreak.xScale = fabsf(dx)/lastStreak.size.width;
    if (dx<0)
        lastStreak.zRotation=M_PI;
    lastStreak.position =CGPointMake(self.playerNode.position.x-dx/2,self.playerNode.position.y);
    [self addChild:lastStreak];
    SKAction *fade = [SKAction fadeOutWithDuration:0.1];
    [lastStreak runAction:fade completion:^{
        [lastStreak removeFromParent];
        lastStreak=NULL;
    }];
    
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
        if (count<=1)
            [self spawnCeilings];
        else
            [self countDown:count-1];
    }];
    
}



-(void) spawnCeilings{
    if (gameover) {
        return;
    }
    //create and add ceiling objects
    Ceiling *ceiling = [Ceiling alloc];
    [ceiling initWithSize:self.size SafeWidth:[self.safeSize floatValue]];
    [ceilings addObject:ceiling];
    [scorableCeilings addObject:ceiling];
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

-(void)update:(NSTimeInterval)currentTime
{
    if (gameover) {
        return;
    }
    NSMutableArray *ceilingsToRemove = [[NSMutableArray alloc] init];
    
    //collision detection
    CGRect frame = self.playerNode.frame;
    /*if ( (frame.origin.x <= 0) || (frame.origin.y <= 0)
        || (frame.origin.x+frame.size.width >= self.size.width)
        || (frame.origin.y+frame.size.height >= self.size.height)) {
        
        [self gameOver];
    }*/
    for(Ceiling *ceiling in ceilings)
    {
        if (CGRectIntersectsRect(ceiling.leftCeiling.frame, self.playerNode.frame)
            || CGRectIntersectsRect(ceiling.rightCeiling.frame, self.playerNode.frame)) {
            [self gameOver];
        }
    }
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
    SKAction *enlargeScore = [SKAction scaleTo:1.15 duration:0.25];
    SKAction *shrinkScore = [SKAction scaleTo:0.85 duration:0.5];
    SKAction *scorePulser = [SKAction sequence:@[enlargeScore,shrinkScore]];
    SKAction *scoreFader = [SKAction sequence:@[fadeOut, fadeIn]];

    
    //score detection
    for(Ceiling *ceiling in scorableCeilings){
        if (ceiling.leftCeiling.frame.origin.y+ceiling.rightCeiling.frame.size.height
            < frame.origin.y) {
            [ceilingsToRemove addObject:ceiling];
            scoreCount++;
            self.scoreNode.text=[NSString stringWithFormat:@"%d",scoreCount];
            [self.scoreNode runAction:scorePulser];
            [self.scoreNode runAction:scoreFader];
        }
    }
    
    //cleanup
    for(Ceiling *ceiling in ceilingsToRemove){
        [scorableCeilings removeObject:ceiling];
    }
}
-(void) gameOver
{
    gameover=true;
    
    for (Ceiling *ceiling in ceilings)
    {
        [ceiling.leftCeiling removeAllActions];
        [ceiling.rightCeiling removeAllActions];
    }
    [self.playerNode removeAllActions];
    NSMutableDictionary *spriteDict = [self.playerData objectForKey:@"DeathAnimation"];
    NSMutableArray *runArray = [[NSMutableArray alloc] init];
    SKAction *runAnimation;
    NSString *frameName;
    int count = 1;
    frameName = [spriteDict objectForKey:[NSString stringWithFormat:@"%d",count]];
    // Running player animation
    while(frameName!=NULL)
    {
        SKTexture * runTexture = [SKTexture textureWithImageNamed:frameName];
        [runArray addObject:runTexture];
        count++;
        frameName = [spriteDict objectForKey:[NSString stringWithFormat:@"%d",count]];
    }
    
    runAnimation = [SKAction animateWithTextures:runArray timePerFrame:0.1 resize:YES restore:NO];
    SKAction *repeatAnimation = [SKAction repeatAction:runAnimation count:3];


    [self.playerNode runAction:repeatAnimation completion:^{
        SKView * skView = (SKView *)self.view;
        GameOverScene * scene = [GameOverScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [scene setScoreAndFinishInit:scoreCount];
        [skView presentScene:scene];
    }];
}
@end
