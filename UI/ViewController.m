//
//  ViewController.m
//  Camera
//
//  Created by 俊伟高 on 2018/12/25.
//  Copyright © 2018 俊伟高. All rights reserved.
//

#import "ViewController.h"
#import "CaptureView.h"
#import "ToolView.h"

#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface ViewController ()

@property(nonatomic, weak) UIScreen *screen;
/**
 当前图像成像层
 */
@property (strong, nonatomic)CaptureView *captureView;


/**
 当前Tool图层
 */
@property(nonatomic, strong) ToolView *toolView;

@end

@implementation ViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.captureView onShow];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fd_prefersNavigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CaptureType cType = CaptureTypeCamera;
    
#if TARGET_OS_IPHONE
    self.captureView = [[CaptureView alloc]initWithCaptureType:cType];
    [self.view addSubview:self.captureView];
#endif
    
    self.toolView = [[ToolView alloc]initWithCaptureType:cType];
    [self.view addSubview:self.toolView];
    
    self.screen = UIScreen.mainScreen;
    
    {// 关联事件
        self.toolView.toolViewDelegate = self.captureView;
        [self.captureView setCaptureDelegate:self.toolView];
    }
    NSLog(@"hello");
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //支持横竖屏布局
    CGFloat w = CGRectGetWidth(self.screen.bounds);
    CGFloat h = CGRectGetHeight(self.screen.bounds);
    CGFloat min = MIN(w, h);
//    NSLog(@"min is %.2f max is %.2f",min,max);
    self.captureView.frame = CGRectMake(0.f, 0.f, min, min);
    self.captureView.center = CGPointMake(w * .5f, h * .5f);
    
    self.toolView.frame = self.view.bounds;
}





#pragma mark - 强制设置横竖屏选项



- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
