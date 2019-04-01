
//
//  MediatorParams.swift
//  DDMediatorDemo
//
//  Created by USER on 2018/12/5.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

//必须为class， 在selector中传递，不接受struct
public class MediatorParams: NSObject {
    
    /// 接收的参数
    public var params: MediatorParamDic?
    
    /// 回调block
    public var callBack: MediatorCallBack?
}
