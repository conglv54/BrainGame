//
//  GameScene.m
//  BrainGame
//
//  Created by Lê Công on 12/15/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "GameScene.h"
#import <AudioToolbox/AudioToolbox.h>

// The min distance in one direction for an effective swipe.
#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f

// The max ratio between the translation in x and y directions
// to make a swipe valid. i.e. diagonal swipes are invalid.
#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

@implementation GameScene {
    BOOL hasPendingSwipe;
    ARROW_TYPE arrowType;
    SWIPE_Direction arrowDirection;
    SWIPE_Direction userDirection;
    
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self initScene];
    [self nextTurn];
    [self initHud];
    [self initGestureInView:view];
}

- (void)initScene {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)initHud {
    SKLabelNode *damageLabel = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    damageLabel.name = @"damageLabel";
    damageLabel.fontSize = 12;
    damageLabel.fontColor = [UIColor colorWithRed:0.47 green:0.0 blue:0.0 alpha:1.0];
    damageLabel.text = @"0";
    damageLabel.position = CGPointMake(25, 40);
    [self addChild:damageLabel];
}

- (void)initNode {
    SKSpriteNode *arrowNode = [self arrowWithType:arrowType];
    arrowNode.zRotation = M_PI * arrowDirection/2;
    [self addChild:arrowNode];
    
    SKAction *zoomIn = [SKAction scaleTo:1.2 duration:0.2];
    SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.2];
    SKAction *zoom = [SKAction sequence:@[zoomIn, zoomOut]];
    
    [arrowNode runAction:zoom];
}

- (SKAction *)animationWithType:(ANIMATION_TYPE )animationType {
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

- (SKAction *)animationCorrect {
    SKAction *zoomIn = [SKAction scaleTo:1.2 duration:0.2];
    SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.2];
    
    SKAction *animationCorrect = [SKAction sequence:@[zoomIn, zoomOut]];
    return animationCorrect;
}

- (SKAction *)animationIncorrect {
    SKAction *zoomIn = [SKAction scaleTo:1.05 duration:0.05];
    SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.05];
    
    SKAction *animationCorrect = [SKAction sequence:@[zoomIn, zoomOut, zoomIn, zoomOut]];
    return animationCorrect;
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

- (SKSpriteNode *)arrowWithType:(ARROW_TYPE) type {
    
    SKTexture *texture;
    
    switch (type) {
        case ARROW_RED:
            texture = [SKTexture textureWithImageNamed:@"arrowRed"];
            break;
        case ARROW_GREEN:
            texture = [SKTexture textureWithImageNamed:@"arrowGreen"];
            break;
        default:
            break;
    }
    
    SKSpriteNode *arrowNode = [[SKSpriteNode alloc] initWithTexture:texture];
    arrowNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    arrowNode.name = @"arrow";
    return arrowNode;
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
    
    // Swipe too short. Don't do anything.
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD) return;
    
    // We only accept horizontal or vertical swipes, but not diagonal ones.
    if (absX > absY * VALID_SWIPE_DIRECTION_THRESHOLD) {
        if (translation.x < 0) {
            userDirection = DirectionLeft;
        } else {
            userDirection = DirectionRight;
        }
    } else if (absY > absX * VALID_SWIPE_DIRECTION_THRESHOLD) {
        if (translation.y < 0) {
            userDirection = DirectionUp;
        } else {
            userDirection = DirectionDown;
        }
    }
    
    hasPendingSwipe = NO;
    
    [self caculatorResult];
}

- (void)caculatorResult{
    switch (arrowType) {
        case ARROW_GREEN:
            if (userDirection == arrowDirection) {
                [self nextTurn];
            } else {
                [self wrongResult];
            }
            break;
        case ARROW_RED:
            if (arrowDirection == DirectionRight) {
                if (userDirection == DirectionLeft) {
                    [self nextTurn];
                } else {
                    [self wrongResult];
                }
            } else if (arrowDirection == DirectionLeft) {
                if (userDirection == DirectionRight) {
                    [self nextTurn];
                } else {
                    [self wrongResult];
                }
            } else if (arrowDirection == DirectionUp) {
                if (userDirection == DirectionDown) {
                    [self nextTurn];
                } else {
                    [self wrongResult];
                }
            } else if (arrowDirection == DirectionDown) {
                if (userDirection == DirectionUp) {
                    [self nextTurn];
                } else {
                    [self wrongResult];
                }
            }


            break;
        default:
            break;
    }
}

- (void)nextTurn {
    arrowType = arc4random() % 2;
    arrowDirection = arc4random() % 4;

    [self enumerateChildNodesWithName:@"arrow" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self initNode];
}

- (void)wrongResult {
 
    [self enumerateChildNodesWithName:@"arrow" usingBlock:^(SKNode *node, BOOL *stop) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        
        [node runAction:[self animationIncorrect]];
    }];
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
