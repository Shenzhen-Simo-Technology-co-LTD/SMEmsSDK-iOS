//
//  GLTransitionDelegate.m
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/10.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import "GLTransitionDelegate.h"
#import "GLDefaultTransitionAnimator.h"
#import "GLPopupTransitionAnimator.h"
#import "GLLeftTransitionAnimator.h"
#import "GLRightTransitionAnimator.h"
#import "GLTopTransitionAnimator.h"
#import "GLCrossDissolveTransitionAnimator.h"

@interface GLTransitionDelegate ()
@property (nonatomic, weak) UIViewController *presentedVC;
@property(nonatomic, strong) GLLeftTransitionAnimator *leftAnimator;
@property(nonatomic, strong) GLRightTransitionAnimator *rightAnimator;
@property(nonatomic, strong) GLTopTransitionAnimator *topAnimator;
@property(nonatomic, strong) GLPopupTransitionAnimator *popupAnimator;
@property(nonatomic, strong) GLCrossDissolveTransitionAnimator *crossDissolveAnimator;
@property(nonatomic, strong) GLDefaultTransitionAnimator *defaultAnimator;
@end

@implementation GLTransitionDelegate

- (instancetype)initWithPresentedVC:(UIViewController *)presentedVC
                     animationStyle:(GLTransitionAnimationStyle)animationStyle {
    if (self = [super init]) {
        self.presentedVC = presentedVC;
        _animationStyle = animationStyle;
    }
    return self;
}

- (instancetype)initWithPresentedVC:(UIViewController *)presentedVC
                     customAnimator:(id<UIViewControllerAnimatedTransitioning>)customAnimator {
    if (self = [super init]) {
        self.presentedVC = presentedVC;
        _animationStyle = GLTransitionAnimationStyleCustom;
        _customAnimator = customAnimator;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    switch (_animationStyle) {
        case GLTransitionAnimationStyleDefault: return self.defaultAnimator;
        case GLTransitionAnimationStylePopup: return self.popupAnimator;
        case GLTransitionAnimationStyleLeft: return self.leftAnimator;
        case GLTransitionAnimationStyleRight: return self.rightAnimator;
        case GLTransitionAnimationStyleTop: return self.topAnimator;
        case GLTransitionAnimationStyleCrossDissolve: return self.crossDissolveAnimator;
        case GLTransitionAnimationStyleCustom: return self.customAnimator;
        default:
            break;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    switch (_animationStyle) {
        case GLTransitionAnimationStyleDefault: return self.defaultAnimator;
        case GLTransitionAnimationStylePopup: return self.popupAnimator;
        case GLTransitionAnimationStyleLeft: return self.leftAnimator;
        case GLTransitionAnimationStyleRight: return self.rightAnimator;
        case GLTransitionAnimationStyleTop: return self.topAnimator;
        case GLTransitionAnimationStyleCrossDissolve: return self.crossDissolveAnimator;
        case GLTransitionAnimationStyleCustom: return self.customAnimator;
        default:
            break;
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    UIPresentationController *presentationController = [[UIPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
    self.presentedVC = presented;
    return presentationController;
}

#pragma mark - getter

- (GLLeftTransitionAnimator *)leftAnimator {
    if (!_leftAnimator) {
        _leftAnimator = [GLLeftTransitionAnimator new];
    }
    return _leftAnimator;
}

- (GLRightTransitionAnimator *)rightAnimator {
    if (!_rightAnimator) {
        _rightAnimator = [GLRightTransitionAnimator new];
    }
    return _rightAnimator;
}

- (GLTopTransitionAnimator *)topAnimator {
    if (!_topAnimator) {
        _topAnimator = [GLTopTransitionAnimator new];
    }
    return _topAnimator;
}

- (GLPopupTransitionAnimator *)popupAnimator {
    if (!_popupAnimator) {
        _popupAnimator = [GLPopupTransitionAnimator new];
    }
    return _popupAnimator;
}

- (GLCrossDissolveTransitionAnimator *)crossDissolveAnimator {
    if (!_crossDissolveAnimator) {
        _crossDissolveAnimator = [GLCrossDissolveTransitionAnimator new];
    }
    return _crossDissolveAnimator;
}

- (GLDefaultTransitionAnimator *)defaultAnimator {
    if (!_defaultAnimator) {
        _defaultAnimator = [GLDefaultTransitionAnimator new];
    }
    return _defaultAnimator;
}

@end
