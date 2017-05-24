//
//  ZBToastHUD.m
//  ZBToastHUD
//
//  Created by yuanye on 2016/10/27.
//  Copyright © 2016年 yuanye. All rights reserved.
//

#import "ZBToastHUD.h"

#pragma mark - UIColor+ZBToastHUD

@interface UIColor (ZBToastHUD)

+ (UIColor *)zb_colorWithValue:(NSUInteger)rgbValue;

+ (UIColor *)zb_colorWithValue:(NSUInteger)rgbValue alpha:(CGFloat)alpha;

@end

@implementation UIColor (ZBToastHUD)

+ (UIColor *)zb_colorWithValue:(NSUInteger)rgbValue
{
    return [UIColor zb_colorWithValue:rgbValue alpha:1.0];
}

+ (UIColor *)zb_colorWithValue:(NSUInteger)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:alpha];
}

@end

#pragma mark - NSMutableAttributedString+ZBToastHUD

@interface NSMutableAttributedString (ZBToastHUD)

+ (NSMutableAttributedString *)zb_attributedStringWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)zb_attributedStringHeightWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width;

+ (CGFloat)zb_attributedStringWidthWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing height:(CGFloat)height;

@end

@implementation NSMutableAttributedString (ZBToastHUD)

+ (NSMutableAttributedString *)zb_attributedStringWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    if (!text) text = @"";
    if (!font) font = [UIFont systemFontOfSize:17.0];
    if (lineSpacing < 0) lineSpacing = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

+ (CGFloat)zb_attributedStringHeightWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width
{
    if (!text) text = @"";
    if (!font) font = [UIFont systemFontOfSize:17.0];
    if (lineSpacing < 0) lineSpacing = 0;
    if (width < 0) width = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attributes
                                        context:nil].size.height;
    
    return height;
}

+ (CGFloat)zb_attributedStringWidthWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing height:(CGFloat)height
{
    if (!text) text = @"";
    if (!font) font = [UIFont systemFontOfSize:17.0];
    if (lineSpacing < 0) lineSpacing = 0;
    if (height < 0) height = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attributes
                                       context:nil].size.width;
    
    return width;
}

@end

#pragma mark - ZBToastHUD

static const CGFloat ZBToastHUDToastDismissDuration = 1.5;
static NSString *const ZBToastHUDLoadingAnimationKey = @"rotationAnimation";

@interface ZBToastHUD () <CAAnimationDelegate>

// loading
@property (nonatomic, strong) UIView *loadingHUDView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel *loadingMessageLabel;
@property (nonatomic, assign) ZBToastHUDLoadingMaskType maskType;

// toast
@property (nonatomic, strong) UIView *toastHUDView;
@property (nonatomic, strong) UIImageView *toastImageView;
@property (nonatomic, strong) UILabel *toastMessageLabel;

@property (nonatomic, assign) BOOL isLoadingHUD;

@end

@implementation ZBToastHUD

#pragma mark - lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        // defualt value
        self.hidden = NO;
        self.style = ZBToastHUDLoadingStyleDark;
        self.maskType = ZBToastHUDLoadingMaskTypeNone;
        self.isLoadingHUD = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    // loading
    if (self.isLoadingHUD)
    {
        self.frame = [UIScreen mainScreen].bounds;
        
        if (self.loadingMessageLabel.text.length > 0)
        {
            self.loadingHUDView.frame = CGRectMake((screenWidth-108)/2.0, (screenHeight-88)/2.0, 108, 88);
            self.loadingImageView.frame = CGRectMake((108-32)/2.0, 16, 32, 32);
            self.loadingMessageLabel.frame = CGRectMake(12, CGRectGetMaxY(self.loadingImageView.frame)+12, 108-24, 13);
        }
        else
        {
            self.loadingHUDView.frame = CGRectMake((screenWidth-72)/2.0, (screenHeight-72)/2.0, 72, 72);
            self.loadingImageView.frame = CGRectMake((72-32)/2.0, (72-32)/2.0, 32, 32);
            self.loadingMessageLabel.frame = CGRectZero;
        }
        
        // style
        if (self.style == ZBToastHUDLoadingStyleLight)
        {
            self.loadingImageView.image = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_LoadingStyleLight"];
            self.loadingHUDView.backgroundColor = [UIColor clearColor];
            self.loadingMessageLabel.textColor = [UIColor zb_colorWithValue:0x999999];
        }
        else
        {
            self.loadingImageView.image = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_LoadingStyleDark"];
            self.loadingHUDView.backgroundColor = [UIColor zb_colorWithValue:0x333333 alpha:0.8];
            self.loadingHUDView.layer.cornerRadius = 4.0;
            self.loadingHUDView.layer.masksToBounds = YES;
            self.loadingMessageLabel.textColor = [UIColor whiteColor];
        }
        
        // maskType
        if (self.maskType == ZBToastHUDLoadingMaskTypeClear)
        {
            self.backgroundColor = [UIColor clearColor];
            [self addSubview:self.loadingHUDView];
            [self.loadingHUDView addSubview:self.loadingImageView];
            [self.loadingHUDView addSubview:self.loadingMessageLabel];
        }
        else if (self.maskType == ZBToastHUDLoadingMaskTypeDark)
        {
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            [self addSubview:self.loadingHUDView];
            [self.loadingHUDView addSubview:self.loadingImageView];
            [self.loadingHUDView addSubview:self.loadingMessageLabel];
        }
        else
        {
            self.frame = CGRectZero;
            [self addSubview:self.loadingHUDView];
            [self.loadingHUDView addSubview:self.loadingImageView];
            [self.loadingHUDView addSubview:self.loadingMessageLabel];
        }
    }
    // toast
    else
    {
        [self addSubview:self.toastHUDView];
        [self.toastHUDView addSubview:self.toastImageView];
        [self.toastHUDView addSubview:self.toastMessageLabel];
        
        if (self.toastImageView.image)
        {
            CGFloat toastMessageLabelWidth = [NSMutableAttributedString zb_attributedStringWidthWithText:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:0.0 height:13];
            if (toastMessageLabelWidth <= 96-24) {
                toastMessageLabelWidth = 96-24;
            }
            if (toastMessageLabelWidth >= screenWidth*0.75-24) {
                toastMessageLabelWidth = screenWidth*0.75-24;
            }
            
            self.frame = CGRectMake((screenWidth-(toastMessageLabelWidth+24))/2.0, (screenHeight-76)/2.0, toastMessageLabelWidth+24, 76);
            self.toastHUDView.frame = self.bounds;
            self.toastImageView.frame = CGRectMake((toastMessageLabelWidth+24-24)/2.0, 18, 24, 24);
            self.toastMessageLabel.frame = CGRectMake(12, CGRectGetMaxY(self.toastImageView.frame)+8, toastMessageLabelWidth, 13);
        }
        else
        {
            CGFloat toastMessageLabelWidth = [NSMutableAttributedString zb_attributedStringWidthWithText:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:0.0 height:15];
            // single line
            if (toastMessageLabelWidth <= screenWidth*0.75-24)
            {
                self.frame = CGRectMake((screenWidth-(toastMessageLabelWidth+24))/2.0, (screenHeight-44)/2.0, toastMessageLabelWidth+24, 44);
                self.toastHUDView.frame = self.bounds;
                self.toastImageView.frame = CGRectZero;
                self.toastMessageLabel.frame = CGRectMake(12, (44-15)/2.0, toastMessageLabelWidth, 15);
            }
            // multiple lines
            else
            {
                toastMessageLabelWidth = screenWidth*0.75-24;
                CGFloat toastMessageLabelHeight = [NSMutableAttributedString zb_attributedStringHeightWithText:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:3.0 width:toastMessageLabelWidth];
                
                NSMutableAttributedString *messageAttributedText = [NSMutableAttributedString zb_attributedStringWithText:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:3.0];
                self.toastMessageLabel.attributedText = messageAttributedText;
                self.toastMessageLabel.textAlignment = NSTextAlignmentCenter;
                
                self.frame = CGRectMake((screenWidth-(toastMessageLabelWidth+24))/2.0, (screenHeight-(toastMessageLabelHeight+24))/2.0, toastMessageLabelWidth+24, toastMessageLabelHeight+24);
                self.toastHUDView.frame = self.bounds;
                self.toastImageView.frame = CGRectZero;
                self.toastMessageLabel.frame = CGRectMake(12, 12, toastMessageLabelWidth, toastMessageLabelHeight);
            }
        }
    }
    
}

#pragma mark - public method

// loading

- (void)showLoading
{
    [self showLoadingWithMaskType:ZBToastHUDLoadingMaskTypeNone];
}

- (void)showLoadingWithMaskType:(ZBToastHUDLoadingMaskType)maskType
{
    [self showLoadingWithMessage:@"" maskType:maskType];
}

- (void)showLoadingWithMessage:(NSString *)message
{
    [self showLoadingWithMessage:message maskType:ZBToastHUDLoadingMaskTypeNone];
}

- (void)showLoadingWithMessage:(NSString *)message maskType:(ZBToastHUDLoadingMaskType)maskType
{
    self.maskType = maskType;
    self.isLoadingHUD = YES;
    self.loadingMessageLabel.text = message;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.hidden = NO;
    [self startRotationAnimation];
}

- (void)dismissLoading
{
    [self dismissLoadingWithDelay:0.0 completion:nil];
}

- (void)dismissLoadingWithCompletion:(ZBToastHUDLoadingDismissCompletion)completion
{
    [self dismissLoadingWithDelay:0.0 completion:completion];
}

- (void)dismissLoadingWithDelay:(NSTimeInterval)delay
{
    [self dismissLoadingWithDelay:delay completion:nil];
}

- (void)dismissLoadingWithDelay:(NSTimeInterval)delay completion:(ZBToastHUDLoadingDismissCompletion)completion
{
    if (self.hidden == YES || !self.loadingHUDView) return;
    if (delay < 0) delay = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self stopRotationAnimation];
        [self removeFromSuperview];
        
        if (completion) {
            completion();
        }
    });
}

// toast

- (void)showWithMessage:(NSString *)message
{
    self.toastImageView.image = nil;
    self.toastMessageLabel.text = message;
    self.toastMessageLabel.font = [UIFont systemFontOfSize:14];
    
    [self showToast];
}

- (void)showNoNetwork
{
    UIImage *noNetworkImage = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_ToastNoNetwork"];
    [self showImage:noNetworkImage message:@"无网络连接"];
}

- (void)showSuccessWithMessage:(NSString *)message
{
    UIImage *successImage = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_ToastSuccess"];
    [self showImage:successImage message:message];
}

- (void)showErrorWithMessage:(NSString *)message
{
    UIImage *errorImage = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_ToastError"];
    [self showImage:errorImage message:message];
}

- (void)showWarningWithMessage:(NSString *)message
{
    UIImage *warningImage = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_ToastWarning"];
    [self showImage:warningImage message:message];
}

- (void)showImage:(UIImage *)image message:(NSString *)message
{
    self.toastImageView.image = image;
    self.toastMessageLabel.text = message;
    self.toastMessageLabel.font = [UIFont systemFontOfSize:12];
    
    [self showToast];
}

- (void)showToast
{
    self.isLoadingHUD = NO;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.hidden = NO;
    
    self.toastHUDView.alpha = 0;
    self.toastHUDView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.toastHUDView.transform = CGAffineTransformIdentity;
        self.toastHUDView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ZBToastHUDToastDismissDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissToast];
        });
    }];
}

- (void)dismissToast
{
    if (self.hidden == YES || !self.toastHUDView) return;
    self.hidden = YES;
    [self removeFromSuperview];
}

// loading and toast

- (void)dismiss
{
    if (self.loadingHUDView) {
        [self dismissLoading];
    }
    if (self.toastHUDView) {
        [self dismissToast];
    }
}

#pragma mark - private method

- (void)startRotationAnimation
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    rotationAnimation.delegate = self;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.loadingImageView.layer addAnimation:rotationAnimation forKey:ZBToastHUDLoadingAnimationKey];
}

- (void)stopRotationAnimation
{
    [self.loadingImageView.layer removeAnimationForKey:ZBToastHUDLoadingAnimationKey];
}

#pragma mark - getter

- (UIView *)loadingHUDView
{
    if (!_loadingHUDView) {
        _loadingHUDView = [[UIView alloc] init];
    }
    return _loadingHUDView;
}

- (UIImageView *)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
    }
    return _loadingImageView;
}

- (UILabel *)loadingMessageLabel
{
    if (!_loadingMessageLabel) {
        _loadingMessageLabel = [[UILabel alloc] init];
        _loadingMessageLabel.font = [UIFont systemFontOfSize:12];
        _loadingMessageLabel.textAlignment = NSTextAlignmentCenter;
        _loadingMessageLabel.textColor = [UIColor whiteColor];
    }
    return _loadingMessageLabel;
}

- (UIView *)toastHUDView
{
    if (!_toastHUDView) {
        _toastHUDView = [[UIView alloc] init];
        _toastHUDView.backgroundColor = [UIColor zb_colorWithValue:0x333333 alpha:0.8];
        _toastHUDView.layer.cornerRadius = 4.0;
        _toastHUDView.layer.masksToBounds = YES;
    }
    return _toastHUDView;
}

- (UIImageView *)toastImageView
{
    if (!_toastImageView) {
        _toastImageView = [[UIImageView alloc] init];
    }
    return _toastImageView;
}

- (UILabel *)toastMessageLabel
{
    if (!_toastMessageLabel) {
        _toastMessageLabel = [[UILabel alloc] init];
        _toastMessageLabel.font = [UIFont systemFontOfSize:12];
        _toastMessageLabel.textAlignment = NSTextAlignmentCenter;
        _toastMessageLabel.textColor = [UIColor whiteColor];
        _toastMessageLabel.numberOfLines = 0;
    }
    return _toastMessageLabel;
}

#pragma mark - setter

- (void)setStyle:(ZBToastHUDLoadingStyle)style
{
    _style = style;
}

@end
