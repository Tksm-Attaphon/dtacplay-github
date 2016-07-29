//
//  BannerView.m
//  dtacplay
//
//  Created by attaphon eamsahard on 7/20/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "BannerView.h"
#import "MyFlowLayout.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "ArticleBox.h"
#import "PromotionDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "ContentPreviewPromotion.h"
#import "MBProgressHUD.h"
#import "DtacPlayPromotionCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"
#import "Manager.h"
#import "Banner.h"
#import "BannerImage.h"

@implementation BannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}
- (void)baseInit {
    
    _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height )];
    
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    _carousel.backgroundColor = [UIColor clearColor];
    //_carousel.
    [self addSubview:_carousel];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (self.frame.size.height-20), self.frame.size.width, 20.0f)];
 
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
    
}
#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    _pageControl.numberOfPages = _bannerArray.count;
    return _bannerArray.count;
    
}
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return 4;
}
- (void)scrollToItemAtIndex:(NSInteger)index
                   duration:(NSTimeInterval)scrollDuration{
    
    
}
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    //NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
    _pageControl.currentPage = self.carousel.currentItemIndex;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *viewsImage = [[UIImageView alloc] initWithFrame:_carousel.frame];
    Banner *temp  = _bannerArray[index];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:temp.images.image_r1]
     
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                viewsImage.image = image;
                            }
                            
                            
                            
                        }];
    
    [viewsImage setContentMode:UIViewContentModeScaleToFill];
    return viewsImage;
    
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return NO;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
     Banner *temp  = _bannerArray[index];
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];

}
//////////

@end
