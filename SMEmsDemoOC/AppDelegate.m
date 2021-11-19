//
//  AppDelegate.m
//  SMEmsDemoOC
//
//  Created by GrayLand on 2021/5/27.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainViewController *vc = [[MainViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    window.rootViewController = nvc;
    [window makeKeyWindow];
    self.window = window;
    
    
    return YES;
}




@end
