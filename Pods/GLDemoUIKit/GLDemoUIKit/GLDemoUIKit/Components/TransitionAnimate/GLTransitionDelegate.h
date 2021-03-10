//
//  GLTransitionDelegate.h
//  GLUIKit_Example
//
//  Created by GrayLand on 2020/3/10.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLBaseTransitionAnimator.h"

typedef NS_ENUM(NSInteger, GLTransitionAnimationStyle) {
    GLTransitionAnimationStyleDefault = 0,         ///<无动画
    GLTransitionAnimationStyleTop,                 ///<顶部弹出
    GLTransitionAnimationStyleLeft,                ///<左边弹出
    GLTransitionAnimationStyleRight,               ///<右边弹出
    GLTransitionAnimationStylePopup,               ///<中间弹出
    GLTransitionAnimationStyleCrossDissolve,       ///<淡入淡出
    GLTransitionAnimationStyleCustom
};

NS_ASSUME_NONNULL_BEGIN

@interface GLTransitionDelegate : NSObject
<UIViewControllerTransitioningDelegate>

@property(nonatomic, assign, readonly) GLTransitionAnimationStyle animationStyle;
@property(nonatomic, strong) id<UIViewControllerAnimatedTransitioning> customAnimator;

- (instancetype)initWithPresentedVC:(UIViewController *)presentedVC
                     animationStyle:(GLTransitionAnimationStyle)animationStyle;

- (instancetype)initWithPresentedVC:(UIViewController *)presentedVC
                     customAnimator:(id<UIViewControllerAnimatedTransitioning>)customAnimator;
@end

NS_ASSUME_NONNULL_END
