//
//  GLNavigationBar.swift
//  GLDemoUIKit
//
//  Created by GrayLand on 2020/6/12.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

class GLNavigationBar: UINavigationBar {

    // MARK: - Life Cycle
    
    // MARK: - Override
    
    // MARK: - Public
    /**
     *  Change blur color
     *
     */
    public func blurWithColor(_ color: UIColor) {
        barTintColor = color
        isTranslucent = true
    }
    
    public func blurWithImage(_ image: UIImage) {
        blurWithColor(UIColor.init(patternImage: image))
    }
    
    // MARK: - Private
    
    // MARK: - OnEvent
    
    // MARK: - Custom Delegate
    
    // MARK: - Setter
    
    // MARK: - Getter

}
