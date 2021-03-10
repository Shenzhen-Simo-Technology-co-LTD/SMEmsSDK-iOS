//
//  GLUIKitExtension.swift
//  SmartHeater
//
//  Created by GrayLand on 2020/4/3.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import Foundation

public extension Array where Element == Int {
    var hexDisp:String {
        get {
            var s = "Hex:["
            for i in self {
                s = s + String.init(format: "%02X,", i)
            }
            s.removeLast(1)
            return s + "], length: \(self.count)"
        }
    }
}
