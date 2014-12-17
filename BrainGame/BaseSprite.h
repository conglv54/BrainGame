//
//  BaseSprite.h
//  BrainGame
//
//  Created by Lê Công on 12/16/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LCConstant.h"

@interface BaseSprite : SKSpriteNode

@end

@interface ArrowSprite : BaseSprite

@property (nonatomic) ARROW_TYPE type;
@property (nonatomic) DIRECTION direction;

- (id)initWithType:(ARROW_TYPE)type andDirection:(DIRECTION)direction;

@end