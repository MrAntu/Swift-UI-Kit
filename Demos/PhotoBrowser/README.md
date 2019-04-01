
[更多方法使用参考demo](https://github.com/weiweilidd01/DDPhotoBrowser)

#### 1.使用方式, pod DDKit

```
        var photos = [DDPhoto]()
        
        //九宫格图片显示，请自行结合赋值，赋值参照如下
        let photo1 = DDPhoto()
        //url必传，若为本地图片，请直接复制image
        photo1.url = URL(string: "https://i2.hoopchina.com.cn/hupuapp/bbs/180015943752119/thread_180015943752119_20181123173449_s_5063176_w_357_h_345_28251.gif")
        //必传，预览时才能获取当前imageView的frame，实现展示和消失动画操作
        photo1.sourceImageView = imageViewA
        
        let photo2 = DDPhoto()
        photo2.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056077048&di=e67f672075c673e6ffaa0625564133e7&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201406%2F12%2F20140612211118_YYXAC.jpeg")
        photo2.sourceImageView = imageViewB
        
        let photo3 = DDPhoto()
        photo3.url = URL(string: "http://img1.mydrivers.com/img/20171008/s_da7893ed38074cbc994e0ff3d85adeb5.jpg")
        photo3.sourceImageView = imageViewC
        
        let photo4 = DDPhoto()
        photo4.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056728983&di=0377ea3d0ef5acdefe8863c1657a67f4&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01e90159a5094ba801211d25bec351.jpg")
        photo4.sourceImageView = imageViewD
        
        photos.append(photo1)
        photos.append(photo2)
        photos.append(photo3)
        photos.append(photo4)
    
        //photos数组，
        //currentIndex  当前选择图片的索引值
        browser = DDPhotoBrower.photoBrowser(Photos: photos, currentIndex: 0)
        browser?.delegate = self
        browser?.show()
```

#### 2.DDPhoto Model 

```
   /** 图片地址 */                                 是否必传
    var url: URL?                                   是
    /** 来源imageView */
    var sourceImageView: UIImageView?               是
    
    /** 来源frame */
    var sourceFrame: CGRect? //                     否
    /** 图片(静态)若为本地图片，请直接赋值 */
    var image: UIImage?                             否
    /** 占位图 */
    var placeholderImage: UIImage?                  否
```

####  4.代理方法

```
extension ViewController: DDPhotoBrowerDelegate {
    func photoBrowser(controller: DDPhotoBrowerController?, willDismiss index: Int?) {

    }
    
    func photoBrowser(controller: DDPhotoBrowerController?, didChanged index: Int?) {
      
    }
    
    func photoBrowser(controller: DDPhotoBrowerController?, longPress index: Int?) {
        let photo = browser?.photos?[index ?? 0]
        
        guard let image = photo?.image else {
            return
        }
        
        //存储图片
        UIImageWriteToSavedPhotosAlbum(image, self,#selector(saved(image:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func saved(image: UIImage, didFinishSavingWithError erro: NSError?, contextInfo: AnyObject) {
        if erro != nil {
            print("错误")
            return
        }
        print("ok")
    }
    
  }
```

####  5.若支持长按保存图片，请实现上述长按回调协议

```
    请在info.plist文件中添加权限  Privacy - Photo Library Additions Usage Description
```

#### 6.详细使用，请参照demo
