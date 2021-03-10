//
//  UIViewController+GLPresent.m
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/10.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import "UIViewController+GLPresent.h"
#import "GLTransitionDelegate.h"
#import <objc/runtime.h>

static void * const kGLTransitionDelegate = "kGLTransitionDelegate";

@implementation UIViewController (GLPresent)
@dynamic glTransitionDelegate;
- (void)setGlTransitionDelegate:(GLTransitionDelegate * _Nonnull)glTransitionDelegate {
    objc_setAssociatedObject(self, &kGLTransitionDelegate, glTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (GLTransitionDelegate *)glTransitionDelegate {
    return (GLTransitionDelegate *)objc_getAssociatedObject(self, &kGLTransitionDelegate);
}

- (GLTransitionDelegate *)gl_presentViewController:(UIViewController *)viewControllerToPresent animationStyle:(GLTransitionAnimationStyle)animationStyle completion:(nullable os_block_t)completion {
    GLTransitionDelegate *transitionDelegate = [[GLTransitionDelegate alloc] initWithPresentedVC:viewControllerToPresent animationStyle:animationStyle];
    viewControllerToPresent.transitioningDelegate = transitionDelegate;
    self.glTransitionDelegate = transitionDelegate;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
    return transitionDelegate;
}

- (GLTransitionDelegate *)gl_presentViewController:(UIViewController *)viewControllerToPresent customTransitionAnimator:(id<UIViewControllerAnimatedTransitioning>)customAnimator completion:(os_block_t)completion {
    GLTransitionDelegate *transitionDelegate = [[GLTransitionDelegate alloc] initWithPresentedVC:viewControllerToPresent customAnimator:customAnimator];
    viewControllerToPresent.transitioningDelegate = transitionDelegate;
    self.glTransitionDelegate = transitionDelegate;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
    return transitionDelegate;
}

@end
