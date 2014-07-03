//
//  LaunchScene.m
//  SuperSparrow
//
//  Created by John King on 7/3/14.
//  Copyright (c) 2014 SpitballStudios. All rights reserved.
//

#import "LaunchScene.h"
#import "MainMenuScene.h"
@implementation LaunchScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor blackColor];
        if(size.width==568)
            self.backgroundNode=[SKSpriteNode spriteNodeWithImageNamed:@"LaunchImage.png"];
        else
            self.backgroundNode=[SKSpriteNode spriteNodeWithImageNamed:@"LaunchImage-960x640.png"];
        self.backgroundNode.alpha = 0;
        self.backgroundNode.xScale = 0.5;
        self.backgroundNode.yScale = 0.5;
        self.backgroundNode.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:self.backgroundNode];
    }
    return self;
}
- (void)didMoveToView:(SKView *)view
{
    SKAction *fadeIn = [SKAction fadeInWithDuration:2.25];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:2.25];
    SKAction *sequence = [SKAction sequence:@[fadeIn,fadeOut]];

    [self.backgroundNode runAction:sequence completion:^{
        SKView * skView = (SKView *)self.view;
        SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *transition = [SKTransition fadeWithDuration:1];
        [skView presentScene:scene transition:transition];
    }];

}
@end
