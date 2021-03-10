//
//  GLPopGestureRecognizerDelegate.swift
//  GLDemoUIKit
//
//  Created by GrayLand on 2020/6/12.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

public class GLPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    public weak var navigationController: UINavigationController?
    public var enablePopGesture = false
    public var interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat /// default is 1/3 of screen width
    
    // MARK: - Life Cycle
    public override init() {
        interactivePopMaxAllowedInitialDistanceToLeftEdge = PORTRAIT_WIDTH/3.0
        super.init()
    }
    
    public func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
        // Ignore when no view controller is pushed into the navigation stack.
        if (self.navigationController?.viewControllers.count ?? 0 <= 1) {
            return false
        }
        
        // Ignore when the active view controller doesn't allow interactive pop.
        if (!self.enablePopGesture) {
            return false
        }
        if !gesture.isKind(of: UIPanGestureRecognizer.self) {
            return false
        }
        let gestureRecognizer = gesture as! UIPanGestureRecognizer
        // Ignore when the beginning location is beyond max allowed initial distance to left edge.
        let beginningLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let maxAllowedInitialDistance = self.interactivePopMaxAllowedInitialDistanceToLeftEdge
        if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
            return false
        }
        
        // Ignore pan gesture when the navigation controller is currently in transition.
        let value = navigationController?.value(forKey: "_isTransitioning") as! NSNumber
        if (value.boolValue) {
            return false
        }
        
        // Prevent calling the handler when the gesture begins in an opposite direction.
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.leftToRight
        let multiplier = CGFloat(isLeftToRight ? 1.0 : -1.0)
        if ((translation.x * multiplier) <= 0) {
            return false
        }
        
        return true
    }
    // MARK: - Public
    
    // MARK: - Private
    
    // MARK: - OnEvent
    
    // MARK: - Custom Delegate
    
    // MARK: - Setter
    
    // MARK: - Getter
}
    
    
    
