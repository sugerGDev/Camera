//
//  ToolView.m
//  Camera
//
//  Created by 俊伟高 on 2018/12/26.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import "ToolView.h"
#import <Masonry/Masonry.h>
#import "PreviewTakePhotoImageView.h"
#import "AppDelegate.h"

@interface ToolView()
/**
 切换摄像头按钮
 */
@property(nonatomic, strong) UIButton *switchCameraButton;

/**
 * 拍照按钮
 */
@property(nonatomic, strong) UIButton *takePhotoButton;

/**
 * 消失按钮
 * */
@property(nonatomic, strong) UIButton *dismissButton;




/*当前相机用途*/
@property(nonatomic) CaptureType captureType;

/**
 预览当前拍照照片
 */
@property(nonatomic, strong) PreviewTakePhotoImageView *previewTakePhotoImageView;
@end

@implementation ToolView


- (instancetype)initWithCaptureType:(CaptureType)captureType {
    if (self = [super init]) {
        self.captureType = captureType;
    }
    return self;
}

#pragma mark - Setter 方法
- (void)setCaptureType:(CaptureType)captureType {
    _captureType = captureType;
    
    // 右上角
    [self addSubview:self.switchCameraButton];
    [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(60.f);
        make.right.mas_offset(-30.f);
        make.size.mas_offset(self.switchCameraButton.frame.size);
    }];
    
    switch (captureType) {
        case CaptureTypeCamera:
            [self layoutCameraToolUI];
            break;
        case CaptureTyoeVideo:
            [self layoutVideoToolUI];
            break;
        default:
            break;
    }
}

#pragma mark - 布局方法
- (void)layoutCameraToolUI {
    [self addSubview:self.takePhotoButton];
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(self.takePhotoButton.frame.size);
        make.centerX.equalTo(self);
        make.bottom.mas_offset(-30.f);
    }];
}

- (void)layoutVideoToolUI {
    
}
#pragma mark - 懒加载

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [[UIButton alloc] init];
        [_switchCameraButton setImage:[UIImage imageNamed:kCaptureBundle(@"toggle_camera")] forState:UIControlStateNormal];
        [_switchCameraButton sizeToFit];
        [_switchCameraButton addTarget:self action:@selector(doSwitchButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _switchCameraButton;
}

- (UIButton *)takePhotoButton {
    if (!_takePhotoButton){
        _takePhotoButton = [[UIButton alloc] init];
        [_takePhotoButton setImage:[UIImage imageNamed:kCaptureBundle(@"takePhoto")] forState:UIControlStateNormal];
        [_takePhotoButton sizeToFit];
        [_takePhotoButton addTarget:self action:@selector(doTakePhotoButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _takePhotoButton;
}


- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] init];
        [_dismissButton setImage:[UIImage imageNamed:kCaptureBundle(@"arrow_down")] forState:UIControlStateNormal];
        [_dismissButton sizeToFit];
    }
    return _dismissButton;
}

- (UIButton *)buildResetButton {
    UIButton *resetButton = [[UIButton alloc] init];
    [resetButton setImage:[UIImage imageNamed:kCaptureBundle(@"retake")] forState:UIControlStateNormal];
    [resetButton sizeToFit];
    [resetButton addTarget:self action:@selector(doResetButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return resetButton;
}

- (UIButton *)buildConfirmButton {
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setImage:[UIImage imageNamed:kCaptureBundle(@"takeok")] forState:UIControlStateNormal];
    [confirmButton sizeToFit];
    [confirmButton addTarget:self action:@selector(doConfirmButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return confirmButton;
}

- (PreviewTakePhotoImageView *)previewTakePhotoImageView {
    if (!_previewTakePhotoImageView) {
        _previewTakePhotoImageView = [[PreviewTakePhotoImageView alloc]initWithFrame:self.bounds];
        _previewTakePhotoImageView.userInteractionEnabled = YES;
        [self addSubview:_previewTakePhotoImageView];
        [_previewTakePhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 添加 reset 按钮
        _previewTakePhotoImageView.resetButton = [self buildResetButton];
        _previewTakePhotoImageView.confirmButton = [self buildConfirmButton];
        
    }
    return _previewTakePhotoImageView;
}
#pragma mark - Action
- (void)doSwitchButton:(id)aSender {
    [self.toolViewDelegate respondSwitchFrontBackButtonTapEvent];
}
- (void)doTakePhotoButton:(id)aSender {
    [self.toolViewDelegate respondTakePhotoButtonTapEvent];
}

- (void)doResetButtonAction:(id)aSender {
    //开启横竖屏
    ((AppDelegate *)UIApplication.sharedApplication.delegate ).shouldAutorotateSwith = YES;
    
    // 处理图片相关
    self.previewTakePhotoImageView.image = nil;
    self.previewTakePhotoImageView.hidden = YES;
}

- (void)doConfirmButtonAction:(id)aSender {
    
}



#pragma mark - CaptureViewDelgate
- (void)takePhotoWithImage:(UIImage *)image {
    self.previewTakePhotoImageView.image = image;
    [self bringSubviewToFront:self.previewTakePhotoImageView];
    [self.previewTakePhotoImageView commitShowPreviewImageAnimation];

}
@end
