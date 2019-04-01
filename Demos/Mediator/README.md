# DDMediator --模块(业务)间通信中间者

### 前言：
怎么去判断一个成功的模块化？<br/>
个人见解：每个模块相当于一个独立的项目，能够即插即用，脱离任何的关联，拉到任意的项目中能够正常编译和运行
```
本组件只适用于模块(业务)间的通信，作为一个中间媒介，减少模块间的耦合关系
控制器与控制器之间的解耦请使用DDRoute
```
[具体的使用请参照demo](https://github.com/weiweilidd01/DDMediator.git)

#### 1.app中常见的层级结构
<img src="https://upload-images.jianshu.io/upload_images/2026287-16311aa4a72a70a6.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=400 height=500 />

#### 2.常见的业务之间关联关系
<img src="https://upload-images.jianshu.io/upload_images/2026287-5a014afade8e4d35.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=400 height=400 />

图中业务模块分类只是随便举例，模拟在业务间可能存在的耦合关系。<br/>
若业务众多，业务间实际的耦合关系可能会复杂。

#### 3.采用DDMediator业务之间的关系
<img src="https://upload-images.jianshu.io/upload_images/2026287-ea2695b2cafda3db.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=400 height=400 />

DDMediator作为一个中间者，协调各个模块之间的通信传输。<br/>
* 未采用中间媒介，业务间的传递关系为:<br/>
 **A <---> B**<br/>
* 采用之后，关系为:<br/>
 **A <---> Mediator <---> B**<br/>
 
* 从开发角度看，中间多了一层Mediator，感觉让人更复杂，觉得有点多余麻烦<br/>
* 从业务角度看，大大减少了不同业务间的耦合，更方便灵活的管理整个业务的版本迭代，对于产品线众多的情况，相同的业务可以更快速灵活的移植<br/>
* 对于多人开发同一产品，只需pod自己的业务模块即可，大大的提供xcode编译速度，大大减少github冲突问题<br/>

#### 4.模块化浅谈
* 1.什么情况下需要模块化<br/>
个人见解： 如果产品线单一，同一个产品人数不超过4人，个人觉得没必要模块化<br/>

* 2.在开发的哪个阶段模块化<br/>
个人见解： 在业务上线后，进入正常的迭代需求。再去着手模块化。若在项目的建立阶段，就统一模块化，会花费大量的时间和精力在一些基础劳动力上，大大影响写代码的心情，也会拖延前期产品规划的业务需求，前期开发对业务模块的划分还没有明确的清晰<br/>

#### 5.Mediator实现思路
核心代码非常简单，不到40行<br/>
采用了iOS大神[casatwy](https://github.com/casatwy/CTMediator.git)提出的Target-Action方式。<br/>
他的方案有个大痛点：就是没有callback回调。 业务场景：若A模块需求获取B模块的数据，需要B模块提供action响应此需求。网络请求存在延时回调。他的方案就不能解决<br/>
因此，本方案增加了callback，满足更多的业务需求场景。<br/>
将模块传的参数与callback统一封装到MediatorParams一个对象中传递。<br/>
```
extension DDMediator {
public func perform(Target targetName: String, actionName: String, params: MediatorParamDic?, complete: MediatorCallBack?) {
        /// 获取targetClass字符串
        let swiftModuleName = params?[kMediatorTargetModuleName] as? String
        var targetClassString: String?
        if (swiftModuleName?.count ?? 0) > 0 {
            targetClassString = (swiftModuleName ?? "") + "." + "\(moduleName)_\(targetName)"
        } else {
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            targetClassString = namespace + "." + "Target_\(targetName)"
        }
        
        guard let classString = targetClassString  else {
            return
        }
        
        //获取Target对象
        let targetClass = NSClassFromString(classString) as! NSObject.Type
        let target = targetClass.init()
        
        //获取Target对象中的方法Selector
        let sel = Selector(actionName)
        
        //定义回调block
        let result: MediatorCallBack = { res in
            complete?(res)
        }
        
        //创建参数model
        let model = MediatorParams()
        model.callBack = result
        model.params = params
        if target.responds(to: sel) == true {
            target.perform(sel, with: model)
        }
        
        return
    }
}

```
#### 7.模块间调用的流程图：
<img src="https://upload-images.jianshu.io/upload_images/2026287-68a3846717f57020.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=800 height=400 />

#### 8.集成，已经上传至DDKit

#### 9.总结：

 **模块化只是一个架构思路，如何在不同模块之间建立一个桥梁。一千个开发者心中有一千个Mediator的方式。所完成的任务归根结底都是为了减少模块间的耦合，及处理模块间的数据传递途径**
<br/>
**本Demo方案不是最优，有更好的点子再采纳**
