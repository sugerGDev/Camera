//
//  CaptureManager.m
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import "CaptureManager.h"

@implementation CaptureManager

- (instancetype)initWithType:(CaptureType)type
{
    self = [super init];
    if (self) {
        NSAssert(type != CaptureTypeUnkown, @"请选择 Capture 类型");
    }
    return self;
}

@end
