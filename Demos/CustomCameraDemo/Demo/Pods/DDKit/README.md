# hk01-uikit framework

## Summary
hk01-uikit is a uikit-related private framework. 
1. hk01-uikit support sub frameworks, which means that you don't have to install the whole project when you just use some of the functions.
2. We are glad to see contributions of useful components to the framework. Any questions please email to xiaoleiyin@hk01.com.

## Usage:
> source 'https://github.com/CocoaPods/Specs.git'
> source 'https://github.com/hk01-digital/hk01-ios-uikit-spec.git'

## 0.1.0.2

### MJRefresh下拉 动态gif图片时，鉴于设计gif图片以3x作为标准，调整image


## 0.1.0.3

### Codables: 删除兼容数组问题，在具体使用中金融数据问题，不放在解析层面，解析层面当前只解决类型转换健壮性问题

## 0.1.0.4

### 图片控件添加Loading,解决多图片加载时间过长问题

## 0.1.0.5

### 图片控件权限结果回调给App端


## 0.1.0.7

### 拍照添加返回原图接口

## 0.1.0.8

### 修改弹窗多次问题

## 0.1.0.9

### Toast添加设置背景颜色，圆角；Hud考虑block中container输入nil问题

## 0.1.1.0

### ActionSheet扩展target可直接放置在window上；   单张图片预览开放RighteBarButtonItem操作

## 0.1.1.1

### 设置Alert的content换行模式

## 0.1.1.2

### 图片加载调整，图片预览在单张预览且可修改时设置可点击返回

## 0.1.1.3

### 1.照片最新的放在最下面，且默认滚动到底部  2.照片显示样式设置为aspectFill

## 0.1.1.4

### SToast提供title+message样式

## 0.1.1.5

### Hud提供BackgroundStyle参数，container为ScrollView时设置Loading时禁止滑动

## 0.1.1.6

### Sheet添加destructive样式

## 0.1.1.7

### hud提供空页面样式，用于限制当前页面操作

## 0.1.1.8
1.  完善Toast，兼容当Position = .bottom， container = ScrollView时的情况，
2.  提供Position = .top 时距上padding
3.  提供Position = .bottom 时距下padding
4.  提供半圆角参数设置

## 0.1.2.0
1. Codable兼容XCode10
2. Request请求 + Cache

## 0.1.2.1
1. 修复Alert与Sheet在Tag值相同时无法展示的问题


## 0.2.0.0
架构调整

## 0.2.0.1 - 0.2.0.2
本地获取图片时调整RightItem颜色

## 0.2.0.3
增加DDVideoPlayer组件
 [wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/VideoPlayer-user-guide)

## 0.2.0.4
WebJS对接方案

## 0.2.0.5
DDVideoPlayer 图片更新

## 0.2.0.6
新增DDPhotoPiker 相册组件
 [wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/DDPhotoPicker%EF%BC%88-%E5%9B%BE%E7%89%87%E9%80%89%E6%8B%A9%E5%99%A8%EF%BC%89%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)

## 0.2.0.8
更新DDPhotoPiker组件，新增视屏播放

## 0.2.0.9
更新DDVideoPlayer 布局，及替换新图标

## 0.2.0.10
更新DDPhotoPiker，适配iphonex以上机型

## 0.3.1
更新DDVideoPlayer ,添加暂停时显示播放按钮，添加isHiddenCellPlayBottomBar属性

## 0.3.2
更新DDPhotoPiker，解决横屏bug

## 0.3.3
更新DDPhotoPiker，DDPhotoImageManager新增几个API接口

## 0.4.0
新增DDPhotoBrowser
 [wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/DDPhotoBrowser-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)
 
## 0.4.1
新增DDCustomCamera
 [wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/DDCustomCamera-%E8%87%AA%E5%AE%9A%E4%B9%89%E7%9B%B8%E6%9C%BA)
 
## 0.4.2
更新DDCustomCamera，录制视屏不足1s，转为拍照

## 0.4.3
更新DDCustomCamera，更改相机，相册，麦克风授权

## 0.4.4
更新DDPhotoPiker，集成DDCustomCamera私有组件

## 0.4.5
新增DDScan
 [wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/DDScan-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)

## 0.4.6
DDCustomCamera新增闪光灯切换，集成DDPhotoBrowser, 

## 0.4.7
修改DDPhotoBrowser加载loading显示

## 0.4.8
替换DDPhotoBrowser加载loading样式

## 0.4.9
新增DDMediator组件
 [demo地址](https://github.com/weiweilidd01/DDMediator.git)

## 0.4.10
DDMediator组件新增缓存target
[demo地址](https://github.com/weiweilidd01/DDMediator.git)


## 0.5.0
新增DDRouter组件
[demo地址](https://github.com/weiweilidd01/DDRouter.git)


## 0.5.1
DDPhotoPiker新增上传照片或视频预览功能

## 0.5.2
新增MagicTextField 
[demo以及wiki文档](https://github.com/weiweilidd01/MagicTextField)


## 0.5.3
Core中新增如下三个：
*  1.UIKit+Closurable.swift  -----> 给UIResponder，UIView等常用kit，封装了闭包回调响应事件，比如UIButton的addTarget事件，UIView的手势添加l。详情见代码
*  2.UIKit+Chainable.swift  ---->  UIKit中常见的方法添加链式编程，方便快捷，详情见代码
*  3.NSObject+dispathTimer ---> 针对于NSTimer定时器的生命周期管理的不方便性，若管理不当，容易造成循环引用，因此封装了一个基于GCDTimer的定时器，常用于验证码等倒计时的功能


## 0.5.4
DDCustomCamera新增限制区域拍照功能 ，更多详情请参考wiki
[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/DDCustomCamera-%E8%87%AA%E5%AE%9A%E4%B9%89%E7%9B%B8%E6%9C%BA)

## 0.5.5
消除对WebJS的deployment_target依赖

## 0.5.6
全面更新toast和hud 的调用，全部扩展到view中，更多使用参考wiki
[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/Toast-&&-Hud%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)


## 0.5.7
新增EmptyDataView，网络请求时无数据返回情况下，空白占位图
[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/EmptyDataView%E7%BD%91%E7%BB%9C%E8%AF%B7%E6%B1%82%E8%BF%94%E5%9B%9E%E5%90%8E%E7%A9%BA%E7%99%BD%E9%A1%B5%E5%8D%A0%E4%BD%8D%E5%9B%BE--%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)



## 0.5.8
添加swiftLint代码检测

## 0.5.9
DDPhotoBrowser进行重构
1.将UIScrollView替换成UICollectionView，复用更好
2.优化展示动画
3.优化gif加载，减少 内存占用
[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/DDPhotoBrowser-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)

## 0.5.10
EmptyDataView进行重构
1.所有的展示类型全部通过注册方式注入
2.去除delegate,一切通过注入
[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/EmptyDataView%E7%BD%91%E7%BB%9C%E8%AF%B7%E6%B1%82%E8%BF%94%E5%9B%9E%E5%90%8E%E7%A9%BA%E7%99%BD%E9%A1%B5%E5%8D%A0%E4%BD%8D%E5%9B%BE--%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)


## 0.5.11
DDPhotoBrowser解决bug

## 0.5.12
Hud：解决Hud偶现Button问题


## 0.5.13
DDPhotoBrowser优化展示动画。

## 0.5.14
添加DevelopConfig，实现：
1、host 切换功能
2、网络监听功能


## 0.6.0
添加PageTabsController. 实现多级scrollView嵌套，更多功能参考wiki文档

[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/PageTabsController%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)


## 0.6.1
修改pop框架。PopViewController修改为open，支持继承

## 0.6.2
更新DDPhotoBrowser，新增：
/// 长按是否自动保存图片到相册，若为true,则长按代理不在回调。若为false，返回长按代理
public var isLongPressAutoSaveImageToAlbum: Bool = true

## 0.6.3
新增Picker
[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/Picker%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)

## 0.6.4
Core组件新增种类：
1. 将UIViewController+Extension.swif 更名为NSObject+TopViewController.swift
2. 新增NSObject+IsPhoneXAbove.swift ，判断当前机型是否是iphoneX以上的机型的
3.新增UIViewController+NavigationBarItem.swift。支持一行代码设置左右两边的UIBarButtonItem.支持带标题，带图片，自定义view，标题数组，图片数组等种类。具体看下面wiki文档
[wiki文档地址](https://github.com/hk01-digital/dd01-ios-ui-kit/wiki/Core%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97)

## 0.6.5
更新Core，UIViewController+NavigationBarItem调整多个item之间的间隙

## 0.6.6
更新DDPhotoPiker，解决相册无照片崩溃问题


## 0.6.7
更新Core:
UIViewController+NavigationBarItem新增导航栏透明度渐变

## 0.6.8
更新DDPhotoPiker: 修复相册跳转相机逻辑

## 0.6.9
将DDPhotoPiker合并到DDCustomCamera，因为两者两者互相嵌套，不能相互依赖

## 0.6.10
更新DDCustomCamera，修改不能获取app最上层viewcontroller

## 0.6.11
更新DDCustomCamera，优化跳转逻辑

## 0.6.12
更新DDCustomCamera,继续优化

## 0.6.13
新增ProgressHUD，提供更易用的 ProgressHUD 调用 API，使用详见Demo

## 0.6.14
整合DDKit：
1.删除PhotoBrowser，若拍照和选择照片请使用DDCustomCamera，若使用图片预览，请使用DDPhotoBrowser
2.删除Router，目前应该是没项目在使用，若需使用请使用DDRouter
3.将Toast，Alert，Sheet全部整合成Hud

## 0.6.15
调整模块命名
