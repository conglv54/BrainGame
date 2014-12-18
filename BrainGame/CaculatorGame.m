//
//  CaculatorGame.m
//  BrainGame
//
//  Created by Lê Công on 12/18/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "CaculatorGame.h"

@implementation CaculatorGame

- (void)initSetup {
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    
    timeLabel.text = @"Cong";
    timeLabel.fontSize = 36;
    timeLabel.fontColor = [UIColor redColor];
    timeLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMidY(self.frame));
    
    [self addChild:timeLabel];
    
    [self generaGame];
}

- (void)generaGame {
    NSInteger number1 = arc4random() %100;
    NSInteger temp = (100 - number1);
    NSInteger number2 = arc4random() % temp;
    NSInteger result;
    
    TYPE_CACULATOR type = arc4random() %4;
    switch (type) {
        case PLUS:
            result = number1 + number2;
            break;
        case SUB:
            result = number1 - number2;
            break;
        case MULTI:
            result = number1 * number2;
            break;
        case DIVISION:
            result = number1 / number2;
            break;
        default:
            break;
    }
    
    NSLog(@"number1:%ld, number2: %ld, number3: %d", number1, number2, (int)result);
}

- (void)update:(NSTimeInterval)currentTime {
    
}


@end
