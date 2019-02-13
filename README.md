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
self.view.shadowColor = [UIColor whiteColor];
self.view.shadowOffset = CGSizeMake(0, 2);
self.view.cornerRadius = 10;
self.view.borderColor = [UIColor blackColor];
self.view.borderWidth = 4;
self.view.backgroundColor = [UIColor redColor];
```


