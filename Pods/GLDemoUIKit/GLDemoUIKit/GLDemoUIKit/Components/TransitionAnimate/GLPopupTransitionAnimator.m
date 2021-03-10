//
//  GLPopupTransitionAnimator.m
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/10.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import "GLPopupTransitionAnimator.h"

@implementation GLPopupTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super animateTransition:transitionContext];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    if (isPresenting) {
        toView.frame = CGRectMake(0,0, CGRectGetWidth(containerView.bounds), CGRectGetHeight(containerView.bounds));
        toView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        toView.alpha = 0;
        [containerView addSubview:toView];
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.transform = CGAffineTransformIdentity;
            toView.alpha = 1;
        } else {
            fromView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            fromView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if (!isPresenting) {
            fromView.transform = CGAffineTransformIdentity;
            fromView.alpha = 1;
        }
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
