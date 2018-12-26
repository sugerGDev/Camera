//
//  CaptureViewDelegate.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/26.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Capture View 事件返回
 */
@protocol CaptureViewDelegate <NSObject>
@optional
- (void)takePhotoWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
