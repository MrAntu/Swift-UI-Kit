# DDRouter -- 控制器之间的跳转路由

#### 1.常见的控制器之间的跳转
<img src="https://upload-images.jianshu.io/upload_images/2026287-fee2f66cec32dab4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=400 height=200 />

以上跳转存在哪些问题：<br/>
1.架构层面: 业务之间有耦合，界面之间也有耦合，a和b就紧紧的绑在一起<br/>
2.业务方面: 若控制器a和b不在一个业务模块中，就不利于模块间的拆分，将b剥离出，a中就会编译出错，无法实现业务的独立

#### 2.采用DDRouter的关系

<img src="https://upload-images.jianshu.io/upload_images/2026287-7eca5b3aaf0e1adc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=400 height=180 />

#### 3.DDRouter的实现

采用字符串映射关系，实现对象创建。<br/>
核心代码
```
 open func pushViewController(_ key: String, params: DDRouterParameter? = nil, animated: Bool = true, complete:((Any?)->())? = nil) {
        let cls = classFromeString(key: key)
        let vc = cls.init()
        vc.params = params
        vc.complete = complete
        vc.hidesBottomBarWhenPushed = true
        
        let topViewController = DDRouterUtils.currentTopViewController()
        if topViewController?.navigationController != nil {
            topViewController?.navigationController?.pushViewController(vc, animated: animated)
        } else {
            topViewController?.present(vc, animated: animated, completion: nil)
        }
    }
```

```
open func classFromeString(key: String) -> UIViewController.Type {
        if key.contains(".") == true {
            let clsName = key
            let cls = NSClassFromString(clsName) as! UIViewController.Type
            return cls
        }
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let clsName = namespace + "." + key
        let cls = NSClassFromString(clsName) as! UIViewController.Type
        return cls
    }
```

#### 4.如何使用

* 1.key定义为对应的控制器名字

*   2.a->b 跳转 <br/>
    
    ```
        let model = Model()
        pushViewController("BViewController", params: ["model": model,"title": "hello"], animated: true) { (res) in
            //上级界面回调
            print(res)
        }
    ```
    
####  5.方法讲解
已经将DDRouter的方法全部扩展到UIViewController,更人性化的调用。

```
  /// 路由入口 push
    ///
    /// - Parameters:
    ///   - key: 定义的key
    ///   - params: 需要传递的参数
    ///   - parent: 是否是present显示
    ///   - animated: 是否需要动画
    ///   - complete: 上级控制器回调传值，只能层级传递
    public func pushViewController(_ key: String, params: DDRouterParameter? = nil, animated: Bool = true, complete:((Any?)->())? = nil) 
    
    /// 路由入口 present
    ///
    /// - Parameters:
    ///   - key: 路由key
    ///   - params: 参数
    ///   - animated: 是否需要动画
    ///   - complete: 上级控制器回调传值，只能层级传递
    public func presentViewController(_ key: String, params: DDRouterParameter? = nil, animated: Bool = true, complete:((Any?)->())? = nil) 
    
    
    /// 正常的pop操作
    ///
    /// - Parameters:
    ///   - vc: 当前控制器
    ///   - dismiss: true: dismiss退出，false: pop退出
    ///   - animated: 是否需要动画
    public func pop(animated: Bool = true) 
    
     /// pop到指定的控制器
    ///
    /// - Parameters:
    ///   - currentVC: 当前控制器
    ///   - toVC: 目标控制器对应的key
    ///   - animated: 是否需要动画
    public func pop(ToViewController toVC: String, animated: Bool = true) 
    
     /// pop到根目录
    ///
    /// - Parameters:
    ///   - currentVC: 当前控制器
    ///   - animated: 是否需要动画
    public func pop(ToRootViewController animated: Bool = true)
    
    /// dismiss操作
    ///
    /// - Parameters:
    ///   - vc: 当前控制器
    ///   - animated: 是否需要动画
    public func dismiss(_ animated: Bool = true) 
```

 并给每个控制器对象绑定一个params和complete属性,可任意的传值，以及控制器之间数据的回调

```

    public var params: DDRouterParameter? {
        set {
            objc_setAssociatedObject(self, &DDRouterAssociatedKeys.paramsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &DDRouterAssociatedKeys.paramsKey) as? DDRouterParameter
        }
    }
    
    /// 添加回调闭包，适用于反向传值，只能层级传递
    public var complete: ((Any?)->())? {
        set {
            objc_setAssociatedObject(self, &DDRouterAssociatedKeys.completeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &DDRouterAssociatedKeys.completeKey) as? ((Any?) -> ())
            
        }
    }
```

#### 6.[查看demo更多场景使用](https://github.com/weiweilidd01/DDRouter.git)

#### 7.集成，已经上传至DDKit

    
