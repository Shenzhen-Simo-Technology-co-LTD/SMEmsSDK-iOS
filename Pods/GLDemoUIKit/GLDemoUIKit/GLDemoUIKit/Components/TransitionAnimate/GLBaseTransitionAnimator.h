//
//  GLBaseTransitionAnimator.h
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/10.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBaseTransitionAnimator : NSObject
<UIViewControllerAnimatedTransitioning>
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView isPresenting:(BOOL)isPresenting inContainerView:(UIView *)containerView;
@end

NS_ASSUME_NONNULL_END
