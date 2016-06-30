//
//  UIApplication+AppDimensions.m
//  dtacplay
//
//  Created by attaphon on 11/3/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "UIApplication+AppDimensions.h"

@implementation UIApplication (AppDimensions)
+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}
@end
