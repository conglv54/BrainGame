//
//  GameScene.h
//  BrainGame
//

//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    ARROW_RED,
    ARROW_GREEN,
} ARROW_TYPE;

typedef NS_ENUM(NSInteger, SWIPE_Direction) {
    DirectionRight,
    DirectionUp,
    DirectionLeft,
    DirectionDown,
};

@interface GameScene : SKScene

@end
