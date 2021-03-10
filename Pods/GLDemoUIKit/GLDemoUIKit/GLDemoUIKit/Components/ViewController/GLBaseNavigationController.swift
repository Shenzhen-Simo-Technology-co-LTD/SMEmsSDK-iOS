//
//  GLBaseNavigationController.swift
//  SmartHeater
//
//  Created by GrayLand on 2020/3/30.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

open class GLBaseNavigationController: UINavigationController {
    
    // MARK: - Lift Cycle
    public init(_ rootViewController: UIViewController?) {
        super.init(navigationBarClass: GLNavigationBar.self, toolbarClass: nil)
        viewControllers = [rootViewController ?? UIViewController.init()]
        initSetting()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initSetting()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    private func initSetting() {
        interactivePopGestureRecognizer?.isEnabled = false
        enableRightSwipeToPop = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
    }
    
    // MARK: - Override
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let controllers = willPopToViewController(viewController)
        if controllers.count == 0 {
            debugPrint("Can't pop to \(viewController.className()), dismiss it")
            dismiss(animated: animated, completion: nil)
            return nil
        }
        
        for vc in viewControllers {
            if vc.responds(to: #selector(viewWillDisappear(_:))) {
                vc.viewWillDisappear(animated)
            }
        }
        
        let rootVC = self.viewControllers.first
        if rootVC == viewController {
            rootVC?.hidesBottomBarWhenPushed = false
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return popToViewController(viewControllers.first!, animated: animated)
    }

    open override func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count <= 1 {
            return nil
        }
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let targetController = viewControllers[viewControllers.count - 2]
        
        return popToViewController(targetController, animated: animated)?.last
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - StatusBarStyle
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    // MARK: - Public
    
    // MARK: - Private
    func setupNavigation() {
        if (titleTextAttributes != nil) {
            self.navigationBar.titleTextAttributes = titleTextAttributes
        }
//        self.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.black), for: UIBarMetrics.default)
    }
    
    func willPopToViewController(_ controller :UIViewController) -> [UIViewController] {
        var index = viewControllers.firstIndex(of: controller)
        if index == NSNotFound {
            return []
        }
        
        var controllers: [UIViewController] = []
        index! += 1
        for i in index!..<viewControllers.count {
            controllers.append(viewControllers[i])
        }
        
        return controllers
    }
    // MARK: - OnEvent
    
    // MARK: - Custom Delegate
    
    // MARK: - Setter
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for vc in viewControllers {
            vc.hidesBottomBarWhenPushed = true
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    public var titleTextAttributes: Dictionary<NSAttributedString.Key, Any>? {
        didSet {
            self.navigationBar.titleTextAttributes = self.titleTextAttributes
        }
    }
    
    public var enableRightSwipeToPop = false {
        didSet {
            if enableRightSwipeToPop == oldValue {
                return
            }
            if enableRightSwipeToPop {
                self.glNavigationDelegate.enable = true
                self.delegate = self.glNavigationDelegate
            }else {
                self.interactivePopGestureRecognizer?.isEnabled = false
                self.glNavigationDelegate.enable = false
                self.delegate = nil
            }
        }
    }
    
    // MARK: - Getter
    
    lazy var glNavigationDelegate: GLNavigationDelegate = {
        let d = GLNavigationDelegate.init(self)
        return d
    }()
}
