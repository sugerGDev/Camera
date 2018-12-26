//
//  ToolViewDelegate.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/26.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 工具View 相关事件delegate
 */
@protocol ToolViewDelegate <NSObject>

@optional
/**
 切换当前前后摄像头按钮点击事件
 */
- (void)respondSwitchFrontBackButtonTapEvent;

/**
  照相按钮点击事件处理
 * */
- (void)respondTakePhotoButtonTapEvent;
@end

NS_ASSUME_NONNULL_END
