//
//  BannerSlideCollectionViewCell.h
//  layout
//
//  Created by attaphon on 9/26/2558 BE.
//  Copyright (c) 2558 attaphon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "ContentPreview.h"
@class DtacHomeViewController;
@interface BannerSlideCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate>
{
        UIPageControl *pageControl;
        NSArray *item;
    UIButton *next;
     UIButton *back;
}
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) DtacHomeViewController *parentView;
@property (nonatomic, strong) NSMutableArray *promotionArray;

@end
