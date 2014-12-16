//
//  GameScene.h
//  BrainGame
//

//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"

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

typedef enum : NSUInteger {
    ANIMATION_CORRECT,
    ANIMATION_IN_CORRECT,
} ANIMATION_TYPE;

typedef enum : NSUInteger {
    STATE_IDLE,
    STATE_START,
    STATE_STOP
} GAME_STATE;

@interface GameScene : SKScene

@property (nonatomic, weak) GameViewController *parrentViewController;

@end
