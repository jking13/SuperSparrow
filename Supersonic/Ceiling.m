//
//  Ceiling.m
//  Supersonic
//
//  Created by John King on 4/8/14.
//  Copyright (c) 2014 John King. All rights reserved.
//

#import "Ceiling.h"
@implementation Ceiling
//size should be the screen size
-(void)initWithSize:(CGSize) size SafeWidth:(float) safeSize
{
    //generate random safe spot
    int lowerBound = safeSize/2;
    int upperBound = size.width-lowerBound;
    float rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    //create the correct ceilings
    self.leftCeiling = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(rndValue-lowerBound, 10.0)];
    self.rightCeiling = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(size.width, 10.0)];
    self.leftCeiling.position=CGPointMake(self.leftCeiling.size.width/2, size.height);
    self.rightCeiling.position=CGPointMake(rndValue+lowerBound+self.rightCeiling.size.width/2, size.height);
}
@end
