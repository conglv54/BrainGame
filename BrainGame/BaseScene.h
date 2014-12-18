//
//  BaseScene.h
//  BrainGame
//
//  Created by Lê Công on 12/17/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LCConstant.h"

@protocol SwipeDelegate <NSObject>

@optional
- (void)didSwpieWithDirection:(DIRECTION)direction;

@end


@interface BaseScene : SKScene

@property (nonatomic, weak) UIViewController *parrentViewController;
@property (nonatomic, weak) id<SwipeDelegate> swipeDelegate;

- (void)initSetup;

@end
