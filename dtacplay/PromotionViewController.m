//
//  PromotionViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "PromotionViewController.h"
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
@interface PromotionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    UIPageControl *pageControl;
    UIView *contentView;
    UILabel *title;
    
    NSMutableArray *objectArray;
    
    int page;
    UIView *nodataView;
    NSTimer *timer;
    
}
@end

@implementation PromotionViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:self];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": @"Promotion"}];
}
-(void)refreshPage{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentByCateId\",\"params\":{ \"cateId\":7, \"page\":%d,\"limit\":10 }}",page];
    
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            NSMutableArray*  tempArray = objectArray[0] ;
            if ( [[result objectForKey:@"total"] integerValue] < 14) {
                self.collectionView.showsInfiniteScrolling = NO;
            }
            for(NSDictionary* temp in content){
                
                ContentPreviewPromotion *preview = [[ContentPreviewPromotion alloc]initWithDictionary:temp];
                [tempArray addObject:preview];
                
            }
            
            
        }
        else{
            //            [UIView transitionWithView:self.view
            //                              duration:0.75
            //                               options:UIViewAnimationOptionCurveLinear
            //                            animations:^{
            //                                [nodataView setFrame:CGRectMake(0, self.view.frame.size.height-40, nodataView.frame.size.width, nodataView.frame.size.height)];
            //                            }
            //                            completion:^(BOOL finished){
            //                                self.collectionView.showsInfiniteScrolling = NO;
            //                                [UIView animateWithDuration:0.75 delay:2.0
            //                                                    options:UIViewAnimationOptionAllowUserInteraction
            //                                                 animations:^
            //                                 {
            //                                     [nodataView setFrame:CGRectMake(0, self.view.frame.size.height+40, nodataView.frame.size.width, nodataView.frame.size.height)];
            //
            //                                 } completion:^(BOOL finished){
            //
            //                                 }];
            //                            }];
            page--;
            self.collectionView.showsInfiniteScrolling = NO;
        }
        
        [self.collectionView reloadData];
        [hud hide:YES];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
    }];
    [op start];
    
}
-(void)getPromotionList{
    page = 1;
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentByCateId\",\"params\":{ \"cateId\":7, \"page\":1,\"limit\":10 }}"];
    
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            objectArray = [[NSMutableArray alloc]init];
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            NSMutableArray*  tempArray ;
            
            tempArray = [[NSMutableArray alloc]init];
            for(NSDictionary* temp in content){
                
                ContentPreviewPromotion *preview = [[ContentPreviewPromotion alloc]initWithDictionary:temp];
                [tempArray addObject:preview];
                
            }
            [objectArray addObject:tempArray];
            
        }
        [self.collectionView reloadData];
        [hud hide:YES];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
}
-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdPromotion]];
    
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSMutableArray *bannerArray = [[NSMutableArray alloc]init];
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            NSArray *temp = [dic objectForKey:@"banners"];
            for (NSDictionary *obj in temp){
                Banner *banner = [[Banner alloc]initWithDictionary:obj];
                [bannerArray addObject:banner];
            }
            
            [[Manager sharedManager] setBannerArrayPromotion:bannerArray];
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayPromotion].count;
            [_carousel reloadData];
            // [self.collectionView reloadData];
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
    }];
    [op start];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setCateID:PROMOTION];
    
     [Manager savePageView:7 orSubCate:0];
     if(![[Manager sharedManager]bannerArrayPromotion])
         [self getBanner];
    /// set navigation bar image
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];
    self.navigationItem.title = @"โปรโมชั่น";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_PROMOTION]   ,
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    
    ///
    if ( self == [self.navigationController.viewControllers objectAtIndex:0] )
    {
        // Put Back button in navigation bar
        
        UIImage* image3 = [UIImage imageNamed:@"dtacplay_menu"];
        CGRect frameimg = CGRectMake(0, 0, 32, 32);
        UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
        
        [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
        
        [someButton addTarget:self action:@selector(callSideBar:)
             forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
        self.navigationItem.leftBarButtonItem=menuButton;
    }
    
    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height-60) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderView"];
    //    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [_collectionView registerClass:[DtacPlayPromotionCollectionViewCell class] forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    
    [timer invalidate];
    timer = nil;
    timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                              target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
    [self getPromotionList];
    
    __weak PromotionViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];

}
- (void)insertRowAtTop {
    page ++;
    
    __weak PromotionViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
    });
    
}
-(void)callSideBar:(id)sender{
    [self.frostedViewController presentMenuViewController];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        if ( IDIOM == IPAD ) {
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]+40 );
        }
        else{
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]+40  );
        }}
    else return CGSizeZero;
}
-(void)runLoop:(NSTimer*)NSTimer{
    if(_carousel)
        [_carousel scrollToItemAtIndex:_carousel.currentItemIndex+1 animated:YES];
    
}
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//referenceSizeForFooterInSection:(NSInteger)section
//{
//
//    if ( IDIOM == IPAD ) {
//        return CGSizeMake( self.view.frame.size.width, 100 );
//    }
//    else{
//        return CGSizeMake( self.view.frame.size.width, 100 );
//    }
//}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                   withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        [headerView setBackgroundColor:[UIColor whiteColor]];
        
        _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
        
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeLinear;
        _carousel.backgroundColor = [UIColor clearColor];
        //_carousel.
        [headerView addSubview:_carousel];
        
        
        
        
        // Page Control
        if(!pageControl)
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (self.carousel.frame.size.height-20), self.carousel.frame.size.width, 20.0f)];
        pageControl.numberOfPages = [[Manager sharedManager] bannerArrayPromotion].count >0  ? [[Manager sharedManager] bannerArrayPromotion].count : [[Manager sharedManager] bannerArray].count;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        pageControl.userInteractionEnabled = NO;
        [_carousel addSubview:pageControl];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _carousel.frame.size.height+_carousel.frame.origin.y+10, 30, 30)];
    
        [imageView setImage:[UIImage imageNamed:@"dtacplay_home_promotion"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [headerView addSubview:imageView];
        title=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+15,_carousel.frame.size.height+_carousel.frame.origin.y+10, self.view.frame.size.width-20, 30)];
     
        [title setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM == IPAD ? 22 : 18]];
        
        [title setTextColor:[UIColor colorWithHexString:@"1a237e"]];
        [title setText:@"โปรโมชั่น"];
        [headerView addSubview:title];
        
        //    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y+5, self.view.frame.size.width-20, 1 )];
        //    [line setBackgroundColor:[UIColor colorWithHexString:@"1a237e"]];
        //    [headerView addSubview:line];
        
        
        return headerView;
    }
    //    if (kind == UICollectionElementKindSectionFooter) {
    //        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    //
    //        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-160+10,0, 320-20, 100)];
    //        [imageView setImage:[UIImage imageNamed:@"ads.jpg"]];
    //        [imageView setBackgroundColor:[UIColor blackColor]];
    //        [imageView setContentMode:UIViewContentModeScaleToFill];
    //        [footerview addSubview:imageView];
    //
    //        return footerview;
    //    }
    return nil;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if([[Manager sharedManager] bannerArrayPromotion]){
        return [[Manager sharedManager]bannerArrayPromotion].count;
    }
    else{
        return [[Manager sharedManager]bannerArray].count;
    }
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
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *viewsImage = [[UIImageView alloc] initWithFrame:_carousel.frame];
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    if([[Manager sharedManager] bannerArrayPromotion]){
        temp  = [[Manager sharedManager] bannerArrayPromotion ][index];
    }
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

//////////
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return objectArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *tempArray = objectArray[section];
    return tempArray.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ( IDIOM == IPAD ) {
        UIEdgeInsets inset = UIEdgeInsetsMake(20,20,20,20);
        return inset;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,15,10);
    return inset;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempArray = objectArray[indexPath.section];
    ContentPreviewPromotion *articleTemp = tempArray[indexPath.row];
    NSString *identify = @"BlockCollectionViewCell";
    DtacPlayPromotionCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageW1]
                          placeholderImage:[UIImage imageNamed:@"default_image_03.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    }
    else{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageW2]
                          placeholderImage:[UIImage imageNamed:@"default_image_03.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    }
    
    [cell.label setText:articleTemp.previewTitle];
    cell.imageView.backgroundColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    //    CGSize size = [articleTemp.title boundingRectWithSize:CGSizeMake(cell.label.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
    //
    //    if (size.height < cell.frame.size.height*0.4) {
    //
    //        [cell.label setFrame:CGRectMake(5,cell.imageView.frame.size.height+cell.imageView.frame.origin.y, cell.frame.size.width-10, size.height)];
    //
    //    }
    //    else{
    //        [cell.label setFrame:CGRectMake(5,cell.imageView.frame.size.height+cell.imageView.frame.origin.y, cell.frame.size.width-10, cell.frame.size.height*0.4)];
    //    }
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.layer.shadowRadius = 2;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_2 = (self.view.frame.size.width -20);
    if ( IDIOM == IPAD ) {
        
        return CGSizeMake(self.view.frame.size.width-20, 330);
    }
    return CGSizeMake(w_2,(w_2*165)/500+50);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PromotionDetailViewController* detail= [[PromotionDetailViewController alloc]init];
    NSMutableArray *temp = objectArray[indexPath.section];
    
    
    ContentPreviewPromotion *prom = temp[indexPath.row];
    if(prom.link){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:prom.link]];
    }
    else{
    detail.contentID = prom.contentID;
    
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    
    if([[Manager sharedManager] bannerArrayPromotion]){
        temp  = [[Manager sharedManager] bannerArrayPromotion ][index];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
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
