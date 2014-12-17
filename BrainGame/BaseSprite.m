//
//  BaseSprite.m
//  BrainGame
//
//  Created by Lê Công on 12/16/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "BaseSprite.h"

@implementation BaseSprite

@end

@implementation ArrowSprite

- (id)initWithType:(ARROW_TYPE)type andDirection:(DIRECTION)direction {
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
    
    self = [super initWithTexture:texture];
    
    if (self) {
        self.zRotation = M_PI * direction / 2;
        self.name = @"arrow";
    }
    
    return self;
}

@end