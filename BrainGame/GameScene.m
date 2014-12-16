//
//  GameScene.m
//  BrainGame
//
//  Created by Lê Công on 12/15/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "GameScene.h"
#import "AGSpriteButton.h"

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
    GAME_STATE currentState;
    
    int score;
    int time;
    int startTime;
    
    NSTimeInterval timeOfLastCaculator;
    NSTimeInterval timePerCaculator;
    
    SKLabelNode *timeLabel;
    SKLabelNode *startTimeLabel;
    SKLabelNode *scoreLabel;
    
    AGSpriteButton *btnRetry;
    AGSpriteButton *btnBack;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self initScene];
    [self initHud];
    [self initButton];
    [self initStartTime];
    [self initDefaultValue];
    [self initGestureInView:view];
}

- (void)initDefaultValue {
    time = 10;
    startTime = 3;
    
    timeOfLastCaculator = 0.0;
    timePerCaculator = 1.0;
    
    timeLabel.hidden = YES;
    scoreLabel.hidden = YES;
    btnRetry.hidden = YES;
    btnBack.hidden = YES;
    startTimeLabel.hidden = NO;
}

- (void)initScene {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)initHud {

    timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    
    timeLabel.text = [NSString stringWithFormat:@"%d", time];
    timeLabel.fontSize = 36;
    timeLabel.fontColor = [UIColor redColor];
    timeLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                     self.frame.size.height - timeLabel.frame.size.height - 10);
    
    [self addChild:timeLabel];

    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];

    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    scoreLabel.fontSize = 17;
    scoreLabel.fontColor = [UIColor redColor];
    scoreLabel.position = CGPointMake(20 , self.frame.size.height - scoreLabel.frame.size.height  - 10);
    
    [self addChild:scoreLabel];

}

- (void)initStartTime {
    startTimeLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    startTimeLabel.text = [NSString stringWithFormat:@"%d", startTime];
    startTimeLabel.fontSize = 72;
    startTimeLabel.fontColor = [UIColor redColor];
    startTimeLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMidY(self.frame));
    
    [self addChild:startTimeLabel];
    
    [startTimeLabel runAction:[self animationCorrect]];
}

- (void)initButton {
    btnRetry = [AGSpriteButton buttonWithColor:[UIColor yellowColor] andSize:CGSizeMake(300, 30)];
    [btnRetry setLabelWithText:@"Rety" andFont:nil withColor:[UIColor redColor]];
    btnRetry.position = CGPointMake(self.size.width/2, 80);
    [btnRetry performBlock:^{
        [self stepState];
    } onEvent:AGButtonControlEventTouchUp];
    [self addChild:btnRetry];
    
    btnBack = [AGSpriteButton buttonWithColor:[UIColor greenColor] andSize:CGSizeMake(300, 30)];
    [btnBack setLabelWithText:@"Back" andFont:nil withColor:[UIColor redColor]];
    btnBack.position = CGPointMake(self.size.width/2, 20);
    [btnBack performBlock:^{
        [self back];
    } onEvent:AGButtonControlEventTouchUp];
    [self addChild:btnBack];
    
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

    if (currentState == STATE_START) {
        [self caculatorResult];
    }
    
    hasPendingSwipe = NO;
}

- (void)caculatorResult{
    switch (arrowType) {
        case ARROW_GREEN:
            if (userDirection == arrowDirection) {
                [self nextTurn];
                [self updateScoreCorrect];
            } else {
                [self wrongResult];
                [self updateScoreInCorrect];
            }
            break;
        case ARROW_RED:
            if (arrowDirection == DirectionRight) {
                if (userDirection == DirectionLeft) {
                    [self nextTurn];
                    [self updateScoreCorrect];
                } else {
                    [self wrongResult];
                    [self updateScoreInCorrect];
                }
            } else if (arrowDirection == DirectionLeft) {
                if (userDirection == DirectionRight) {
                    [self nextTurn];
                    [self updateScoreCorrect];
                } else {
                    [self wrongResult];
                    [self updateScoreInCorrect];
                }
            } else if (arrowDirection == DirectionUp) {
                if (userDirection == DirectionDown) {
                    [self nextTurn];
                    [self updateScoreCorrect];
                } else {
                    [self wrongResult];
                    [self updateScoreInCorrect];
                }
            } else if (arrowDirection == DirectionDown) {
                if (userDirection == DirectionUp) {
                    [self nextTurn];
                    [self updateScoreCorrect];
                } else {
                    [self wrongResult];
                    [self updateScoreInCorrect];
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

- (void)updateScoreCorrect {
    score ++;
    [self updateScoreLabel];
}

- (void)updateScoreInCorrect {
    score --;
    [self updateScoreLabel];
}

- (void)updateScoreLabel {
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
}

- (void)wrongResult {
 
    [self enumerateChildNodesWithName:@"arrow" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[self animationIncorrect]];
    }];
}

- (void)update:(CFTimeInterval)currentTime {
    
    
    switch (currentState) {
        case STATE_IDLE:
            [self countDownStart:currentTime];
            break;
        case STATE_START:
            [self countDownTime:currentTime];
            break;
        case STATE_STOP:
            
            break;
        default:
            break;
    }
    
}

- (void)stepState {
    switch (currentState) {
        case STATE_IDLE:
            currentState = STATE_START;
            startTimeLabel.hidden = YES;
            btnBack.hidden = YES;
            timeLabel.hidden = NO;
            scoreLabel.hidden = NO;
            break;
        case STATE_START:
            currentState = STATE_STOP;
            timeLabel.hidden = YES;
            btnRetry.hidden = NO;
            btnBack.hidden = NO;
            [self enumerateChildNodesWithName:@"arrow" usingBlock:^(SKNode *node, BOOL *stop) {
                [node removeFromParent];
            }];
            
            break;
        case STATE_STOP:
            currentState = STATE_IDLE;
            timeLabel.hidden = YES;
            btnRetry.hidden = YES;
            btnBack.hidden = YES;
            startTimeLabel.hidden = NO;
            
            time = 10;
            startTime = 3;
            score = 0;
            
            [self updateScoreLabel];
            break;
        default:
            break;
    }
}

- (void)countDownStart:(CFTimeInterval)currentTime {
    if (currentTime - timeOfLastCaculator < timePerCaculator) {
        return;
    }

    startTimeLabel.text = [NSString stringWithFormat:@"%d", startTime];
    timeOfLastCaculator = currentTime;
    
    startTime --;
    
    [startTimeLabel runAction:[self animationCorrect]];
    
    if (startTime < 0) {
        [self nextTurn];
        [self stepState];
    }
}

- (void)countDownTime:(CFTimeInterval)currentTime {
    if (currentTime - timeOfLastCaculator < timePerCaculator) {
        return;
    }
    
    time --;
    timeLabel.text = [NSString stringWithFormat:@"%d", time];
    timeOfLastCaculator = currentTime;
    
    if (time <= 0) {
        
        [self stepState];
    }
}

- (void)back {
    [_parrentViewController.navigationController popViewControllerAnimated:YES];
}

@end
