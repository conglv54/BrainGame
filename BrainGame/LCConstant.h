//
//  LCConstant.h
//  BrainGame
//
//  Created by Lê Công on 12/17/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface LCConstant : NSObject

@end
