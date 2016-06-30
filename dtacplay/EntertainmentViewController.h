//
//  FreeStyleViewController.h
//  dtacplay
//
//  Created by attaphon on 10/25/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SwipeView.h"
#import "iCarousel.h"
#import "Constant.h"
#import "ArticleBox.h"
#import "NewsDetailViewController.h"
#import "DtacPlayViewController.h"

@interface EntertainmentViewController :  DtacPlayViewController<SwipeViewDelegate, SwipeViewDataSource,iCarouselDataSource,iCarouselDelegate>
{
    UIPageControl *pageControl;
}
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NewsDetailViewController *articleView;
@property(nonatomic) CategorryType pageType;
@property(nonatomic) SubCategorry subeType;

@property(nonatomic,strong) NSArray *nameMenu;
@property (strong, nonatomic) iCarousel *carousel;
@property (nonatomic, strong) SwipeView *swipeView;

@property (nonatomic, strong) SwipeView *swipeViewHoro;

@property (nonatomic,assign) int indexPage;
@property (nonatomic) UIColor* themeColor;
@end
