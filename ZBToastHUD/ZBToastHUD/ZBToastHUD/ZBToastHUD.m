//
//  ZBToastHUD.m
//  ZBToastHUD
//
//  Created by yuanye on 2016/10/27.
//  Copyright © 2016年 yuanye. All rights reserved.
//

#import "ZBToastHUD.h"

static const CGFloat ZBToastHUDToastDismissDuration = 3.0;
static NSString *const ZBToastHUDLoadingAnimationKey = @"rotationAnimation";

@interface ZBToastHUD () <CAAnimationDelegate>

// loading
@property (nonatomic, strong) UIView *loadingHUDView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, assign) ZBToastHUDLoadingMaskType maskType;

// toast
@property (nonatomic, strong) UIView *toastHUDView;
@property (nonatomic, strong) UIImageView *toastImageView;
@property (nonatomic, strong) UILabel *toastMessageLabel;

//
@property (nonatomic, assign) BOOL isLoadingHUD;
@property (nonatomic, assign) BOOL isStartingAnim;

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
        self.isStartingAnim = NO;
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
        self.loadingHUDView.frame = CGRectMake((screenWidth-72)/2.0, (screenHeight-72)/2.0, 72, 72);
        self.loadingImageView.frame = CGRectMake((72-32)/2.0, (72-32)/2.0, 32, 32);
        
        // style
        if (self.style == ZBToastHUDLoadingStyleLight)
        {
            self.loadingImageView.image = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_LoadingStyleLight"];
            self.loadingHUDView.backgroundColor = [UIColor clearColor];
        }
        else
        {
            self.loadingImageView.image = [UIImage imageNamed:@"ZBToastHUD.bundle/ZBToastHUD_LoadingStyleDark"];
            self.loadingHUDView.backgroundColor = [self colorWithValue:0x333333 alpha:0.8];
            self.loadingHUDView.layer.cornerRadius = 4.0;
            self.loadingHUDView.layer.masksToBounds = YES;
        }
        
        // maskType
        if (self.maskType == ZBToastHUDLoadingMaskTypeClear)
        {
            self.backgroundColor = [UIColor clearColor];
            [self addSubview:self.loadingHUDView];
            [self.loadingHUDView addSubview:self.loadingImageView];
        }
        else if (self.maskType == ZBToastHUDLoadingMaskTypeDark)
        {
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            [self addSubview:self.loadingHUDView];
            [self.loadingHUDView addSubview:self.loadingImageView];
        }
        else
        {
            self.frame = CGRectZero;
            [self addSubview:self.loadingHUDView];
            [self.loadingHUDView addSubview:self.loadingImageView];
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
            CGFloat toastMessageLabelWidth = [self attributedStringWidthWithLabelHeight:13 text:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:0.0];
            if (toastMessageLabelWidth <= 96-24) {
                toastMessageLabelWidth = 96-24;
            }
            if (toastMessageLabelWidth >= screenWidth*0.75-24) {
                toastMessageLabelWidth = screenWidth*0.75-24;
            }
            
            self.toastHUDView.frame = CGRectMake((screenWidth-(toastMessageLabelWidth+24))/2.0, (screenHeight-76)/2.0, toastMessageLabelWidth+24, 76);
            self.toastImageView.frame = CGRectMake((toastMessageLabelWidth+24-24)/2.0, 18, 24, 24);
            self.toastMessageLabel.frame = CGRectMake(12, CGRectGetMaxY(self.toastImageView.frame)+8, toastMessageLabelWidth, 13);
        }
        else
        {
            CGFloat toastMessageLabelWidth = [self attributedStringWidthWithLabelHeight:15 text:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:0.0];
            // single line
            if (toastMessageLabelWidth <= screenWidth*0.75-24)
            {
                self.toastHUDView.frame = CGRectMake((screenWidth-(toastMessageLabelWidth+24))/2.0, (screenHeight-44)/2.0, toastMessageLabelWidth+24, 44);
                self.toastImageView.frame = CGRectZero;
                self.toastMessageLabel.frame = CGRectMake(12, (44-15)/2.0, toastMessageLabelWidth, 15);
            }
            // multiple lines
            else
            {
                toastMessageLabelWidth = screenWidth*0.75-24;
                CGFloat toastMessageLabelHeight = [self attributedStringHeightWithLabelWidth:toastMessageLabelWidth text:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:3.0];
                
                NSMutableAttributedString *messageAttributedText = [self attributedStringWithText:self.toastMessageLabel.text font:self.toastMessageLabel.font lineSpacing:3.0];
                self.toastMessageLabel.attributedText = messageAttributedText;
                self.toastMessageLabel.textAlignment = NSTextAlignmentCenter;
                
                self.toastHUDView.frame = CGRectMake((screenWidth-(toastMessageLabelWidth+24))/2.0, (screenHeight-(toastMessageLabelHeight+24))/2.0, toastMessageLabelWidth+24, toastMessageLabelHeight+24);
                self.toastImageView.frame = CGRectZero;
                self.toastMessageLabel.frame = CGRectMake(12, 12, toastMessageLabelWidth, toastMessageLabelHeight);
            }
        }
    }
    
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.loadingHUDView.layer valueForKey:ZBToastHUDLoadingAnimationKey] == anim)
    {
        if (self.isStartingAnim) {
            [self startRotationAnimation];
        } else {
            [self stopRotationAnimation];
        }
    }
}

#pragma mark - private method

- (void)startRotationAnimation
{
    self.isStartingAnim = YES;
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    rotationAnimation.delegate = self;
    [self.loadingImageView.layer addAnimation:rotationAnimation forKey:ZBToastHUDLoadingAnimationKey];
}

- (void)stopRotationAnimation
{
    self.isStartingAnim = NO;
    
    [self.loadingImageView.layer removeAnimationForKey:ZBToastHUDLoadingAnimationKey];
}

- (UIColor *)colorWithValue:(NSUInteger)rgbValue
{
    return [self colorWithValue:rgbValue alpha:1.0];
}

- (UIColor *)colorWithValue:(NSUInteger)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

- (NSMutableAttributedString *)attributedStringWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (CGFloat)attributedStringHeightWithLabelWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    return height;
}

- (CGFloat)attributedStringWidthWithLabelHeight:(CGFloat)height text:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
    return width;
}

#pragma mark - public method

// loading

- (void)showLoading
{
    [self showLoadingWithMaskType:ZBToastHUDLoadingMaskTypeNone];
}

- (void)showLoadingWithMaskType:(ZBToastHUDLoadingMaskType)maskType
{
    self.maskType = maskType;
    self.isLoadingHUD = YES;
    
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
    if (self.hidden == YES) {
        return;
    }
    
    if (delay < 0) {
        delay = 0;
    }
    
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
    self.hidden = YES;
    [self removeFromSuperview];
}

#pragma mark - getter and setter

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

- (void)setStyle:(ZBToastHUDLoadingStyle)style
{
    _style = style;
}

- (UIView *)toastHUDView
{
    if (!_toastHUDView) {
        _toastHUDView = [[UIView alloc] init];
        _toastHUDView.backgroundColor = [self colorWithValue:0x333333 alpha:0.8];
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

@end
