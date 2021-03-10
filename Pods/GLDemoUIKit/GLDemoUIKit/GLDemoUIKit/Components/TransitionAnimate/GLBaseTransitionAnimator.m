//
//  GLBaseTransitionAnimator.m
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/10.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import "GLBaseTransitionAnimator.h"

@implementation GLBaseTransitionAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
//    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    [self animateTransition:transitionContext fromVC:fromViewController toVC:toViewController fromView:fromView toView:toView isPresenting:isPresenting inContainerView:containerView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView isPresenting:(BOOL)isPresenting inContainerView:(UIView *)containerView {
    NSLog(@"Please finish this function");
}

@end
