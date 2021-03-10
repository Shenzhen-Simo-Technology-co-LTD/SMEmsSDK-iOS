//
//  GLNavigationDelegate.swift
//  GLDemoUIKit
//
//  Created by GrayLand on 2020/6/12.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

open class GLNavigationDelegate: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    public var panRecognizer: UIPanGestureRecognizer?
    public var enable: Bool = false {
        didSet {
            self.panRecognizer?.isEnabled = self.enable
            self.popGestureDelegate?.enablePopGesture = self.enable
        }
    }
    
    weak var navigationController: UINavigationController?
    var popGestureDelegate: GLPopGestureRecognizerDelegate?
    var animator: GLNSAnimator?
    var interactionController: UIPercentDrivenInteractiveTransition?
    var duringAnimation = false
    
    public init(_ navigationController: UINavigationController) {
        super.init()
        
        self.enable = true
        self.navigationController = navigationController
        
        setupSwiper()
    }
    // MARK: - Life Cycle
    
    // MARK: - Public
    
    // MARK: - Private
    func setupSwiper() {
        popGestureDelegate = GLPopGestureRecognizerDelegate.init()
        popGestureDelegate?.navigationController = navigationController
        
        panRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.onPan(_:)))
        panRecognizer?.delegate = popGestureDelegate
        navigationController?.view.addGestureRecognizer(panRecognizer!)
        
        animator = GLNSAnimator()
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        if !enable {
            return
        }
        
        if let view = self.navigationController?.view {
            if recognizer.state == .began {
                if navigationController?.viewControllers.count ?? 0 > 1 &&
                !self.duringAnimation {
                    interactionController = UIPercentDrivenInteractiveTransition.init()
                    interactionController?.completionCurve = UIView.AnimationCurve.easeOut
                    
                    navigationController?.popViewController(animated: true)
                }
            }else if recognizer.state == .changed {
                let translation = recognizer.translation(in: view)
                let dX = translation.x > 0 ? translation.x / view.bounds.width : 0
                debugPrint("dx = \(dX)")
                interactionController?.update(dX)
            }else if recognizer.state == .ended {
                if (recognizer.velocity(in: view).x > 0.0) {
                    interactionController?.finish()
                }else{
                    interactionController?.cancel()
                    duringAnimation = false
                }
                interactionController = nil
            }
        }
        
    }
    // MARK: - OnEvent
    
    // MARK: - Custom Delegate
    // MARK: - UIGestureRecognizerDelegate
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return animator
        }
        return nil
    }
    
    // MARK: - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated {
            duringAnimation = true
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        duringAnimation = false
        
        if navigationController.viewControllers.count <= 1 {
            panRecognizer?.isEnabled = false
        }else {
            panRecognizer?.isEnabled = true
        }
    }
    // MARK: - Setter
    
    // MARK: - Getter
}
