//
//  CaptureView.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureDefineHeader.h"
#import "ToolViewDelegate.h"
#import "CaptureViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

/**
 封装成像图层
 */
@interface CaptureView : UIView<ToolViewDelegate>


- (instancetype)init NS_UNAVAILABLE;
/**
 初始化对象
 @param captureType 相机类型
 @return 返回对象View
 */
- (instancetype)initWithCaptureType:(CaptureType)captureType;


/**
 设置当前 Capture 事件对象
 
 @param captureDelegate 对象协议
 */
- (void)setCaptureDelegate:(id<CaptureViewDelegate>)captureDelegate;

/**
多次调用只会显示一次 建议在 viewDidLoad时机调用
 */
- (void)onShow;

/**
 获取当前相机类型
 */
@property(nonatomic, assign,readonly) CaptureType captureType;



@end

NS_ASSUME_NONNULL_END
