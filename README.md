<img src="https://github.com/JohnnyHooo/HJViewStyle/blob/master/Example/HJViewStyle/Images.xcassets/head.imageset/icon.png?raw=true" width="100" height="100" alt="Logo" align=left />  

# HJViewStyle
[![CI Status](http://img.shields.io/travis/Johnny/HJViewStyle.svg?style=flat)](https://travis-ci.org/Johnny/HJViewStyle)
[![Version](https://img.shields.io/cocoapods/v/HJViewStyle.svg?style=flat)](http://cocoapods.org/pods/HJViewStyle)
[![License](https://img.shields.io/cocoapods/l/HJViewStyle.svg?style=flat)](http://cocoapods.org/pods/HJViewStyle)
[![Platform](https://img.shields.io/cocoapods/p/HJViewStyle.svg?style=flat)](http://cocoapods.org/pods/HJViewStyle)


## 前言
```ruby
xib零代码和代码快速设置View各种样式,实现阴影圆角并存,渐变色背景等功能❗️
```

<br /> 
<img src="https://github.com/JohnnyHooo/HJViewStyle/blob/master/HJViewStyle.png?raw=true"  width="313" height="616"  alt="Demo效果" align=right />

## 特点
- xib零代码和代码快速设置View各种样式

- 阴影和圆角并存

- 渐变色背景

- 根据主题色快速设置渐变背景色


## 安装

### 支持 Cocoapods 安装

```ruby
pod 'HJViewStyle'
```
<br /> 

## 使用
**所有方法都可以直接看 
#import "UIView+HJViewStyle.h"
中的声明以及注释。**
```objc
    //代码示例
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(100, 100, 100, 100);
    label.backgroundColor = UIColor.redColor;
    label.text = @"代码View";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;

    
    label.shadowRadius = 10;
    label.shadowColor = UIColor.whiteColor;
    label.shadowOffset = CGSizeMake(0, 0);
    label.shadowOpacity = 1;
    
    label.cornerRadius = 20;
    label.borderColor = UIColor.whiteColor;
    label.borderWidth = 10;

    label.gradientStyle = GradientStyleLeftToRight;
    label.gradientAColor = UIColor.redColor;
    label.gradientBColor = UIColor.purpleColor;
    [self.view addSubview:label];

```


