//
//  BannerView.h
//  dtacplay
//
//  Created by attaphon eamsahard on 7/20/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"

@interface BannerView : UIView<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *bannerArray;

@end
