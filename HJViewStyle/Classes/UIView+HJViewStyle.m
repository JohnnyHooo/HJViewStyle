//
//  UIView+HJViewStyle.m
//  HJViewStyle
//
//  Created by JohnnyHoo on 2018/12/19.
//

#import "UIView+HJViewStyle.h"

#import <objc/runtime.h>

CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat scale)
{
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    CGFloat x = (rect.size.width-width)/2.0;
    CGFloat y = (rect.size.height-height)/2.0;
    return CGRectMake(rect.origin.x + x, rect.origin.y + y, width, height);
}
#define kShrinkScale 0.99

@implementation UIView (HJViewStyle)
@dynamic roundTop, roundLeft, roundBottom, borderWidth, borderColor, cornerRadius, shadowColor, shadowRadius, shadowOffset, shadowOpacity, themeGradientEnable, gradientStyle, gradientStyleEnum, gradientAColor, gradientBColor, shadowView, gradientLayer;

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
        UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
        if (shadowView) {
            self.shadowView.layer.maskedCorners = maskedCorners;
        }
        CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
        if (gradientLayer) {
            self.gradientLayer.maskedCorners = maskedCorners;
        }
        
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
    
    UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
    if (shadowView) {
        self.shadowView.layer.mask = clipLayer;
        self.shadowView.layer.shadowPath = path.CGPath;
    }
    
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (gradientLayer) {
        self.gradientLayer.mask = clipLayer;
        self.gradientLayer.shadowPath = path.CGPath;
    }
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
    self.clipsToBounds = true;
    self.layer.cornerRadius = cornerRadius;
    self.getStyleLayer.cornerRadius = cornerRadius;
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (gradientLayer) {
        self.gradientLayer.cornerRadius = cornerRadius;
    }
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
        return self.shadowView.layer;
    }else{
        return self.layer;
    }
}


// 阴影空视图，只在有圆角的时候使用
- (UIView *)shadowView{
    UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
    if (!shadowView) {
        shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = self.backgroundColor;
        
        shadowView.layer.shadowOpacity = self.layer.shadowOpacity?:1;
        shadowView.layer.shadowRadius = self.layer.shadowRadius?:1;
        shadowView.layer.shadowColor = self.shadowColor.CGColor;
        shadowView.layer.cornerRadius = self.cornerRadius;
        if (CGSizeEqualToSize(self.layer.shadowOffset, shadowView.layer.shadowOffset)) {
            shadowView.layer.shadowOffset = CGSizeZero;
        }
        objc_setAssociatedObject(self, @selector(shadowView), shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    // 禁止将 AutoresizingMask 转换为 Constraints
    shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview insertSubview:shadowView belowSubview:self];
    // 添加 right 约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.superview addConstraint:rightConstraint];
    
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.superview addConstraint:leftConstraint];
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.superview addConstraint:topConstraint];
    // 添加 bottom 约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.superview addConstraint:bottomConstraint];
    
    [self.superview insertSubview:shadowView belowSubview:self];
    
    return shadowView;
    
}

- (void)setShadowView:(UIView *)shadowView{
    objc_setAssociatedObject(self, @selector(shadowView), shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    
    UIColor *colorA = self.gradientAColor;
    UIColor *colorB = self.gradientBColor;
    GradientStyle gradientStyle = self.gradientStyle;
    
    if (!colorA && [self respondsToSelector:@selector(themeGradientAColor)]) {
        colorA = [self valueForKey:@"themeGradientAColor"];
    }
    if (!colorB && [self respondsToSelector:@selector(themeGradientBColor)]) {
        colorB = [self valueForKey:@"themeGradientBColor"];
    }
    if (!gradientStyle && [self respondsToSelector:@selector(themeGradientStyle)]) {
        gradientStyle = [[self valueForKey:@"themeGradientStyle"] integerValue];
    }
    
    if (colorA && colorB) {
        
        UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
        CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
        if (shadowView) {
            self.shadowView.frame = self.frame;
            if (gradientLayer) {
                self.gradientLayer.frame = CGRectScale(self.bounds, kShrinkScale);
            }
        }else if (gradientLayer) {
            self.gradientLayer.frame = CGRectScale(self.frame, kShrinkScale);
        }


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
    }
}

- (UIColor *)themeGradientAColor{
    return [UIColor redColor];
}

- (UIColor *)themeGradientBColor{
    return [UIColor blueColor];
}

- (NSInteger)themeGradientStyle
{
    return 1;
}

// 渐变空视图，只在有圆角的时候使用
- (CAGradientLayer *)gradientLayer{
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
        objc_setAssociatedObject(self, @selector(gradientLayer), gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.backgroundColor = [UIColor clearColor];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    return gradientLayer;
}

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer{
    objc_setAssociatedObject(self, @selector(gradientLayer), gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)hj_setFrame:(CGRect)frame
{
    [self hj_setFrame:frame];
    UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (shadowView) {
        self.shadowView.frame = frame;
    }
    if (gradientLayer) {
        self.gradientLayer.frame = CGRectScale(self.bounds, kShrinkScale);
    }

    [self refreshRoundingCorners];
    [self setLayerCcircleRadius];
    if (shadowView && !self.roundTop && !self.roundBottom && !self.roundLeft && !self.roundRight) {
        CGFloat cornerRadius = [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        self.shadowView.layer.shadowPath = path.CGPath;
    }
}


- (void)hj_layoutSubviews
{
    [self hj_layoutSubviews];
    UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (shadowView) {
        self.shadowView.frame = self.frame;
    }
    if (gradientLayer) {
        self.gradientLayer.frame = CGRectScale(self.bounds, kShrinkScale);
    }

    [self refreshRoundingCorners];
    [self setLayerCcircleRadius];
    if (shadowView && !self.roundTop && !self.roundBottom && !self.roundLeft && !self.roundRight) {
        CGFloat cornerRadius = [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        self.shadowView.layer.shadowPath = path.CGPath;
    }
}

- (void)hj_removeFromSuperview
{
    [self hj_removeFromSuperview];
    UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
    if (shadowView) {
        [self.shadowView removeFromSuperview];
    }
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
    }
}


- (void)hj_setAlpha:(CGFloat)alpha{
    [self hj_setAlpha:alpha];
    
    UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
    if (shadowView) {
        self.shadowView.alpha = alpha;
    }
    
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (gradientLayer) {
        self.gradientLayer.opacity = alpha;
    }
}

- (void)hj_setHidden:(BOOL)hidden
{
    [self hj_setHidden:hidden];
    UIView *shadowView = objc_getAssociatedObject(self, @selector(shadowView));
    if (shadowView) {
        self.shadowView.hidden = hidden;
    }
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(gradientLayer));
    if (gradientLayer) {
        self.gradientLayer.hidden = hidden;
    }
}



@end

