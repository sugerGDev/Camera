//
//  Capture.m
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import "Capture.h"
#import <UIKit/UIKit.h>

@interface Capture() <AVCaptureFileOutputRecordingDelegate>
//前后摄像头
@property (nonatomic, strong) AVCaptureDeviceInput *frontCamera;

@property (nonatomic, strong) AVCaptureDeviceInput *backCamera;

//会话
@property (nonatomic, strong) AVCaptureSession *captureSession;

// 图片输入对象
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
//视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

//音频设备
@property (nonatomic, strong) AVCaptureDeviceInput *audioInputDevice;

//当前使用的视频设备
@property (nonatomic, weak) AVCaptureDeviceInput *videoInputDevice;

/*标示当前是否在后台*/
@property(nonatomic, assign) BOOL inBackground;
/*标示当前是否在录制*/
@property(nonatomic, assign) BOOL isRecording;
/*
 * 预览layer
 * */
@property(nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
/*
 * 播放本地链接
 * */
@property(nonatomic, copy) NSURL *videoUrl;

/*
 * 获取当前拍摄方向
 * */
@property (nonatomic, assign)AVCaptureVideoOrientation captureVideoOrientation;


/**
当前相机类型
 */
@property(nonatomic, assign) CameraType cameraType;
@end

@implementation Capture
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self observeApp];
        [self createCapture];
        
    }
    return self;
}

#pragma mark - 初始化当前相关资源
- (void)createCapture {
    //  配置视频录制格式
    [self setVideoFomatConfig];
    // 选择后置摄像头
    [self switchCameraType:(CameraTypeBack)];
 

    // 添加摄像头
    if ([self.captureSession canAddInput:self.videoInputDevice]) {
        [self.captureSession addInput:self.videoInputDevice];
    }
    // 添加麦克风
    if ([self.captureSession canAddInput:self.audioInputDevice]) {
        [self.captureSession addInput:self.audioInputDevice];
    }
    // 添加图片输出
    if ([self.captureSession canAddOutput:self.stillImageOutput]) {
        [self.captureSession addOutput:self.stillImageOutput];
    }
    // 添加视频输出
    if ([self.captureSession canAddOutput:self.movieFileOutput]) {
        [self.captureSession addOutput:self.movieFileOutput];
        [self setVideoOutConfig];
    }
}

#pragma mark  - 渲染到预览层上
- (AVCaptureVideoPreviewLayer *)onRenderPreviewLayer {

    if (self.previewLayer && self.captureSession.isRunning) {
        return self.previewLayer;
    }
    
    
    [self.captureSession stopRunning];
    [self.captureSession startRunning];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    return self.previewLayer;
}


#pragma mark - 观察当前App生命周期
- (void)observeApp {
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [center addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(didChangeStatusBarOrientationNotification) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didChangeStatusBarOrientationNotification {
    /*录制过程中不允许旋转*/
    if  (self.isRecording) {
        return;
    }

    UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];

    if(interfaceOritation == UIDeviceOrientationUnknown ||
            interfaceOritation == UIDeviceOrientationPortrait ||
            interfaceOritation == UIDeviceOrientationPortraitUpsideDown) {
        self.captureVideoOrientation = AVCaptureVideoOrientationPortrait;

    } else if (interfaceOritation == UIDeviceOrientationLandscapeLeft){
        self.captureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (interfaceOritation == UIDeviceOrientationLandscapeRight) {
        
        self.captureVideoOrientation =AVCaptureVideoOrientationLandscapeLeft;
    }
    
    [self setVideoOutConfig];
}

-(void) willEnterForeground{
    self.inBackground = NO;

    if  (!self.captureSession.isRunning) {
        [self.captureSession startRunning];
    }
}

-(void) didEnterBackground{
    self.inBackground = YES;
    [self.captureSession stopRunning];
    [self reset];
}


- (void)dealloc {
    [self destroyResource];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}



#pragma mark - 前后摄像头切换
- (void)switchCamera {
    [self switchCameraType:self.cameraType == CameraTypeBack ? CameraTypeFront : CameraTypeBack];
}

- (void)switchCameraType:(CameraType)cameraType {
    if  (self.isRecording) {
        NSLog(@"[W] 录制过程中，不允许设置相机");
        return;
    }
    NSLog(@"[E] 开始设置摄像头类型 %zd",cameraType);
    [self setVideoInputDevice:(cameraType == CameraTypeFront ? self.frontCamera : self.backCamera)];
    self.cameraType = cameraType;
}

- (void)setVideoInputDevice:(AVCaptureDeviceInput *)videoInputDevice {
    if ([videoInputDevice isEqual:_videoInputDevice]) {
        NSLog(@"[W] 设置摄像头失败..");
        return;
    }
    //modifyinput
    [self.captureSession beginConfiguration];
    if (_videoInputDevice) {
        [self.captureSession removeInput:_videoInputDevice];
    }
    if (videoInputDevice) {
        [self.captureSession addInput:videoInputDevice];
    }
    [self setVideoOutConfig];
    [self.captureSession commitConfiguration];
    NSLog(@"[E] 设置摄像头成功..");
    _videoInputDevice = videoInputDevice;
}
#pragma mark - 销毁session

-(void) destroyResource{

    if (_captureSession.isRunning) {
        [_captureSession removeInput:_audioInputDevice];
        [_captureSession removeInput:_videoInputDevice];
        [_captureSession removeOutput:_stillImageOutput];
        [_captureSession removeOutput:_movieFileOutput];
        
    }
    [_captureSession stopRunning];
    _captureSession = nil;
}

#pragma mark - 设置视屏输出配置
- (void)setVideoOutConfig{
    
    NSLog(@"self.movieFileOutput.connections is %@",self.movieFileOutput.connections);
 
    for (AVCaptureConnection *conn in self.movieFileOutput.connections) {
        if (conn.isVideoStabilizationSupported) {
            [conn setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
        }

        if (conn.isVideoOrientationSupported) {
            [conn setVideoOrientation:self.captureVideoOrientation];
        }
        
        if (conn.isVideoMirrored) {
            [conn setVideoMirrored: YES];
        }
    }
}

- (void)setVideoFomatConfig {
    //        视频输出流
    //        设置视频格式
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetiFrame1280x720]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPresetiFrame1280x720];

    }else if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPresetiFrame960x540];

    }else if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections
{

}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error
{
    self.videoUrl = outputFileURL;
//    NSLog(@"CMTimeGetSeconds(output.recordedDuration) is %.2f",CMTimeGetSeconds(output.recordedDuration));
    if (CMTimeGetSeconds(output.recordedDuration) < 1) {
        //视频长度小于1s 允许拍照则拍照，不允许拍照，则保存小于1s的视频
        NSLog(@"视频长度小于1s，按拍照处理");
        [self handlerImageWithOutput];
        return;
    }

    

}


#pragma mark - 懒加载
/* 开始定义 KVideoDevices */
#ifndef  KVideoDevices
#define  KVideoDevices ((NSArray *)[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
#endif
- (AVCaptureDeviceInput *)frontCamera {
    if (!_frontCamera) {
        NSError *err = nil;
        _frontCamera = [AVCaptureDeviceInput deviceInputWithDevice:KVideoDevices.lastObject error:&err];
        if (err) {
            _frontCamera = nil;
            NSLog(@"[W] 前置摄像头初始化失败..%@",err);
        }else {
            NSLog(@"[E] 前置摄像头初始化成功..");
        }
    }
    return _frontCamera;
}

- (AVCaptureDeviceInput *)backCamera {
    if (!_backCamera) {
        NSError *err = nil;
        _backCamera = [AVCaptureDeviceInput deviceInputWithDevice:KVideoDevices.firstObject error:&err];
        if (err) {
            _backCamera = nil;
            NSLog(@"[W] 后置摄像头初始化失败..%@",err);
        }else {
            NSLog(@"[E] 后置摄像头初始化成功..");
        }
    }
    return _backCamera;
}
#undef KVideoDevices /*取消定义 KVideoDevices*/

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc]init];

    }
    return _captureSession;
}

- (AVCaptureStillImageOutput *)stillImageOutput {
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        NSDictionary *dicOutputSetting = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
        [_stillImageOutput setOutputSettings:dicOutputSetting];
    }
    return _stillImageOutput;
}

- (AVCaptureMovieFileOutput *)movieFileOutput {
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    }
    return _movieFileOutput;
}

- (AVCaptureDeviceInput *)audioInputDevice {
    if (!_audioInputDevice) {
        NSError *err = nil;
        //麦克风
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        _audioInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&err];
        
        if (err) {
            _audioInputDevice = nil;
            NSLog(@"[W] 获取麦克风失败..%@",err);
        } else {
            NSLog(@"[E] 获取麦克风成功..");
        }
    }
    return _audioInputDevice;
}

@end

@implementation Capture(Function)
- (void)takePhoto {
    [self startRecording];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self finishRecording];
    });
}

- (void)startRecording {
    if (self.isRecording) {
        return;
    }
    if (!self.captureSession.isRunning) {
        [self.captureSession startRunning];
    }
    AVCaptureConnection *movieConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    movieConnection.videoOrientation = self.captureVideoOrientation;
    [movieConnection setVideoScaleAndCropFactor:1.0];
    if (![self.movieFileOutput isRecording]) {
        NSURL *url = [NSURL fileURLWithPath:self.getVideoExportFilePath];
        [self.movieFileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
    }
    self.isRecording = YES;
}

- (void)finishRecording {
    if  (!self.isRecording) {
        return;
    }
    
    [self.movieFileOutput stopRecording];
    [self setVideoZoomFactor:1.f];
    self.isRecording = NO;
}

- (void)reset {
    [self.movieFileOutput stopRecording];
    if (self.videoUrl) {
        [[NSFileManager defaultManager] removeItemAtURL:self.videoUrl error:nil];
        self.videoUrl = nil;
    }
    [self setVideoZoomFactor:1.f];
}

- (void)setVideoZoomFactor:(CGFloat)zoomFactor
{
    AVCaptureDevice * captureDevice = self.videoInputDevice.device;
    NSError *error = nil;
    [captureDevice lockForConfiguration:&error];
    if (error) return;
    captureDevice.videoZoomFactor = zoomFactor;
    [captureDevice unlockForConfiguration];
}

@end

@implementation Capture(Tool)
- (void)handlerImageWithOutput {
    
    AVCaptureConnection * photoConn = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    photoConn.videoOrientation = self.captureVideoOrientation;
    if (photoConn.isVideoMirrored) {
        [photoConn setVideoMirrored: YES];
    }
    
    if (nil == photoConn) {
        NSLog(@"take photo failed!");
        return;
    }
    
   __weak __typeof(self)weakSelf = self;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:photoConn completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        [strongSelf.captureDelegate takePhotoWithImage:image];
    }];
}

- (NSString *)getVideoExportFilePath {
    NSString *exportFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", self.getUniqueStrByUUID, @"mov"]];
    return exportFilePath;
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID

    //get the string representation of the UUID
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);

    NSString *str = [NSString stringWithString:(__bridge NSString *)uuidString];

    CFRelease(uuidObj);
    CFRelease(uuidString);

    return [str lowercaseString];
}

@end
