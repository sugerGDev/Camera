//
//  Capture.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaptureDefineHeader.h"
#import <AVFoundation/AVFoundation.h>
#import "CaptureViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN
/*
 * 支持横竖屏拍摄
 * 设置方向参考方法- (void)didChangeStatusBarOrientationNotification
 * */
@interface Capture : NSObject

/**
 初始化当前对象 必须在主线程中实例化对象
 @return 返回 Capture 对象
 */
- (instancetype)init;

/*
 *渲染到预览层上
 * */
- (AVCaptureVideoPreviewLayer *)onRenderPreviewLayer;
/**
切换相机前后摄像头
 */
- (void)switchCamera;

/*
 * 初始化对象后，调用 -onRenderPreviewLayer 可获取到当前的预览层
 * */
@property(readonly, nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;

/**
 设置当前 Capture 事件对象
 */
@property(nonatomic, weak) id<CaptureViewDelegate> captureDelegate;
@end

@interface Capture (Function)
/*照相*/
- (void)takePhoto;
/*开始录制*/
- (void)startRecording;
/*完成录制*/
- (void)finishRecording;
/*重新拍照或者重新录像*/
- (void)reset;

@end


@interface Capture(Tool)
- (NSString *)getVideoExportFilePath;
- (void)handlerImageWithOutput;
@end


NS_ASSUME_NONNULL_END
