//
//  ShowImageViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ShowImageViewController.h"
#import "Constant.h"
#import "REFrostedViewController.h"
#import "UIColor+Extensions.h"
#import "GallaryObject.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "UIApplication+AppDimensions.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "Manager.h"
@interface ShowImageViewController ()
{
    UIView *description;
    BOOL isShowDescription;
    UILabel *title;
    BOOL isLandscape;
    
    float navHeight;
    float statusHeight;
    CGRect imageframe;
    UIButton *closeBtn;
    
}
@end

@implementation ShowImageViewController
-(void)backAction:(id)back{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /// set navigation bar image
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    // [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": @"Lifestyle - Travel"}];
    if(self.cate == SHOPPING){
         [dataLayer push:@{@"event": @"openScreen", @"screenName": [NSString stringWithFormat:@"Shopping - Gallery - %@",self.titlePage]}];
    }else if(self.cate == FREEZONE){
         [dataLayer push:@{@"event": @"openScreen", @"screenName": [NSString stringWithFormat:@"FreeZone - Application - Gallery - %@",self.titlePage]}];
        }
    else{

    switch (self.subCate) {
        case LIFESTYLE_TRAVEL:
            [dataLayer push:@{@"event": @"openScreen", @"screenName": [NSString stringWithFormat:@"LifeStyle - Travel - Gallery - %@",self.titlePage]}];
            break;
        case LIFESTYLE_RESTAURANT:
            [dataLayer push:@{@"event": @"openScreen", @"screenName": [NSString stringWithFormat:@"LifeStyle - Restaurant - Gallery - %@",self.titlePage]}];
            break;
            
        default:
            [dataLayer push:@{@"event": @"openScreen", @"screenName": [NSString stringWithFormat:@"LifeStyle - Gallery - %@",self.titlePage]}];
            break;
    }
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = self.titlePage;
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImage* image3 = [UIImage imageNamed:@"dtacplay_close_button"];
    CGRect frameimg = CGRectMake(0, 0, 25, 25);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frameimg];
    
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(backAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=menuButton;
    
    ///
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:_themeColor,
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    isShowDescription = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
    if(_allImageArray == nil){
        self.allImageArray  = [[NSMutableArray alloc]init];
        
        NSArray *keys = [NSArray arrayWithObjects:@"image", @"caption", nil];
        NSArray *objects = [NSArray arrayWithObjects:@"default_image_02_L.jpg", @"", nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        GallaryObject* gallaryTemp =  [[GallaryObject alloc]initWithDictionary:dictionary];
        
        [self.allImageArray addObject:gallaryTemp];
        [self.allImageArray addObject:gallaryTemp];
        [self.allImageArray addObject:gallaryTemp];
        [self.allImageArray addObject:gallaryTemp];
        
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    navHeight  = self.navigationController.navigationBar.frame.size.height;
    statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if(!_carousel)
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.view.frame.size.width, self.view.frame.size.height-60)];
    
    imageframe = _carousel.frame;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    _carousel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    
    //_carousel.
    [self.view addSubview:_carousel];
    [_carousel setHidden:YES];
    
    
    title=[[UILabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-45, self.view.frame.size.width, 45)];
    title.lineBreakMode = NSLineBreakByWordWrapping;
    title.numberOfLines = 0;
    [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 14 : 12]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
    
    if([_allImageArray[_index] isKindOfClass:[GallaryObject class]]){
        GallaryObject* gallaryTemp = _allImageArray[_index];
        
        title.text = gallaryTemp.caption;
    }
    else{
        [title setBackgroundColor:[UIColor clearColor]];
    }
    [_carousel setCurrentItemIndex:_index];
    [self.view addSubview:title];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self
                 action:@selector(backAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"dtacplay_close_button"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(self.view.frame.size.width-40,10, 30.0, 30.0);
    [self.view addSubview:closeBtn];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_carousel setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_carousel setHidden:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
- (BOOL)shouldAutorotate {
    
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        // code for landscape orientation
        
        NSLog(@"%f,%f LANDSCAPE",[UIApplication currentSize].width,[UIApplication currentSize].height);
        isLandscape = YES;
        [_carousel removeFromSuperview];
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0f, 0.0f,[UIApplication currentSize].height+20, [UIApplication currentSize].width)];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeLinear;
        _carousel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        
        //_carousel.
        [self.view addSubview:_carousel];
        
    }
    else{
        isLandscape = NO;
        
        [_carousel removeFromSuperview];
        _carousel = [[iCarousel alloc] initWithFrame:imageframe];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeLinear;
        _carousel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        
        //_carousel.
        [self.view addSubview:_carousel];
        [self.view bringSubviewToFront:title];
        [self.view bringSubviewToFront:closeBtn];
    }
    [_carousel setCurrentItemIndex:_index];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft; // or Right of course
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.allImageArray.count;
}
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return 4;
}
- (void)scrollToItemAtIndex:(NSInteger)index
                   duration:(NSTimeInterval)scrollDuration{
    
    
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    _index = carousel.currentItemIndex;
    if(![self.allImageArray[_index] isKindOfClass:[NSString class]]){
        GallaryObject* gallaryTemp = _allImageArray[carousel.currentItemIndex];
        
        title.text = gallaryTemp.caption;
    }
}
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    
    
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    UIImageView *views = [[UIImageView alloc] initWithFrame:imageframe];
    
    GallaryObject* gallaryTemp = _allImageArray[index];
    
    if(isLandscape==YES){
        views = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIApplication currentSize].height+20, [UIApplication currentSize].width)];
    }
    
    if([self.allImageArray[index] isKindOfClass:[NSString class]]){
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.allImageArray[index]]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    
                                    [views setImage:image];
                                }
                                else{
                                    [views setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
                                }
                            }];
        
    }
    else{
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:gallaryTemp.image]
                           
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    
                                    [views setImage:image];
                                }
                                else{
                                    [views setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
                                }
                            }];
        
        
    }
    
    
    [views setContentMode:UIViewContentModeScaleAspectFit];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    
    
    
    return views;
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
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    //    [UIView transitionWithView:self.view
    //                      duration:0.25
    //                       options:UIViewAnimationOptionCurveLinear
    //                    animations:^{
    //                        if(isShowDescription == NO){
    //                            GallaryObject* gallaryTemp = _allImageArray[index];
    //                            title.text = gallaryTemp.caption;
    //                            [description setFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    //                            isShowDescription = YES;
    //                            [description setAlpha:1];
    //                        }
    //                        else{
    //                            GallaryObject* gallaryTemp = _allImageArray[index];
    //                            title.text = gallaryTemp.caption;
    //                            [description setFrame:CGRectMake(0, description.frame.size.height+description.frame.origin.y, self.view.frame.size.width, 40)];
    //                            isShowDescription = NO;
    //                             [description setAlpha:0.5];
    //                        }
    //                    }
    //                    completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
