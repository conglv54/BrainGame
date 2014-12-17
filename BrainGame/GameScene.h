//
//  GameScene.h
//  BrainGame
//

//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "BaseScene.h"
#import "GameViewController.h"

typedef enum : NSUInteger {
    STATE_IDLE,
    STATE_START,
    STATE_STOP
} GAME_STATE;

@interface GameScene : BaseScene <SwipeDelegate>

@end
