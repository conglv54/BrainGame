//
//  AnimationManager.m
//  BrainGame
//
//  Created by Lê Công on 12/17/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager

+ (SKAction *)animationWithType:(ANIMATION_TYPE )animationType {
    SKAction *skaction;
    switch (animationType) {
        case ANIMATION_CORRECT:
            skaction = [self animationCorrect];
            break;
        case ANIMATION_IN_CORRECT:
            skaction = [self animationIncorrect];
            break;
        default:
            break;
    }
    return skaction;
}

+ (SKAction *)animationCorrect {
    SKAction *zoomIn = [SKAction scaleTo:1.2 duration:0.2];
    SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.2];
    
    SKAction *animationCorrect = [SKAction sequence:@[zoomIn, zoomOut]];
    return animationCorrect;
}

+ (SKAction *)animationIncorrect {
    SKAction *zoomIn = [SKAction scaleTo:1.05 duration:0.05];
    SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.05];
    
    SKAction *animationCorrect = [SKAction sequence:@[zoomIn, zoomOut, zoomIn, zoomOut]];
    return animationCorrect;
}

@end
