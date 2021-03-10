//
//  GLDefaultTransitionAnimator.m
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/16.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import "GLDefaultTransitionAnimator.h"

@interface GLDefaultTransitionAnimator ()

@end

@implementation GLDefaultTransitionAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    if (isPresenting) {
        toView.frame = toFrame;
        [containerView addSubview:toView];
    }
    
    BOOL wasCancelled = [transitionContext transitionWasCancelled];
    [transitionContext completeTransition:!wasCancelled];
}

@end
