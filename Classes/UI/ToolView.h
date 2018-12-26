//
//  ToolView.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/26.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureDefineHeader.h"
#import "ToolViewDelegate.h"
#import "CaptureViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 工具View
 封装切换摄像头、拍照、拍摄j、聚焦，闪光灯等等布局
 */
@interface ToolView : UIView<CaptureViewDelegate>

- (instancetype)init NS_UNAVAILABLE;

/**
 根据CaptureType类型生成不同类型UI

 @param captureType 摄像头用途类型
 @return 返回ToolView
 */
- (instancetype)initWithCaptureType:(CaptureType)captureType;


/**
 获取当前 delegate对象
 */
@property(nonatomic, weak) id<ToolViewDelegate> toolViewDelegate;
@end

NS_ASSUME_NONNULL_END
