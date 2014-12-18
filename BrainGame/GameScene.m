//
//  GameScene.m
//  BrainGame
//
//  Created by Lê Công on 12/15/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "GameScene.h"
#import "BaseSprite.h"
#import "AnimationManager.h"
#import "AGSpriteButton.h"

@implementation GameScene {

    ARROW_TYPE arrowType;
    DIRECTION arrowDirection;
    DIRECTION userDirection;
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
    [self initHud];
    [self initButton];
    [self initStartTime];
    [self initDefaultValue];
    
    self.swipeDelegate = self;
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
    
    [startTimeLabel runAction:[AnimationManager animationWithType:ANIMATION_CORRECT]];
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
    BaseSprite *arrowNode = [[ArrowSprite alloc] initWithType:arrowType andDirection:arrowDirection];
    arrowNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:arrowNode];
    
    SKAction *zoomIn = [SKAction scaleTo:1.2 duration:0.2];
    SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.2];
    SKAction *zoom = [SKAction sequence:@[zoomIn, zoomOut]];
    
    [arrowNode runAction:zoom];
}

#pragma mark - () SWIPE DELEGATE 

- (void)didSwpieWithDirection:(DIRECTION)direction {
    if (currentState == STATE_START) {
        userDirection = direction;
        [self caculatorResult];
    }
}

#pragma mark - ()

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
    if (score > 0) {
        score --;        
    }
    [self updateScoreLabel];
}

- (void)updateScoreLabel {
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
}

- (void)wrongResult {
 
    [self enumerateChildNodesWithName:@"arrow" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[AnimationManager animationWithType:ANIMATION_IN_CORRECT]];
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
    
    [startTimeLabel runAction:[AnimationManager animationWithType:ANIMATION_CORRECT]];
    
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
    [self.parrentViewController.navigationController popViewControllerAnimated:YES];
}

@end
