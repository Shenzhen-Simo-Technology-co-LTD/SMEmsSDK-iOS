#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GLBaseTransitionAnimator.h"
#import "GLCrossDissolveTransitionAnimator.h"
#import "GLDefaultTransitionAnimator.h"
#import "GLLeftTransitionAnimator.h"
#import "GLPopupTransitionAnimator.h"
#import "GLRightTransitionAnimator.h"
#import "GLTopTransitionAnimator.h"
#import "GLTransitionDelegate.h"
#import "UIViewController+GLPresent.h"
#import "GLDemoUIKit-Bridging-Header.h"
#import "GLDependencyHeader.h"

FOUNDATION_EXPORT double GLDemoUIKitVersionNumber;
FOUNDATION_EXPORT const unsigned char GLDemoUIKitVersionString[];

