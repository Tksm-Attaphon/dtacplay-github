//
//  AppDelegate.h
//  dtacplay
//
//  Created by attaphon eamsahard on 9/22/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TAGManager;
@class TAGContainer;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property () BOOL restrictRotation;

@property (nonatomic, strong) TAGManager *tagManager;
@property (nonatomic, strong) TAGContainer *container;

@end

