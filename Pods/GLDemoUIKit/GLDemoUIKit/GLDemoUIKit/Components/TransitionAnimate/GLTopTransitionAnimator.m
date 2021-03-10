//
//  GLTopTransitionAnimator.m
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/16.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import "GLTopTransitionAnimator.h"

@implementation GLTopTransitionAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super animateTransition:transitionContext];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    if (isPresenting) {
        toView.frame = CGRectMake(0, -CGRectGetHeight(containerView.bounds), containerView.bounds.size.width, containerView.bounds.size.height);
        [containerView addSubview:toView];
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.frame = toFrame;
        } else {
            fromView.frame = CGRectMake(0, -CGRectGetHeight(containerView.bounds), CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
