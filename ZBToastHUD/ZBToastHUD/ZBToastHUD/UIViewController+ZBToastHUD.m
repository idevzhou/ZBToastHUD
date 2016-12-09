//
//  UIViewController+ZBToastHUD.m
//  ZBToastHUD
//
//  Created by yuanye on 2016/10/28.
//  Copyright © 2016年 yuanye. All rights reserved.
//

#import "UIViewController+ZBToastHUD.h"
#import "UIView+ZBToastHUD.h"

@implementation UIViewController (ZBToastHUD)

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
    [self zb_showLoadingWithMessage:@"" style:style maskType:maskType];
}

- (void)zb_showLoadingWithMessage:(NSString *)message
{
    [self zb_showLoadingWithMessage:message style:ZBToastHUDLoadingStyleDark maskType:ZBToastHUDLoadingMaskTypeClear];
}

- (void)zb_showLoadingWithMessage:(NSString *)message style:(ZBToastHUDLoadingStyle)style
{
    [self zb_showLoadingWithMessage:message style:style maskType:ZBToastHUDLoadingMaskTypeClear];
}

- (void)zb_showLoadingWithMessage:(NSString *)message maskType:(ZBToastHUDLoadingMaskType)maskType
{
    [self zb_showLoadingWithMessage:message style:ZBToastHUDLoadingStyleDark maskType:maskType];
}

- (void)zb_showLoadingWithMessage:(NSString *)message style:(ZBToastHUDLoadingStyle)style maskType:(ZBToastHUDLoadingMaskType)maskType
{
    [self.view zb_showLoadingWithMessage:message style:style maskType:maskType];
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
    [self.view zb_dismissLoadingWithDelay:delay completion:completion];
}

// toast

- (void)zb_showWithMessage:(NSString *)message
{
    [self.view zb_showWithMessage:message];
}

- (void)zb_showNoNetwork
{
    [self.view zb_showNoNetwork];
}

- (void)zb_showSuccessWithMessage:(NSString *)message
{
    [self.view zb_showSuccessWithMessage:message];
}

- (void)zb_showErrorWithMessage:(NSString *)message
{
    [self.view zb_showErrorWithMessage:message];
}

- (void)zb_showWarningWithMessage:(NSString *)message
{
    [self.view zb_showWarningWithMessage:message];
}

- (void)zb_showImage:(UIImage *)image message:(NSString *)message
{
    [self.view zb_showImage:image message:message];
}

- (void)zb_dismissToast
{
    [self.view zb_dismissToast];
}

// loading and toast

- (void)zb_dismiss
{
    [self.view zb_dismiss];
}

@end
