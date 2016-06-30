//
//  AppDelegate.m
//  dtacplay
//
//  Created by attaphon eamsahard on 9/22/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "SideBarViewController.h"
#import "NavigationViewController.h"
#import "DtacHomeViewController.h"
#import "ShowImageViewController.h"
#import "Manager.h"
#import "TAGContainer.h"
#import "TAGContainerOpener.h"
#import "TAGManager.h"
#import "EntertainmentDetailViewController.h"
#import "FBSDKCoreKit.h"
#import <Bolts/Bolts.h>
#import "Branch.h"
@interface AppDelegate ()<TAGContainerOpenerNotifier>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[Manager sharedManager] setServer:SERVICE];
     [[Manager sharedManager] setIsFirstTimeAccessID:YES];
    self.tagManager = [TAGManager instance];
    NSURL *url = [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (url != nil) {
        [self.tagManager previewWithUrl:url];
    }
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
    
    [TAGContainerOpener openContainerWithId:@"GTM-PM6HNW"   // Update with your Container ID.
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferFresh
                                    timeout:nil
                                   notifier:self];

    
    [[Manager sharedManager] setBannerHeight:([[UIScreen mainScreen] bounds].size.width*500/750)];
    
    NavigationViewController *navigationController = [[NavigationViewController alloc] initWithRootViewController:[[DtacHomeViewController alloc] init]];
    SideBarViewController *menuController = [[SideBarViewController alloc] init];
    // set the selected icon color
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    // remove the shadow
    [[UITabBar appearance] setShadowImage:nil];
    // เพิ่มเติม
    // Create frosted view controller
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithHexString:SIDE_BAR_COLOR], NSForegroundColorAttributeName,
      [UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM==IPAD ? 21 : 21], NSFontAttributeName,nil]];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.animationDuration = 0.2;
    frostedViewController.limitMenuViewSize = YES;
    frostedViewController.liveBlur = NO;
    frostedViewController.blurTintColor = [UIColor clearColor];
    frostedViewController.blurRadius = 0.0f;
    frostedViewController.blurSaturationDeltaFactor = 0.0f;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    [frostedViewController.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    frostedViewController.menuViewSize = CGSizeMake(280, [[UIScreen mainScreen] bounds].size.height);
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        
    {
       frostedViewController.menuViewSize = CGSizeMake(360, [[UIScreen mainScreen] bounds].size.height);
    }
    // Make it a root controller
    //
    [self.window addSubview: frostedViewController.view];
    self.window.rootViewController = frostedViewController;
    // [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...
            NSLog(@"params: %@", params.description);
        }
    }];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
     [[Branch getInstance] handleDeepLink:url];
    if ([self.tagManager previewWithUrl:url]) {
        return YES;
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)containerAvailable:(TAGContainer *)container {
    // Note that containerAvailable may be called on any thread, so you may need to dispatch back to
    // your main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
    });
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
