//
//  GLNSAnimator.swift
//  GLDemoUIKit
//
//  Created by GrayLand on 2020/6/12.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

let GLNSTransitionCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: 7 << 16)

class GLNSAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    weak var toViewController: UIViewController?
    
    // MARK: - Life Cycle
    
    // MARK: - Public
    
    // MARK: - Private
    
    // MARK: - OnEvent
    
    // MARK: - Custom Delegate
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isInteractive ?? true ? 0.25 : 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        // Parallax effect
        let toVCXTransation = -transitionContext.containerView.bounds.width * 0.3
        toVC.view.transform = CGAffineTransform.init(translationX: toVCXTransation, y: 0.0)
        
        // Add shadow
        fromVC.view.addLeftSideShadowWithFading()
        let preClipsToBounds = fromVC.view.clipsToBounds
        fromVC.view.clipsToBounds = false
        
        // Dimmer effect
        let dimmingView = UIView.init(frame: toVC.view.bounds)
        dimmingView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.1)
        toVC.view.addSubview(dimmingView)
        
        // fix hides bottom bar when pushed not animated properly
        let tbController = toVC.tabBarController
        let navController = toVC.navigationController
        let tabBar = tbController?.tabBar
        
        var shouldAddTabBarToTabBarController = false
        let tbControllerContainsToVC = tbController?.viewControllers?.contains(toVC) ?? false
        let tbControllerContainsNavController = tbController?.viewControllers?.contains((navController!))
        let isToVCFirstInNavController = navController?.viewControllers.first == toVC
        
        if (tabBar != nil &&
            (tbControllerContainsToVC || (tbControllerContainsNavController ?? false && isToVCFirstInNavController))) {
            
            tabBar?.layer.removeAllAnimations()
            let statueBar = STATUS_BAR_REAL_HEIGHT;
            if (toVC.view.frame.size.height < SCREEN_HEIGHT && toVC.view.frame.origin.y == 0 && (statueBar == 20 || statueBar == 44)) {
                var tRC = toVC.view.frame;
                tRC.size.height = SCREEN_HEIGHT;
                toVC.view.frame = tRC;
            }
            
            if let tb = tabBar {
                var tbRect = tb.frame
                tbRect.origin.x = 0;
                tbRect.origin.y = toVC.view.frame.size.height
                tb.frame = tbRect
                toVC.view.addSubview(tb)
            }
            
            shouldAddTabBarToTabBarController = true
        }
        
        // tansition
        
        let curveOption = transitionContext.isInteractive ? UIView.AnimationOptions.curveLinear : GLNSTransitionCurve
        
        //    _defaultNavigationImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay:0,
                       options:[UIView.AnimationOptions.transitionCrossDissolve, curveOption],
                       animations: {
                        
                        toVC.view.transform = CGAffineTransform.identity;
                        fromVC.view.transform = CGAffineTransform.init(translationX: toVC.view.frame.size.width, y: 0)
                        dimmingView.alpha = 0.0
                        
                        if (tabBar != nil &&
                            (tbControllerContainsToVC || (tbControllerContainsNavController ?? false && isToVCFirstInNavController))) {
                            if let tb = tabBar {
                                var tbRect = tb.frame;
                                tbRect.origin.x = 0; //toVC.view.bounds.origin.x;
                                tbRect.origin.y = SCREEN_HEIGHT - tb.frame.size.height;
                                tb.frame = tbRect;
                                
                            }
                        }
        }) { (finished :Bool) in
            
            if (shouldAddTabBarToTabBarController) {
                if let tb                 = tabBar {
                    if let tbc            = tbController {
                        tbc.view.addSubview(tb)
                        var t_tbRect      = tb.frame;
                        t_tbRect.origin.x = tbc.view.bounds.origin.x;
                        t_tbRect.origin.y = tbc.view.bounds.size.height - tb.frame.size.height;
                        tb.frame          = t_tbRect;
                    }
                }
            }
            
            dimmingView.removeFromSuperview()
            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.clipsToBounds = preClipsToBounds;
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        toViewController = toVC;
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            toViewController?.view.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Setter
    
    // MARK: - Getter
}

extension UIView {
    func addLeftSideShadowWithFading() {
        let shadowWidth = 4.0
        let shadowVerticalPadding = -20.0 // negative padding, so the shadow isn't rounded near the top and the bottom
        let shadowHeight = Double(self.frame.height) - Double(2 * shadowVerticalPadding)
        let shadowRect = CGRect(x: -shadowWidth, y: shadowVerticalPadding, width: shadowWidth, height: shadowHeight)
        let shadowPath = UIBezierPath.init(rect: shadowRect)
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowOpacity = 0.2
        
        // fade shadow during transition
        let toValue = 0.0
        let animation = CABasicAnimation.init(keyPath: "shadowOpacity")
        animation.fromValue = self.layer.shadowOpacity
        animation.toValue = toValue
        self.layer.add(animation, forKey: nil)
        self.layer.shadowOpacity = Float(toValue)
    }
}
