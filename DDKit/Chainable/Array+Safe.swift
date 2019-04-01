//
//  Array+Safe.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/18.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation

// MARK: - 使用 arr[10, true]
extension Array {
    public subscript(index: Int, safe: Bool ) -> Element? {
        if safe {
            if self.count > index {
                return self[index]
            } else {
                return nil
            }
        }
        return self[index]
    }
}
