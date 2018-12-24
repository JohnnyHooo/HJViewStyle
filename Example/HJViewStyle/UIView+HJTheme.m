//
//  UIView+HJTheme.m
//  HJViewStyle_Example
//
//  Created by JohnnyHoo on 2018/12/20.
//  Copyright © 2018 Johnny. All rights reserved.
//

#import "UIView+HJTheme.h"

@implementation UIView (HJTheme)


/*
 因为很多APP都会有主题颜色,为了更方便的设置主题色可以重写下面的方法
 */

- (UIColor *)themeGradientAColor
{
    return [UIColor redColor];
}

- (UIColor *)themeGradientBColor
{
    return [UIColor blueColor];
}

- (NSInteger)themeGradientStyle
{
    return 1;
}


@end
