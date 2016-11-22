//
//  UIView+ZBToastHUD.m
//  ZBToastHUD
//
//  Created by yuanye on 2016/10/28.
//  Copyright © 2016年 yuanye. All rights reserved.
//

#import "UIView+ZBToastHUD.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) ZBToastHUD *hud;

@end

@implementation UIView (ZBToastHUD)

// loading

- (void)zb_showLoading
{
    [self zb_showLoadingWithStyle:ZBToastHUDLoadingStyleDark maskType:ZBToastHUDLoadingMaskTypeClear];
}

- (void)zb_showLoadingWithStyle:(ZBToastHUDLoadingStyle)style
{
    [self zb_showLoadingWithStyle:style maskType:ZBToastHUDLoadingMaskTypeClear];
}

- (void)zb_showLoadingWithMaskType:(ZBToastHUDLoadingMaskType)maskType
{
    [self zb_showLoadingWithStyle:ZBToastHUDLoadingStyleDark maskType:maskType];
}

- (void)zb_showLoadingWithStyle:(ZBToastHUDLoadingStyle)style maskType:(ZBToastHUDLoadingMaskType)maskType
{
    [self.hud dismiss];
    self.hud = [[ZBToastHUD alloc] init];
    self.hud.style = style;
    [self.hud showLoadingWithMaskType:maskType];
    [self addSubview:self.hud];
    [self bringSubviewToFront:self.hud];
}

- (void)zb_dismissLoading
{
    [self zb_dismissLoadingWithDelay:0.0 completion:nil];
}

- (void)zb_dismissLoadingWithCompletion:(ZBToastHUDLoadingDismissCompletion)completion
{
    [self zb_dismissLoadingWithDelay:0.0 completion:completion];
}

- (void)zb_dismissLoadingWithDelay:(NSTimeInterval)delay
{
    [self zb_dismissLoadingWithDelay:delay completion:nil];
}

- (void)zb_dismissLoadingWithDelay:(NSTimeInterval)delay completion:(ZBToastHUDLoadingDismissCompletion)completion
{
    [self.hud dismissLoadingWithDelay:delay completion:completion];
}

// toast

- (void)zb_showWithMessage:(NSString *)message
{
    [self.hud dismiss];
    self.hud = [[ZBToastHUD alloc] init];
    [self.hud showWithMessage:message];
    [self addSubview:self.hud];
    [self bringSubviewToFront:self.hud];
}

- (void)zb_showNoNetwork
{
    [self.hud dismiss];
    self.hud = [[ZBToastHUD alloc] init];
    [self.hud showNoNetwork];
    [self addSubview:self.hud];
    [self bringSubviewToFront:self.hud];
}

- (void)zb_showSuccessWithMessage:(NSString *)message
{
    [self.hud dismiss];
    self.hud = [[ZBToastHUD alloc] init];
    [self.hud showSuccessWithMessage:message];
    [self addSubview:self.hud];
    [self bringSubviewToFront:self.hud];
}

- (void)zb_showErrorWithMessage:(NSString *)message
{
    [self.hud dismiss];
    self.hud = [[ZBToastHUD alloc] init];
    [self.hud showErrorWithMessage:message];
    [self addSubview:self.hud];
    [self bringSubviewToFront:self.hud];
}

- (void)zb_showWarningWithMessage:(NSString *)message
{
    [self.hud dismiss];
    self.hud = [[ZBToastHUD alloc] init];
    [self.hud showWarningWithMessage:message];
    [self addSubview:self.hud];
    [self bringSubviewToFront:self.hud];
}

- (void)zb_showImage:(UIImage *)image message:(NSString *)message
{
    [self.hud dismiss];
    self.hud = [[ZBToastHUD alloc] init];
    [self.hud showImage:image message:message];
    [self addSubview:self.hud];
    [self bringSubviewToFront:self.hud];
}

- (void)zb_dismissToast
{
    [self.hud dismissToast];
}

// loading and toast

- (void)zb_dismiss
{
    [self.hud dismiss];
}

#pragma mark - getter and setter

- (void)setHud:(ZBToastHUD *)hud
{
    objc_setAssociatedObject(self, @selector(hud), hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZBToastHUD *)hud
{
    return objc_getAssociatedObject(self, @selector(hud));
}

@end
