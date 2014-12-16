//
//  BaseSprite.h
//  BrainGame
//
//  Created by Lê Công on 12/16/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BaseSprite : SKSpriteNode

@end

@interface ArrowSprite : BaseSprite

typedef enum : NSUInteger {
    ARROW_RED,
    ARROW_GREEN,
} ARROW_TYPE;

typedef NS_ENUM(NSInteger, DIRECTION) {
    DirectionRight,
    DirectionUp,
    DirectionLeft,
    DirectionDown,
};

@property (nonatomic) ARROW_TYPE type;
@property (nonatomic) DIRECTION direction;

- (id)initWithType:(ARROW_TYPE)type andDirection:(DIRECTION)direction;

@end