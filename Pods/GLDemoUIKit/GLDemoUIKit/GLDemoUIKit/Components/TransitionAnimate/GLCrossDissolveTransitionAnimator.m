//
//  GLCrossDissolveTransitionAnimator.m
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/16.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import "GLCrossDissolveTransitionAnimator.h"

@implementation GLCrossDissolveTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super animateTransition:transitionContext];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView *fromView = fromViewController.view;
//    UIView *toView = toViewController.view;
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    UIColor *toColor;
    if (isPresenting) {
        toColor = toView.backgroundColor;
        toView.frame = toFrame;//CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height);
        toView.backgroundColor = [UIColor clearColor];
        [containerView addSubview:toView];
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    __block UIColor *defaultColor;
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
//            toView.frame = toFrame;
            toView.backgroundColor = toColor;
        } else {
//            fromView.frame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
            defaultColor = fromView.backgroundColor;
            fromView.backgroundColor = UIColor.clearColor;
        }
    } completion:^(BOOL finished) {
        if (!isPresenting) {
            fromView.backgroundColor = defaultColor;
        }
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled) {
            fromView.backgroundColor = defaultColor;
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
