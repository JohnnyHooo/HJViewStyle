//
//  UIView+HJViewStyle.m
//  HJViewStyle
//
//  Created by JohnnyHoo on 2018/12/19.
//

#import "UIView+HJViewStyle.h"

#import <objc/runtime.h>

@implementation UIView (HJViewStyle)
@dynamic roundTop, roundLeft, roundBottom, borderWidth, borderColor, cornerRadius, shadowColor, shadowRadius, shadowOffset, shadowOpacity, themeGradientEnable, gradientStyle, gradientStyleEnum, gradientAColor, gradientBColor, backgroundShadowLayer, gradientLayer;

+(void)load{
    NSArray *arr = @[@"setHidden:" ,@"setAlpha:", @"layoutSubviews", @"removeFromSuperview", @"setFrame:"];
    for (NSString *str in arr) {
        NSString *new_str = [@"hj_" stringByAppendingString:str];
        
        SEL orignsel  = NSSelectorFromString(str);
        SEL exchgesel = NSSelectorFromString(new_str);
        
        Method originalM  = class_getInstanceMethod([self class], orignsel);
        Method exchangeM  = class_getInstanceMethod([self class], exchgesel);
        
        BOOL didAddMethod = class_addMethod([self class], orignsel, method_getImplementation(exchangeM), method_getTypeEncoding(exchangeM));
        if (didAddMethod)
        {
            class_replaceMethod([self class], exchgesel, method_getImplementation(originalM), method_getTypeEncoding(originalM));
        }
        else
        {
            method_exchangeImplementations(originalM, exchangeM);
        }
    }
}

///设置角圆角
- (void)setRound:(CACornerMask)maskedCorners
{
    self.clipsToBounds = true;
    if (@available(iOS 11.0, *)) {
        self.layer.maskedCorners = maskedCorners;
        self.backgroundShadowLayer.maskedCorners = maskedCorners;
        self.gradientLayer.maskedCorners = maskedCorners;
    } else {
        [self refreshRoundingCorners];
    }
}

//头部圆角
- (BOOL)roundTop {
    return [objc_getAssociatedObject(self, @selector(roundTop)) boolValue];
}
- (void)setRoundTop:(BOOL)roundTop {
    objc_setAssociatedObject(self, @selector(roundTop), @(roundTop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(roundTop) {
        [self setRound:kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner];
    }
}

//底部圆角
- (BOOL)roundBottom {
    return [objc_getAssociatedObject(self, @selector(roundBottom)) boolValue];
}
- (void)setRoundBottom:(BOOL)roundBottom {
    objc_setAssociatedObject(self, @selector(roundBottom), @(roundBottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(roundBottom) {
        [self setRound:kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner];
    }
}


//左边圆角
- (BOOL)roundLeft {
    return [objc_getAssociatedObject(self, @selector(roundLeft)) boolValue];
}
- (void)setRoundLeft:(BOOL)roundLeft {
    objc_setAssociatedObject(self, @selector(roundLeft), @(roundLeft), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(roundLeft) {
        [self setRound:kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner];
    }
}

//右边圆角
- (BOOL)roundRight {
    return [objc_getAssociatedObject(self, @selector(roundRight)) boolValue];
}
- (void)setRoundRight:(BOOL)roundRight {
    objc_setAssociatedObject(self, @selector(roundRight), @(roundRight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(roundRight) {
        [self setRound:kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner];
    }
}

// 渐变空视图，只在有圆角的时候使用
- (CAShapeLayer *)maskLayer{
    return objc_getAssociatedObject(self, @selector(maskLayer));
}

- (void)setMaskLayer:(CAShapeLayer *)maskLayer{
    objc_setAssociatedObject(self, @selector(maskLayer), maskLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//刷新圆角边框
- (void)refreshRoundingCorners{
    if (@available(iOS 11.0, *)) {
    }else{
        if (self.roundTop || self.roundBottom) {
            CGFloat radius = self.cornerRadius; // 圆角大小
            UIRectCorner corner = UIRectCornerAllCorners; // 圆角位置，全部位置
            if (self.roundTop) {
                corner = UIRectCornerTopLeft | UIRectCornerTopRight;
            }else if (self.roundBottom) {
                corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }else if (self.roundLeft) {
                corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            }else if (self.roundRight) {
                corner = UIRectCornerTopRight | UIRectCornerBottomRight;
            }
            
            [self setLayerCornerRadius:0];
            self.getStyleLayer.borderWidth = 0;
            self.getStyleLayer.borderColor = [UIColor clearColor].CGColor;
            [self setBorderWithCornerRadius:radius borderWidth:self.borderWidth borderColor:self.borderColor type:corner];

        }
    }
}

- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners {
    
    //    UIRectCorner type = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    
    //1. 加一个layer 显示形状
    CGRect rect = CGRectMake(borderWidth/2.0, borderWidth/2.0,
                             CGRectGetWidth(self.frame)-borderWidth, CGRectGetHeight(self.frame)-borderWidth);
    CGSize radii = CGSizeMake(cornerRadius, borderWidth);
    
    //create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    
    //create shape layer
    if (!self.maskLayer) {
        self.maskLayer = [[CAShapeLayer alloc] init];
    }
    
    self.maskLayer.strokeColor = borderColor.CGColor;
    self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    
    self.maskLayer.lineWidth = borderWidth;
    self.maskLayer.lineJoin = kCALineJoinRound;
    self.maskLayer.lineCap = kCALineCapRound;
    self.maskLayer.path = path.CGPath;
    [self.layer addSublayer:self.maskLayer];
    
    CAShapeLayer *clipLayer = [CAShapeLayer layer];
    clipLayer.path = path.CGPath;
    self.layer.mask = clipLayer;
    
    self.gradientLayer.mask = clipLayer;
    self.backgroundShadowLayer.mask = clipLayer;

}



//圆形
- (BOOL)circle {
    return [objc_getAssociatedObject(self, @selector(circle)) boolValue];
}
- (void)setCircle:(BOOL)circle {
    objc_setAssociatedObject(self, @selector(circle), @(circle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setLayerCcircleRadius];
}

- (void)setLayerCcircleRadius
{
    if (self.circle) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGFloat radius = (width > height ? height : width) / 2;
        [self setCornerRadius:radius];
    } else if (!self.circle && self.cornerRadius > 0) {
        [self setCornerRadius:self.cornerRadius];
    }
}

///圆角
- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    objc_setAssociatedObject(self, @selector(cornerRadius), @(cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setLayerCornerRadius:cornerRadius];
    [self refreshRoundingCorners];
}
///设置圆角
- (void)setLayerCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.getStyleLayer.cornerRadius = cornerRadius;
    self.gradientLayer.cornerRadius = cornerRadius;
}


///边框宽度
- (CGFloat)borderWidth {
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    objc_setAssociatedObject(self, @selector(borderWidth), @(borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.borderWidth = borderWidth;
    [self refreshRoundingCorners];
}


///边框颜色
- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, @selector(borderColor));
}
- (void)setBorderColor:(UIColor *)borderColor {
    objc_setAssociatedObject(self, @selector(borderColor), borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.borderColor = borderColor.CGColor;
    [self refreshRoundingCorners];
}


///阴影颜色
- (UIColor *)shadowColor {
    return objc_getAssociatedObject(self, @selector(shadowColor));
}
- (void)setShadowColor:(UIColor *)shadowColor
{
    objc_setAssociatedObject(self, @selector(shadowColor), shadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.getStyleLayer.shadowColor = shadowColor.CGColor;
}

///阴影半径
- (void)setShadowRadius:(CGFloat)shadowRadius
{
    self.getStyleLayer.shadowRadius = shadowRadius;;
}

///阴影偏移
- (void)setShadowOffset:(CGSize)shadowOffset
{
    self.getStyleLayer.shadowOffset = shadowOffset;;
}

///阴影透明度
- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.getStyleLayer.shadowOpacity = shadowOpacity;;
}

//阴影layer
- (CALayer *)getStyleLayer{
    if (self.shadowColor && self.clipsToBounds) {
        if (!self.backgroundShadowLayer) {
            self.backgroundShadowLayer = [[CALayer alloc] init];
            self.backgroundShadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
            self.backgroundShadowLayer.shadowOpacity = self.layer.shadowOpacity?:1;
            self.backgroundShadowLayer.shadowRadius = self.layer.shadowRadius?:1;
            self.backgroundShadowLayer.shadowColor = self.shadowColor.CGColor;
            self.backgroundShadowLayer.cornerRadius = self.cornerRadius;
            if (CGSizeEqualToSize(self.layer.shadowOffset, self.backgroundShadowLayer.shadowOffset)) {
                self.backgroundShadowLayer.shadowOffset = CGSizeZero;
            }
        }
        [self.superview.layer insertSublayer:self.backgroundShadowLayer below:self.layer];
        self.backgroundShadowLayer.frame = self.frame;
        
        return self.backgroundShadowLayer;
    }else{
        return self.layer;
    }
}


// 阴影空视图，只在有圆角的时候使用
- (CALayer *)backgroundShadowLayer{
    return objc_getAssociatedObject(self, @selector(backgroundShadowLayer));
}

- (void)setBackgroundShadowLayer:(CALayer *)backgroundShadowLayer{
    objc_setAssociatedObject(self, @selector(backgroundShadowLayer), backgroundShadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///渐变A颜色
- (void)setGradientAColor:(UIColor *)gradientAColor
{
    objc_setAssociatedObject(self, @selector(gradientAColor), gradientAColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawingGradientLayer];
}

- (UIColor *)gradientAColor {
    return objc_getAssociatedObject(self, @selector(gradientAColor));
}

///渐变B颜色
- (void)setGradientBColor:(UIColor *)gradientBColor
{
    objc_setAssociatedObject(self, @selector(gradientBColor), gradientBColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawingGradientLayer];
}
- (UIColor *)gradientBColor {
    return objc_getAssociatedObject(self, @selector(gradientBColor));
}

///渐变风格xib用
- (NSInteger)gradientStyleEnum
{
    return [objc_getAssociatedObject(self, @selector(gradientStyleEnum)) integerValue];
}
- (void)setGradientStyleEnum:(NSInteger)gradientStyleEnum
{
    objc_setAssociatedObject(self, @selector(gradientStyleEnum), @(gradientStyleEnum), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.gradientStyle = gradientStyleEnum;
}


///渐变风格
- (GradientStyle)gradientStyle
{
    return [objc_getAssociatedObject(self, @selector(gradientStyle)) integerValue];
}
- (void)setGradientStyle:(GradientStyle)gradientStyle{
    objc_setAssociatedObject(self, @selector(gradientStyle), @(gradientStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gradientStyle) [self drawingGradientLayer];
}

///是否开启主题渐变风格
- (BOOL)themeGradientEnable
{
    return [objc_getAssociatedObject(self, @selector(themeGradientEnable)) boolValue];
}

- (void)setThemeGradientEnable:(BOOL)themeGradientEnable{
    objc_setAssociatedObject(self, @selector(themeGradientEnable), @(themeGradientEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawingGradientLayer];
}


//渐变layer
- (void)drawingGradientLayer{
    
    UIColor *colorA = self.gradientAColor?:[self valueForKey:@"themeGradientAColor"];
    UIColor *colorB = self.gradientBColor?:[self valueForKey:@"themeGradientBColor"];
    GradientStyle gradientStyle = self.gradientStyle?:[[self valueForKey:@"themeGradientStyle"] integerValue];
    
    if (colorA && colorB) {
        if (!self.gradientLayer) {
            self.gradientLayer = [CAGradientLayer layer];
            [self.superview.layer insertSublayer:self.gradientLayer below:self.layer];
        }
        self.gradientLayer.frame = self.frame;
        
        self.gradientLayer.colors = @[(__bridge id)colorA.CGColor, (__bridge id)colorB.CGColor];
        //            self.gradientLayer.locations = @[@0.5, @0.5];
        if (gradientStyle == GradientStyleLeftToRight) {
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1.0, 0);
        }else{
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1.0);
        }
        self.gradientLayer.cornerRadius = self.cornerRadius;
        if (@available(iOS 11.0, *)) {
            self.gradientLayer.maskedCorners = self.getStyleLayer.maskedCorners;
        } else {
            [self refreshRoundingCorners];
        }
        self.backgroundColor = [UIColor clearColor];
    }
}



// 渐变空视图，只在有圆角的时候使用
- (CAGradientLayer *)gradientLayer{
    return objc_getAssociatedObject(self, @selector(gradientLayer));
}

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer{
    objc_setAssociatedObject(self, @selector(gradientLayer), gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)hj_setFrame:(CGRect)frame
{
    [self hj_setFrame:frame];
    if (self.backgroundShadowLayer) {
        self.backgroundShadowLayer.frame = frame;
    }
    if (self.gradientLayer) {
        self.gradientLayer.frame = self.frame;
    }
    [self refreshRoundingCorners];
    [self setLayerCcircleRadius];
}


- (void)hj_layoutSubviews
{
    [self hj_layoutSubviews];
    if (self.backgroundShadowLayer) {
        self.backgroundShadowLayer.frame = self.frame;
    }
    if (self.gradientLayer) {
        self.gradientLayer.frame = self.frame;
    }
    [self refreshRoundingCorners];
    [self setLayerCcircleRadius];
}

- (void)hj_removeFromSuperview
{
    [self hj_removeFromSuperview];
    if (self.backgroundShadowLayer) {
        [self.backgroundShadowLayer removeFromSuperlayer];
    }
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
    }
}


- (void)hj_setAlpha:(CGFloat)alpha{
    [self hj_setAlpha:alpha];
    
    if (self.backgroundShadowLayer) {
        self.backgroundShadowLayer.opacity = alpha;
    }
    if (self.gradientLayer) {
        self.gradientLayer.opacity = alpha;
    }
}

- (void)hj_setHidden:(BOOL)hidden
{
    [self hj_setHidden:hidden];
    if (self.backgroundShadowLayer) {
        self.backgroundShadowLayer.hidden = hidden;
    }
    if (self.gradientLayer) {
        self.gradientLayer.hidden = hidden;
    }
}



@end
