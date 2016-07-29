//
//  BannerSlideCollectionViewCell.m
//  layout
//
//  Created by attaphon on 9/26/2558 BE.
//  Copyright (c) 2558 attaphon. All rights reserved.
//

#import "BannerSlideCollectionViewCell.h"
#import "UIColor+Extensions.h"
#import "Constant.h"
#import "PromotionDetailViewController.h"
#import "DtacHomeViewController.h"
#import "ContentPreviewPromotion.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Manager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
@implementation BannerSlideCollectionViewCell

- (void)awakeFromNib {
    
    if(!_carousel)
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bannerView.frame.size.width, self.bannerView.frame.size.height)];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    _carousel.backgroundColor = [UIColor clearColor];
    //_carousel.
    [_bannerView addSubview:_carousel];
    
    
    
    
    // Page Control
    if(!pageControl)
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (self.bannerView.frame.size.height-10), self.bannerView.frame.size.width, 20.0f)];
    pageControl.numberOfPages = _promotionArray.count >= 5 ? 5 : _promotionArray.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    pageControl.userInteractionEnabled = NO;
    [self.bannerView addSubview:pageControl];
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
    
//    next = [UIButton buttonWithType:UIButtonTypeCustom];
//    [next addTarget:self
//                   action:@selector(nextItem:)
//         forControlEvents:UIControlEventTouchUpInside];
//    
//    //[themeBtn setTitleColor:[UIColor colorWithHexString:@"b17500"] forState:UIControlStateNormal ];
//    
//    next.frame = CGRectMake(self.frame.size.width-30, self.frame.size.height/2-10, 20, 20);
//    [next setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
//    
//    [self.viewForBaselineLayout addSubview:next];
//    
//    back = [UIButton buttonWithType:UIButtonTypeCustom];
//    [back addTarget:self
//             action:@selector(backItem:)
//   forControlEvents:UIControlEventTouchUpInside];
//    
//    //[themeBtn setTitleColor:[UIColor colorWithHexString:@"b17500"] forState:UIControlStateNormal ];
//    
//    back.frame = CGRectMake(10, self.frame.size.height/2-10, 20, 20);
//    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    
//    [self.viewForBaselineLayout addSubview:back];
}

-(void)nextItem:(id)sender{
     [_carousel scrollToItemAtIndex:self.carousel.currentItemIndex+1 animated:YES];
}
-(void)backItem:(id)sender{
     [_carousel scrollToItemAtIndex:self.carousel.currentItemIndex-1 animated:YES];
}
-(void)runLoop:(NSTimer*)NSTimer{
    
    if(_carousel)
        [_carousel scrollToItemAtIndex:self.carousel.currentItemIndex+1 animated:YES];
    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _carousel.frame =CGRectMake(0.0f, 0.0f, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
    pageControl.frame = CGRectMake(0.0f, (self.bannerView.frame.size.height-20), self.bannerView.frame.size.width, 20.0f);
     next.frame = CGRectMake(self.frame.size.width-30, self.frame.size.height/2-10, 20, 20);
    back.frame = CGRectMake(10, self.frame.size.height/2-10, 20, 20);
}
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    NSLog(@"xx");
}
#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
   pageControl.numberOfPages = _promotionArray.count >= 5 ? 5 : _promotionArray.count;
    return _promotionArray.count >= 5 ? 5 : _promotionArray.count;
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
    pageControl.currentPage = self.carousel.currentItemIndex;
}
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    PromotionDetailViewController* detail= [[PromotionDetailViewController alloc]init];
    ContentPreviewPromotion *prom = _promotionArray[index];
    
    if(prom.link){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:prom.link]];
        NSString *jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"saveOpenLink\", \"params\":{\"refId\":%@, \"refType\":1, \"link\":\"%@\"}}",prom.contentID,prom.link];
        
        
        NSString *valueHeader;
        
        valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
        
        NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
        
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
            }
            
            //  ...
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [op start];

        
    }
    else{
    detail.contentID = prom.contentID;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.parentView.navigationItem setBackBarButtonItem:newBackButton];
    self.parentView.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    [self.parentView.navigationController pushViewController:detail animated:YES];
    }
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *views = [[UIImageView alloc] initWithFrame:self.frame];
    ContentPreviewPromotion *content = _promotionArray[index];
    [views setContentMode:UIViewContentModeScaleAspectFit];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:content.images.imageW1]
         
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                views.image = image;
                            }
                        }];
    }
    else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:content.images.imageW1]
                        
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    views.image = image;
                                }
                            }];
    }
    return views;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

@end
