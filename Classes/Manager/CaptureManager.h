//
//  CaptureManager.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaptureDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

/**
 输入管理实体类
 */
@interface CaptureManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CaptureType)type;



@end

NS_ASSUME_NONNULL_END
