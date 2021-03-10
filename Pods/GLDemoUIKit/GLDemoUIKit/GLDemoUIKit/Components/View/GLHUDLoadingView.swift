//
//  GLHUDLoadingView.swift
//  SmartHeater
//
//  Created by GrayLand on 2020/4/7.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit
import PKHUD

open class GLHUDLoadingView: PKHUDSquareBaseView, PKHUDAnimating {

    public init(description: String?) {
        super.init(image: PKHUDAssets.progressActivityImage, title: nil, subtitle: description)
        self.subtitleLabel.textColor = UIColor.black
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func startAnimation() {
        imageView.layer.add(PKHUDAnimation.discreteRotation, forKey: "progressAnimation")
    }

    public func stopAnimation() {
    }
}
