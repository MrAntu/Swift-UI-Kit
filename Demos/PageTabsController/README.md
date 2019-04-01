# PageTabsController使用指南

#### 1.多级嵌套ScrollView使用

<img src="https://upload-images.jianshu.io/upload_images/2026287-a1b246afc32d0e86.gif?imageMogr2/auto-orient/strip" width=200 height=400 />

*  1.大容器请直接继承PageTabsContainerController类。具体使用参考demo
*  2.若要实现header下拉刷新，请在大容器中实现对应的方法。具体使用参考demo
*  3.若要实现滚动隐藏导航栏，请在大容器中重写父类方法，具体使用参开demo
*  4.tabs子类请直接继承PageTabsBaseController
*  5.tabs子类中必须设置实现UIScrollView的代理，才能控制滚动。同理UITableView，UISCrolleView，UICollectionView同样使用。PageTabsBaseController已经默认创建UITableView。 demo中也提供了嵌套网页的使用说明。具体使用参考demo

#### 2.无header的多级嵌套使用

<img src="https://upload-images.jianshu.io/upload_images/2026287-4f0da15835d2903f.gif?imageMogr2/auto-orient/strip" width=200 height=400 />

*  1.基本使用同上。具体使用参考demo
*  2.下拉刷新的实现，则由tabs子控制器自己去实现。具体使用参考demo


#### 3.PageSegmentView单独使用说明

<img src="https://upload-images.jianshu.io/upload_images/2026287-00d8563513df9517.gif?imageMogr2/auto-orient/strip" width=200 height=400 />

```
        let list = ["列表1", "列表2", "列表3", "列表4", "列表5", "列表6"]
        segmentView.itemList = list
        segmentView.delegate = self
        segmentView.itemWidth = 100
        segmentView.bottomLineWidth = 20
        segmentView.bottomLineHeight = 2
        view.addSubview(segmentView)
        
        //初始化默认选择
        segmentView.scrollToIndex(5)
        

```
代理设置
```
//当前点击的Index
 func segmentView(segmentView: PageSegmentView, didScrollTo index: Int) {
        print(index)
    }
```
