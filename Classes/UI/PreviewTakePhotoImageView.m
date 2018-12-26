//
//  PreviewTakePhotoImageView.m
//  Camera
//
//  Created by 俊伟高 on 2018/12/26.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import "PreviewTakePhotoImageView.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"

@implementation PreviewTakePhotoImageView


- (void)setResetButton:(UIButton *)resetButton {
    _resetButton = resetButton;
    [self addSubview:_resetButton];
    CGSize s = _resetButton.frame.size;
    [_resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_offset(s);
        make.bottom.mas_equalTo(-30.f);
    }];
}

- (void)setConfirmButton:(UIButton *)confirmButton {
    _confirmButton = confirmButton;
    [self addSubview:_confirmButton];
    CGSize s = _confirmButton.frame.size;
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_offset(s);
        make.bottom.mas_equalTo(-30.f);
    }];
}

- (void)commitShowPreviewImageAnimation {
    // 关闭横竖屏
    ((AppDelegate *)UIApplication.sharedApplication.delegate ).shouldAutorotateSwith = NO;
    
    self.hidden = NO;
    
    [_resetButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];
    
    [_confirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];
    
    CGFloat space = 80.f;
    [self.resetButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-space);
    }];
    [self.confirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(space);
    }];

    

    
    
}
@end
