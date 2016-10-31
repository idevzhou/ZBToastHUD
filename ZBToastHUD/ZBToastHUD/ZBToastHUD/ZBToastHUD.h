//
//  ZBToastHUD.h
//  ZBToastHUD
//
//  Created by yuanye on 2016/10/27.
//  Copyright © 2016年 yuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZBToastHUDLoadingStyle) {
    ZBToastHUDLoadingStyleDark,     // default style, HUD with black backgroundcolor
    ZBToastHUDLoadingStyleLight     // HUD with clear backgroundcolor
};

typedef NS_ENUM(NSUInteger, ZBToastHUDLoadingMaskType) {
    ZBToastHUDLoadingMaskTypeNone,  // default mask type, allow user interactions while HUD is displayed
    ZBToastHUDLoadingMaskTypeClear, // don't allow user interactions
    ZBToastHUDLoadingMaskTypeDark   // don't allow user interactions
};

typedef void (^ZBToastHUDLoadingDismissCompletion)(void);

@interface ZBToastHUD : UIView

@property (nonatomic, assign) ZBToastHUDLoadingStyle style; // default is ZBToastHUDLoadingStyleDark

// loading

- (void)showLoading;
- (void)showLoadingWithMaskType:(ZBToastHUDLoadingMaskType)maskType;

- (void)dismissLoading;
- (void)dismissLoadingWithCompletion:(ZBToastHUDLoadingDismissCompletion)completion;
- (void)dismissLoadingWithDelay:(NSTimeInterval)delay;
- (void)dismissLoadingWithDelay:(NSTimeInterval)delay completion:(ZBToastHUDLoadingDismissCompletion)completion;

// toast

- (void)showWithMessage:(NSString *)message;

- (void)showNoNetwork;
- (void)showSuccessWithMessage:(NSString *)message;             // 对勾
- (void)showErrorWithMessage:(NSString *)message;               // 叉叉
- (void)showWarningWithMessage:(NSString *)message;             // 叹号
- (void)showImage:(UIImage *)image message:(NSString *)message; // use 24*24 image

- (void)dismissToast;

@end
