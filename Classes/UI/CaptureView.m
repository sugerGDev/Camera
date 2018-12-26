//
//  CaptureView.m
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import "CaptureView.h"
#import "Capture.h"
#import "VKMsgSend.h"


@interface CaptureView()
@property(nonatomic, strong) Capture *capture;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, assign) CaptureType captureType;
@end

@implementation CaptureView
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithCaptureType:(CaptureType)captureType
{
    self = [super init];
    if (self) {
        [self onInitWithCaptureType:captureType];
    }
    return self;
}


- (void)onInitWithCaptureType:(CaptureType)captureType {
    if (CGRectIsEmpty(self.bounds)) {
        self.frame = UIScreen.mainScreen.bounds;
    }
    self.captureType = captureType;
#if DEBUG
    self.backgroundColor = UIColor.blueColor;
#endif
    
    self.capture = [[Capture alloc]init];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeStatusBarOrientationNotification) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)onShow {
    
    if (!self.previewLayer) {
        self.previewLayer = [self.capture onRenderPreviewLayer];
        
        CGFloat w =  CGRectGetWidth(self.bounds) ;
        CGFloat h = CGRectGetHeight(self.bounds) ;
        
        self.previewLayer.frame = CGRectMake(0.f, 0.f, w, h );
        [self.layer addSublayer:self.previewLayer];
    }
}
#pragma mark - 观察横竖屏切换
- (void)didChangeStatusBarOrientationNotification {
    UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    [self.previewLayer removeAnimationForKey:@"Key_For_RotationAnimation"];
    
    //TODO: 视屏仅支持 UIDeviceOrientationPortrait | UIDeviceOrientationLandscapeLeft |UIDeviceOrientationLandscapeRight  枚举横竖
    if(interfaceOritation == UIDeviceOrientationUnknown ||
       interfaceOritation == UIDeviceOrientationPortrait ||
       interfaceOritation == UIDeviceOrientationPortraitUpsideDown) {
        
        rotationAnimation.toValue = [NSNumber numberWithFloat:0.f];
    } else if (interfaceOritation == UIDeviceOrientationLandscapeLeft){
        
        rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI_2];
        
    }else if (interfaceOritation ==  UIDeviceOrientationLandscapeRight) {
             rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI_2];
    }
    
    rotationAnimation.duration = 0.1f;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    [self.previewLayer addAnimation:rotationAnimation forKey:@"Key_For_RotationAnimation"];
    
}

#pragma mark - ToolViewDelegate 事件响应方法
- (void)respondSwitchFrontBackButtonTapEvent {
    [self.capture switchCamera];
}

- (void)respondTakePhotoButtonTapEvent {
    [self.capture takePhoto];
}

- (void)setCaptureDelegate:(id<CaptureViewDelegate>)captureDelegate {
    [self.capture setCaptureDelegate:captureDelegate];
}
@end
