//
//  Ceiling.m
//  Supersonic
//
//  Created by John King on 4/8/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "Ceiling.h"
#import "AppDelegate.h"
@implementation Ceiling
//size should be the screen size
-(void)initWithSize:(CGSize) size SafeWidth:(float) safeSize
{
    //bring in data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.playerData = appDelegate.playerData;

    
    //generate random safe spot
    int lowerBound = safeSize/2;
    int upperBound = size.width-lowerBound;
    float rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    NSMutableDictionary *ceilingDict = [self.playerData objectForKey:@"Ceilings"];
    
    NSMutableArray *runArray = [[NSMutableArray alloc] init];
    SKAction *runAnimation;
    NSString *frameName;
    int count = 1;
    frameName = [ceilingDict objectForKey:[NSString stringWithFormat:@"%d",count]];
    // Running ceiling animation
    while(frameName!=NULL)
    {
        SKTexture * runTexture = [SKTexture textureWithImageNamed:frameName];
        [runArray addObject:runTexture];
        count++;
        frameName = [ceilingDict objectForKey:[NSString stringWithFormat:@"%d",count]];
    }
    
    runAnimation = [SKAction animateWithTextures:runArray timePerFrame:0.05 resize:NO restore:NO];
    
    //create the correct ceilings
    self.leftCeiling = [SKSpriteNode spriteNodeWithImageNamed:@"lightning.png"] ;
    self.leftCeiling.size = CGSizeMake(rndValue-lowerBound, 10.0);
    self.rightCeiling = [SKSpriteNode spriteNodeWithImageNamed:@"lightning.png" ];
    self.rightCeiling.size = CGSizeMake(size.width, 10.0);
    self.leftCeiling.position=CGPointMake(self.leftCeiling.size.width/2, size.height);
    self.rightCeiling.position=CGPointMake(rndValue+lowerBound+self.rightCeiling.size.width/2, size.height);
    [self.leftCeiling runAction:[SKAction repeatActionForever:runAnimation]];
    [self.rightCeiling runAction:[SKAction repeatActionForever:runAnimation]];
     
}
@end
