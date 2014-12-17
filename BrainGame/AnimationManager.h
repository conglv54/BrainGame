//
//  AnimationManager.h
//  BrainGame
//
//  Created by Lê Công on 12/17/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface AnimationManager : NSObject

typedef enum : NSUInteger {
    ANIMATION_CORRECT,
    ANIMATION_IN_CORRECT,
} ANIMATION_TYPE;

+ (SKAction *)animationWithType:(ANIMATION_TYPE )animationType;

@end
