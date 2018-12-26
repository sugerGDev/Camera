//
//  PreviewTakePhotoImageView.h
//  Camera
//
//  Created by 俊伟高 on 2018/12/26.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewTakePhotoImageView : UIImageView
@property(nonatomic, strong) UIButton *resetButton;
@property(nonatomic, strong) UIButton *confirmButton;
- (void)commitShowPreviewImageAnimation;

@end

NS_ASSUME_NONNULL_END
