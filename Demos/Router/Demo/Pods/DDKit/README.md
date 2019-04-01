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

