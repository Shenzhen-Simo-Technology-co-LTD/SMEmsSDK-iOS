//
//  UIViewController+GLPresent.h
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/10.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTransitionDelegate.h"



NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GLPresent)

@property(nonatomic, strong, readonly) GLTransitionDelegate *glTransitionDelegate;

- (GLTransitionDelegate *)gl_presentViewController:(UIViewController *)viewControllerToPresent animationStyle:(GLTransitionAnimationStyle)animationStyle completion:(nullable os_block_t)completion;

- (GLTransitionDelegate *)gl_presentViewController:(UIViewController *)viewControllerToPresent customTransitionAnimator:(id<UIViewControllerAnimatedTransitioning>)customAnimator completion:(nullable os_block_t)completion;

@end

NS_ASSUME_NONNULL_END
