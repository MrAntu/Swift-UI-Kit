# Chainable - 扩展UIView及其子类，支持链式语法调用

[demo地址](https://github.com/weiweilidd01/Chainable)

目前支持UIView中所有常见的子类，将其可写属性添加链式语法。
支持的UIView及其子类有：
 *  UIView本身
 *  UILabel
 *  UIButton
 *  UIImageView
 *  UISlider
 *  UIProgressView
 *  UISwitch
 *  UISegmentedControl
 *  UITextField
 *  UITableView -- 替换成ChainableTableView，解决和UIPickerView代理冲突
 *  UITextView
 *  UIScrollView
 *  UICollectionView
 *  UISearchBar
 *  Notification
 * UIViewController+NavigationBarItem 一行代码给导航栏添加barItem，新增渐变导航栏的透明度
 * UIViewController+TopViewController 获得当前app最上层的viewController
 * Timer+Block 封装Timer block回调
 **除添加系统所有属性外，几大重点关注点：**
* **1、将UIVIew及其子类可直接通过点语法添加单击，双击，长按等手势，还有移除所有子类等常见操作方法。**
* **2、将UIControl中事件加入链式语法**
* **3、将上述所列UIView中有代理属性的类，全部支持链式回调**
* **4、UITextField支持最大字数限制属性**
* **5、UITextView支持最大字数限制属性，支持设置placeholder属性**
* **6、所有的NSObject对象支持一键添加通知，无需removeObserver。**
* **7、集成Snapkit**

### 1.Snapkit布局 --- Example
```
// 1. removeConstraints
// 2. makeConstraints
// 3. remakeConstraints
// 4. updateConstraints
 UILabel()
            .add(to: view)
            .backgroundColor(UIColor.red)
            .removeConstraints()
            .makeConstraints { (make) in
                make.top.equalTo(100)
                make.left.equalTo(100)
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            .remakeConstraints { (make) in
                make.top.equalTo(100)
                make.left.equalTo(100)
                make.width.equalTo(200)
                make.height.equalTo(100)
                
            }
            .updateConstraints { (make) in
                make.height.equalTo(200)
            }
```


### 2.UIView --- Example

```
       //UIView 扩展了单击，双击，长按手势
        UIView()
            .frame(CGRect(x: 50, y: 400, width: 50, height: 50))
            .backgroundColor(UIColor.black)
            .sizeFit()
            .isUserInteractionEnabled(true)
            .addTapGesture { (v, tap) in
                print("单击")
            }
            .addDoubleGesture { (v, tap) in
                print("双击")
            }
            .addLongGesture { (v, long) in
                print("长按")
            }
            .add(to: view)
```

### 3.UILabel --- Example

```
       lab.backgroundColor(UIColor.red)
            .alpha(0.4)
            .border(UIColor.black, 1)
            .textAlignment(.center)
            .numberOfLines(0)
            .font(12)
            .frame(CGRect(x: 50, y: 200, width: 200, height: 100))
            .text("收到货方式来开发框架地方sdfkhjjhsjfdkh是否点击康师傅")
            .textColor(UIColor.green)
            .shadowColor(UIColor.black)
            .shadowOffset(CGSize(width: 1, height: 2))
            .lineBreakMode(.byCharWrapping)
            .attributedText(NSAttributedString(string: "是打飞机了就开始发动机"))
            .highlightedTextColor(UIColor.purple)
            .isHighlighted(true)
            .isUserInteractionEnabled(true)
            .isEnabled(true)
            .adjustsFontSizeToFitWidth(true)
            .minimumScaleFactor(10)
```

### 4.UIButton --- Example

```
        //Button扩展新功能
        //imagePosition 任意切换文字和图片混合button的位置
        // 提供TargetAction点击事件。目前只提供.touchUpInside
         UIButton(type: .system)
            .frame(CGRect(x: 150, y: 400, width: 50, height: 50))
            .setTitle("按钮", state: .normal)
            .setImage(UIImage(named: "nav_icon_back_black"), state: .normal)
            .setTitleColor(UIColor.red, state: .normal)
            .add(to: view)
            .addActionTouchUpInside({ (btn) in
                print("按钮")
                
            })
            .font(18)
            .imagePosition(.top, space: 10)
```

### 5.UIImageView --- Example

```
UIImageView()
            .frame(CGRect(x: 250, y: 400, width: 50, height: 50))
            .addTapGesture { (v, tap) in
                print("图片")
            }
            .image(UIImage(named: "nav_icon_back_black"))
            .add(to: view)
```

### 6.UISlider --- Example

```
        slider
            .maximumValue(1.0)
            .minimumValue(0)
            .value(0)
            .maximumTrackTintColor(UIColor.red)
            .minimumTrackTintColor(UIColor.blue)
            .addAction(events: .valueChanged) {[weak self] (sender) in
                print("slider---\(sender.value)")
                self?.progressView.setProgress(sender.value, animated: true)
            }
```

### 7.UIProgressView --- Example

```
 progressView
            .progress(0)
            .progressViewStyle(.bar)
            .progressTintColor(UIColor.green)
            .trackTintColor(UIColor.yellow)
```

### 8.UISwitch --- Example

```
 switchView
            .onTintColor(UIColor.red)
            .thumbTintColor(UIColor.black)
            .isOn(false)
            .addAction(events: .valueChanged) { (s) in
                print("switch的值：\(s.isOn)")
            }
```

### 9.UISegmentedControl --- Example

```
 UISegmentedControl(items: ["吕布", "曹操", "白起","程咬金"])
            .frame(CGRect(x: 50, y: 320, width: 200, height: 30))
            .tintColor(UIColor.red)
            .apportionsSegmentWidthsByContent(true)
            .selectedSegmentIndex(1)
            .addAction(events: .valueChanged) { (sender) in
                print("选中了： \(sender.selectedSegmentIndex)")
            }
            .add(to: view)
```

### 910.UITextField --- Example

```
        // input1 不需要设置代理
        //支持最大长度限制
        // 支持所有代理协议回调
        // 支持输入抖动动画
        //通过系统方法设置代理，只走协议方法
        //不会走链式block回调
        input1.placeholder("我是input1")
            .addShouldBegindEditingBlock { (field) -> (Bool) in
                return true
            }
            .addShouldChangeCharactersInRangeBlock { (field, range, text) -> (Bool) in
                print("input1: \(text)")
                return true
            }
            .maxLength(5)
            .shake(true)
```

### 11.UIScrollView --- Example

```
  //支持所有代理回调
        scrollView.frame(CGRect(x: 0, y: 100, width: w, height: 200))
                .backgroundColor(UIColor.green)
                .isPagingEnabled(true)
                .bounces(true)
                .add(subView: lab1)
                .add(subView: lab2)
                .add(subView: lab3)
                .contentSize(CGSize(width: w * 3, height: 200))
                .add(to: view)
                .addScrollViewDidScrollBlock { (scroll) in
                    print(scroll.contentOffset)
                }

```

### 12.UITableView(已经替换成ChainableTableView，解决和UIPickerView代理冲突) --- Example 

```
// TODO: --
        //若用此链式添加UITableViewDelegate代理方法，请注意：
        //1、若需要实现自动估值计算。请实现链式中属性方法进行设置，UITableViewDelegate代理方法中的估值方法不再提供接口
        
        //2. 若通过链式获取代理回调，请不要通过系统方法设置代理，tableVie.delegate = self, tableVie.dataSource = self，否则会无效。
        
        //3. 若链式代理无法满足需求。请设置tableVie.delegate = self, tableVie.dataSource = self再自行实现代理
        
        //扩展全部UITableViewDatasource协议
        //扩展了90%协议，未扩展协议为冷门协议，对日常使用无影响
        tableView
            .register(for: UITableViewCell.self, cellReuseIdentifier: "cell")
            .register(for: UITableViewHeaderFooterView.self, headerFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
//            .estimatedRowHeight(200)
//            .estimatedSectionHeaderHeight(100)
//            .estimatedSectionFooterHeight(0.1)
            .addNumberOfSectionsBlock { (tab) -> (Int) in
                return 5
            }
            .addNumberOfRowsInSectionBlock { (tab, sec) -> (Int) in
                return 10
            }
            .addHeightForRowAtIndexPathBlock({ (tab, indexPath) -> (CGFloat) in
                return 100
            })
            .addHeightForHeaderInSectionBlock({ (tab, section) -> (CGFloat) in
                return 50
            })
            .addViewForHeaderInSectionBlock({ (tab, section) -> (UIView?) in
                if let header = tab.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView") {
                    header.textLabel?
                        .text("我是第\(section)组")
                        .font(18)
                        .textColor(UIColor.red)
                    return header
                }
                return UIView()
            })
            .addViewForFooterInSectionBlock({ (tab, section) -> (UIView?) in
                return UIView()
            })
            .addCellForRowAtIndexPathBlock {[weak self] (tab, indexPath) -> (UITableViewCell) in
                if let cell = self?.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) {
                    cell.textLabel?.text = "\(indexPath.section)组" + "-- \(indexPath.row)行"
                    return  cell
                }
                
                return UITableViewCell()
            }
            .addDidSelectRowAtIndexPathBlock({ (tab, indexPath) in
                tab.deselectRow(at: indexPath, animated: true)
                print("点击了第\(indexPath.section)组，第\(indexPath.row)行")
            })
            .addScrollViewDidScrollBlock({ (scrollView) in
                print(scrollView.contentOffset)
            })
            .reload()
```

### 13.UITextView --- Example

```
 // TODO: 注意
        // 若同时初始化 text 和 placeholder，一定要注意先后顺序，placeholder在前，text在后。否则会有点小bug，是系统的问题
        
        //支持最大字数限制
        //支持设置placeholder
        textView.textColor(UIColor.red)
                .addShouldBegindEditingBlock { (t) -> (Bool) in
                    print("addShouldBegindEditingBlock")
                    return true
                }
                .addDidChangeBlock { (t) in
                    print("addDidChangeBlock")
                }
                .addShouldChangeTextInRangeReplacementTextBlock { (t, range, text) -> (Bool) in
                    print(text)
                    return true
                }
                .maxLength(5)
                .placeholder("我是是否带回家sdfsdf")
//                .text("qwqweqew")
        
```


### 14.UICollectionView --- Example

```
        flowLayout.scrollDirection = .vertical

        //将所有90%的delegate代理方法支持回调
        //所有的datasource支持回调
        //所有的UICollectionViewDelegateFlowLayout支持回调
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: w, height: h), collectionViewLayout: flowLayout)
                    .isPagingEnabled(false)
                    .registerCell(UICollectionViewCell.self, ReuseIdentifier: "UICollectionViewCell")
                    .registerSupplementaryView(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, ReuseIdentifier: "UICollectionReusableView")
                    .addNumberOfSectionsBlock({ (collection) -> (Int) in
                        return 10
                    })
                    .addNumberOfItemsInSectionBlock({ (collection, section) -> (Int) in
                        return 10
                    })
                    .addLayoutCollectionViewLayoutSizeForItemAtIndexPathBlock({[weak self] (collection, layout, indexPath) -> (CGSize) in
                        return CGSize(width: self?.w ?? 0, height: 200)
                    })
                    .addLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock({[weak self] (collection, layout, section) -> (CGSize) in
                        return CGSize(width: self?.w ?? 0, height: 130)
                    })
                    .addCellForItemAtIndexPathBlock({[weak self] (collection, indexPath) -> (UICollectionViewCell) in
                        if  let cell = self?.collectionView?.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath) {
                            let lab = UILabel(frame: cell.bounds)
                                .text("\(indexPath.section) : \(indexPath.row)")
                                .textAlignment(.center)
                                .font(20)
                                .backgroundColor(UIColor.green)
                            
                            cell.contentView
                                .removeAllSubViews()
                                .add(subView: lab)
                            
                            return cell
                        }
                        
                        return UICollectionViewCell()
                    })
                    .addViewForSupplementaryElementOfKindAtIndexPathBlock({ (collection, kind, indexPath) -> (UICollectionReusableView) in
                        if kind == UICollectionElementKindSectionHeader {
                            let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
                            let lab = UILabel()
                                .frame(header.bounds)
                                .text("我是第\(indexPath.section)组")
                                .textColor(UIColor.red)
                                .font(18)
                                .textAlignment(.center)
                            
                            header.removeAllSubViews()
                                  .add(subView: lab)
                            
                            return header
                        }
                        return UICollectionReusableView()
                    })
                    .addDidSelectItemAtIndexPathBlock({ (collection, indexPath) in
                        print("\(indexPath.section): \(indexPath.row)")
                    })
                    .backgroundColor(UIColor.white)
                    .addLongGesture({[weak self](collection, longPress) in
                        let point = longPress.location(in: collection)
                        let indexPath = collection.indexPathForItem(at: point)

                        switch longPress.state {
                        case .began:
                            if let index = indexPath {
                                //开始移动
                                self?.collectionView?.beginInteractiveMovementForItem(at: index)
                            }
                            print("began")
                        case .changed:
                            //更新位置坐标
                            self?.collectionView?.updateInteractiveMovementTargetPosition(point)
                            print("changed")

                        case .ended:
                            //停止移动调用此方法
                            self?.collectionView?.endInteractiveMovement()
                            print("end")
                        default:
                            //取消移动
                            self?.collectionView?.cancelInteractiveMovement()
                            print("default")

                            break
                        }
                    })
                    .addCanMoveItemAtIndexPathBlock({ (collection, indexPath) -> (Bool) in
                        return true
                    })
                    .addMoveItemAtSourceIndexPathToDestinationIndexPathBlock({ (collection, sourceIndexPath, targetIndexPath) in
                        print("source: \(sourceIndexPath.section): \(sourceIndexPath.row)")
                        print("target: \(targetIndexPath.section): \(targetIndexPath.row)")

                    })
                    .add(to: view)
                    .reload()

```

### 15.UISearchBar --- Example

```
        //支持所有delegate回调
        searchBar
            .placeholder("点击我输入")
            .tintColor(UIColor.orange)
            .addSearchBarShouldBeginEditingBlock { (bar) -> (Bool) in
                return true
            }
            .addSearchBarTextDidBeginEditingBlock({ (bar) in
                bar.setShowsCancelButton(true, animated: true)
            })
            .addSearchBarTextShouldChangeTextInRangeReplacementTextBlock { (bar, text) -> (Bool) in
                print(text)
                return true
            }
            .addSearchBarTextDidEndEditingBlock { (bar) in
                bar.setShowsCancelButton(false, animated: true)
            }
```

### 16.Notification --- Example

```
//接受通知 。无需再deinit中释放
        addNotifiObserver(name: "a") { (notifi) in
            print("NotificationVC接收到: \(notifi.userInfo.debugDescription)")
        }
```

```
        //发送通知
        self?.postNotification(name: "a", object: nil, userInfo: ["name": "lisi"])

```


## 17.UIViewController+NavigationBarItem
* 用途： 一行代码给导航栏添加barItem
<br/>

1.添加带文字的右边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-b280fa9fa4cc2b27.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
setRightButtonItem(title: "关闭") { (btn) in
//点击事件回调
        }
```
2.添加带图片的右边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-e36acc101d6fcd8e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />
```
     setRightButtonItem(image: UIImage(named: "icon_follow")) { (btn) in
                //点击事件回调
            }
```
    
3.添加自定义图片的右边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-e36acc101d6fcd8e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 12, width: 20, height: 20)
        imageView.image = UIImage(named: "icon_follow")
        setRightButtonItem(customView: imageView) { (view, tap) in
            //点击事件回调
        }
```

 4.添加多个标题的右边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-e66a00e5803cb245.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
        setRightButtonItem(titles: ["关闭", "上传", "取消"]) { (btn) in
            //点击事件回调
        }
```

 5.添加多个图片的右边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-c4084f89ba792794.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
        let items = [UIImage(named: "icon_follow"),UIImage(named: "icon_follow")]
        setRightButtonItem(images: items) { (btn) in
            //点击事件回调
        }
```
    
6.添加带标题的左边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-9b9071a9803b471f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
       setLeftButtonItem(title: "返回") { (btn) in
            //点击事件回调
        }
```


7.添加带图片的左边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-d31b067e6bf3547e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
       setLeftButtonItem(image: UIImage(named: "icon_follow")) { (btn) in
            //点击事件回调
        }   
```
    
 8.添加带图片数组的左边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-08d7f1691e959c4a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
        setLeftButtonItem(images: [UIImage(named: "icon_follow"),UIImage(named: "icon_follow")]) { (btn) in
            //点击事件回调
        }
```
    
 9.添加带标题数组的左边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-8296155c3ff54a90.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
       setLeftButtonItem(titles: ["关闭", "上传", "取消"]) { (btn) in
            //点击事件回调
        }
```
    

 10.添加自定义视图的左边按钮

<img src="https://upload-images.jianshu.io/upload_images/2026287-d31b067e6bf3547e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=200 height=100 />

```
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 12, width: 20, height: 20)
        imageView.image = UIImage(named: "icon_follow")
        setLeftButtonItem(customView: imageView) { (view, tap) in
            //点击事件回调
        }
```

 11.新增渐变导航栏的透明度
 
 ```
 基本使用说明
 第一步
 override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //此方法必须在willAppear中设置
        navigationController?.navigationBar.isTranslucent = true
        //进来默认显示透明色
        changeNavBackgroundImageWithAlpha(alpha: 0)
    }
    
    //滑动监听
 override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.y
        let alpha = value / 64
        changeNavBackgroundImageWithAlpha(alpha: alpha)
    }
 ```
 方法说明
 
```
 /// 改变导航栏透明度
    ///
    /// - Parameters:
    ///   - alpha: 透明值
    ///   - backgroundColor: 非透明时背景颜色
    ///   - shadowColor: 非透明是shadow阴影颜色
     public func changeNavBackgroundImageWithAlpha(alpha: CGFloat,   backgroundColor: UIColor = .white, shadowColor: UIColor =  #colorLiteral(red: 0.9311618209, green: 0.9279686809, blue: 0.9307579994, alpha: 1))
```
