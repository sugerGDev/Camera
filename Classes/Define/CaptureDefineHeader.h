//
//  CaptureDefineHeader.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 获取当前Bundle资源

 @param file 资源名字
 @return 返回拼接好的资源路径
 */
#define kCaptureBundle(file) [@"Capture.bundle" stringByAppendingPathComponent:file]

/**
 调用Capture 用途类型

 - CaptureTypeUnkown: 未知数据类型
 - CaptureTypeCamera: 照相类型
 - CaptureTyoeVideo: 拍视频类型

 */
typedef NS_ENUM(NSInteger,CaptureType) {
    CaptureTypeUnkown = 0,
    CaptureTypeCamera ,
    CaptureTyoeVideo,
};



/**
 相机前后设置

 - CameraTypeUnknown: 未知相机前后
 - CameraTypeFront: 前置相机
 - CameraTypeBack: 后置相机
 */
typedef NS_ENUM(NSInteger,CameraType) {
    CameraTypeUnknown = 0,
    CameraTypeFront,
    CameraTypeBack,
};

NS_ASSUME_NONNULL_BEGIN



/**
 输入定义
 */
@interface CaptureDefineHeader : NSObject

@end

NS_ASSUME_NONNULL_END
