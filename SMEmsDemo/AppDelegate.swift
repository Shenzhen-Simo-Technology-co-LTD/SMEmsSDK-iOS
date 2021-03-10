//
//  AppDelegate.swift
//  SMEmsDemo
//
//  Created by GrayLand on 2021/3/4.
//

import UIKit
@_exported import SMEmsSDK
@_exported import GLDemoUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        GL_INJECTION()
        
        /**
         因为iOS读取蓝牙开关不会立即返回正确的状态, 所以需要在 App启动时先读取一下蓝牙开关.
         */
        _ = SMEmsManager.defaultManager.isBLEOn
        
        
        return true
    }

}

