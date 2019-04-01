# MagicTextField

[demo下载地址](https://github.com/weiweilidd01/MagicTextField)
#### 1.效果图

<img src="https://upload-images.jianshu.io/upload_images/2026287-a251d2d86e85276e.gif?imageMogr2/auto-orient/strip" width=300 height=500 />

#### 2.代码使用

```
        accountInput.placeholder = "請輸入手機號碼"
        accountInput.animatedText = "手机号码"
        accountInput.font = UIFont.systemFont(ofSize: 14)
        accountInput.animatedFont = UIFont.systemFont(ofSize: 12)
        accountInput.textAlignment = .left
        accountInput.marginLeft = 10
        accountInput.placeholderColor = UIColor.red
        accountInput.animatedPlaceholderColor = UIColor.blue
        accountInput.moveDistance = 30
        accountInput.borderStyle = .line
        accountInput.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        view.addSubview(accountInput)
```

##### 4.能设置的参数

```
    //placeholder移动后的字体大小
    public var animatedFont: UIFont? = UIFont.systemFont(ofSize: 12)
    //placeholder移动后的文字显示
    public var animatedText: String?
    //placeholder向上移动的距离，负数向下
    public var moveDistance: CGFloat = 0.0
    //UITextFieldDidChange事件回调
    public var magicFieldDidChangeCallBack: (()->())?
    //placeholder的颜色,默认为灰色
    public var placeholderColor: UIColor?
    //placeholder移动后的颜色,默认为placeholderColor,设置此属性一定要在设置 placeholderColor的后面
    public var animatedPlaceholderColor: UIColor?
    //离输入框左边的边距,默认为0
    public var marginLeft: CGFloat = 0
    //重写父类placeholder
    override public var placeholder: String? 
    //重写父类textAlignment
    override public var textAlignment: NSTextAlignment 
    //重写父类font
    override public var font: UIFont? 
    
```
