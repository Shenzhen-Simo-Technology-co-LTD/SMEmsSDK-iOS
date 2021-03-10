//
//  PKHUDExtension.swift
//  SmartHeater
//
//  Created by GrayLand on 2020/4/2.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import PKHUD

public extension UIViewController {
    func showMessage(_ message: String) {
        self.showMessage(message, duration: 1.5)
    }
    
    func showMessage(_ message: String, duration: Double) {
        PKHUD.sharedHUD.contentView = PKHUDTextView.init(text: message)
        PKHUD.sharedHUD.show(onView: self.view)
        PKHUD.sharedHUD.hide(afterDelay: duration)
    }
    
    func showWaitting() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView.init(title: nil, subtitle: nil)
        PKHUD.sharedHUD.show(onView: self.view)
    }
    
    func showWaitting(_ description: String?) {
        PKHUD.sharedHUD.contentView = GLHUDLoadingView.init(description: description)
        PKHUD.sharedHUD.gracePeriod = 0.2
        PKHUD.sharedHUD.show(onView: self.view)
    }
    
    func hideHUD() {
        PKHUD.sharedHUD.hide()
    }
    
    func hideHUD(_ delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            PKHUD.sharedHUD.hide()
        }
    }
}

