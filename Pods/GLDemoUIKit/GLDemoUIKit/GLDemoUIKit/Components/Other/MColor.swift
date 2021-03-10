//
//  MColor.swift
//  SmartHeater
//
//  Created by GrayLand on 2020/3/31.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

open class MColor: NSObject {
    var light: UIColor
    var dark: UIColor
    open var color: UIColor { get {return self._color()}}
    open var cgColor: CGColor { get {return self.color.cgColor}}
    
    public init(_ light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }
    
    // MARK: - Getter
    private func _color() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (t: UITraitCollection) -> UIColor in
                if t.userInterfaceStyle == .light {
                    return self.light
                }else {
                    return self.dark
                }
            }
        } else {
            return self.light
        }
    }
    
}
