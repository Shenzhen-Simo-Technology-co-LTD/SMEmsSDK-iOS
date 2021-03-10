//
//  GLPanGestureRecognizer.swift
//  GLDemoUIKit
//
//  Created by GrayLand on 2020/6/12.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit


public enum GLPanDirection: Int {
    case Left
    case Up
    case Right
    case Down
}

public class GLPanGestureRecognizer: UIPanGestureRecognizer {
    public var direction: GLPanDirection = GLPanDirection.Left
    
    var isDragging = false
    
    // MARK: - Life Cycle
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .failed {
            return
        }
        let velocity = self.velocity(in: view)
        if !isDragging {
            let velocities = [GLPanDirection.Left: -velocity.x,
                              GLPanDirection.Up: -velocity.y,
                              GLPanDirection.Right: velocity.x,
                              GLPanDirection.Down: velocity.y]
            let keysSorted = velocities.sorted { (arg0, arg1) -> Bool in
                let (_, value2) = arg1
                let (_, value1) = arg0
                return value1 < value2
            }
            let lastObj = keysSorted.last
            if lastObj?.key != self.direction {
                self.state = UIGestureRecognizer.State.failed
            }
            
            isDragging = true
        }
    }
    
    public override func reset() {
        super.reset()
        isDragging = false
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    // MARK: - OnEvent
    
    // MARK: - Custom Delegate
    
    // MARK: - Setter
    
    // MARK: - Getter
}
