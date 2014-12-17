//
//  BaseScene.m
//  BrainGame
//
//  Created by Lê Công on 12/17/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "BaseScene.h"

@implementation BaseScene {
    BOOL hasPendingSwipe;
}

#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f
#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self initGestureInView:view];
}

- (void)initGestureInView:(SKView *)view {
    if (view == self.view) {
        // Add swipe recognizer immediately after we move to this scene.
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipe:)];
        [self.view addGestureRecognizer:recognizer];
    } else {
        // If we are moving away, remove the gesture recognizer to prevent unwanted behaviors.
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe
{
    if (swipe.state == UIGestureRecognizerStateBegan) {
        hasPendingSwipe = YES;
    } else if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
}

- (void)commitTranslation:(CGPoint)translation
{
    if (!hasPendingSwipe) return;
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD) return;
    
    DIRECTION direction;
    
    if (absX > absY * VALID_SWIPE_DIRECTION_THRESHOLD) {
        if (translation.x < 0) {
            direction = DirectionLeft;
        } else {
            direction = DirectionRight;
        }
    } else if (absY > absX * VALID_SWIPE_DIRECTION_THRESHOLD) {
        if (translation.y < 0) {
            direction = DirectionUp;
        } else {
            direction = DirectionDown;
        }
    }
    
    hasPendingSwipe = NO;
    
    [_swipeDelegate didSwpieWithDirection:direction];
}


@end
