//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ListContentEntertainmentViewController.h"
#import "MyFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "UIColor+Extensions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GameCellLevel2.h"
#import "FreeZoneAppDetailCell.h"
#import "RTLabel.h"
#import "DtacImage.h"
#import "DtacWebViewViewController.h"
#import "Manager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "ShoppingItem.h"
#import "REFrostedViewController.h"
#import "DtacPlayBlockCollectionViewCell.h"
#import "ContentPreview.h"
#import "Banner.h"
#import "BannerImage.h"
#import "SVPullToRefresh.h"
#import "EntertainmentDetailViewController.h"
@interface ListContentEntertainmentViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate>
{
    UIPageControl *pageControl;
    UILabel *title;
    float textHeight;
    NSMutableArray *shoppingItemArray;
    UIView *menuView;
    float lastContentOffset;
    NSTimer *timer;
    int page;
    
    NSMutableArray* object;
}

@end

@implementation ListContentEntertainmentViewController
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if(self.collectionView.contentOffset.y >=[[Manager sharedManager]bannerHeight]+10){
        
        [menuView setFrame:CGRectMake(menuView.frame.origin.x,0, menuView.frame.size.width, menuView.frame.size.height)];
        
    }
    else{
        [menuView setFrame:CGRectMake(menuView.frame.origin.x,[[Manager sharedManager]bannerHeight]+10- scrollView.contentOffset.y, menuView.frame.size.width, menuView.frame.size.height)];
    }
    NSLog(@"content offset y :%f",scrollView.contentOffset.y);
    lastContentOffset =scrollView.contentOffset.y;
    
}
-(void)refreshPage{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":7, \"page\":%d,\"limit\":14 }}",++page];
    if(self.subCate == ENTERTAINMENT_VIDEO){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%ld, \"page\":%d,\"limit\":14 }}",(long)self.subCate,page];
    }
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            for(NSDictionary* temp in content){
                
                ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                [object addObject:preview];
                
            }
            
            
        }
        else{
            _collectionView.showsInfiniteScrolling = NO;
            page --;
        }
        
        [_collectionView.infiniteScrollingView stopAnimating];
        
        [_collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        
        [_collectionView.infiniteScrollingView stopAnimating];
        page--;
    }];
    [op start];
    
}

-(void)GetContentEntertainmentSubCate:(int)subcat{
    
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":7, \"page\":%d,\"limit\":14 }}",1];
    if(subcat == ENTERTAINMENT_VIDEO){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%d, \"page\":%d,\"limit\":14 }}",subcat,1];
    }
    NSString *valueHeader;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    op.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [NSString stringWithFormat:@"%d",index] , @"page",nil];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        int page = [[operation.userInfo objectForKey:@"page"] intValue];
        
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;

                
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [object addObject:preview];
                    
                    
                }

            }
            
            [self.collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
}

-(void)callSideBar:(id)sender{
    [self.frostedViewController presentMenuViewController];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    page = 1;
    [self setCateID:ENTERTAINMENT];
    object = [[NSMutableArray alloc]init];
    
     [self GetContentEntertainmentSubCate:self.subCate];
 
    [Manager savePageView:0 orSubCate:self.subCate];


   
    
   
    NSString *string = [NSString stringWithFormat:@"Entertainment - %@",[Manager getSubcateName:self.subCate withThai:NO]];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": string}];
    
    self.navigationItem.title = [Manager getCateName:self.cate withThai:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_ENTERTAINMENT],
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    
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
    menuView =[[UIView alloc]initWithFrame:CGRectMake(10, [[Manager sharedManager]bannerHeight]+10, self.view.frame.size.width-20, 40)];
    [menuView setBackgroundColor:[UIColor whiteColor]];
    
    float w = menuView.frame.size.width;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,0, menuView.frame.size.width, 1 )];
    [line setBackgroundColor:[UIColor colorWithHexString:COLOR_ENTERTAINMENT]];
    [menuView addSubview:line];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0,5,30, 30);
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setBackgroundColor:[UIColor clearColor]];
    switch (self.subCate) {
        case ENTERTAINMENT_NEWS:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_news"]];
            break;
        case ENTERTAINMENT_VIDEO:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_vdo"]];
            break;
        case ENTERTAINMENT_MOVIE_NEWS:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_movie_news"]];
            break;
        case ENTERTAINMENT_MOVIE_TRAILER:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_movie_trailer"]];
            break;
        case ENTERTAINMENT_TV:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_vdo"]];
            break;
        default:
            break;
    }
    
    
    UILabel* label= [[DtacLabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width+5,imageView.frame.origin.y, w-imageView.frame.size.width+5, 30)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [label setText:[Manager getSubcateName:self.subCate withThai:YES]];
    
    [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
    [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 18 : 14]];

    
    [menuView addSubview:imageView];
    [menuView addSubview:label];

    
    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-60) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionReusableView class]
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"BannerHeader"];
    [_collectionView registerClass:[UICollectionReusableView class]
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"RecommendedHeader"];
  [_collectionView registerClass:[DtacPlayBlockCollectionViewCell class] forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
    
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    __weak ListContentEntertainmentViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:menuView];
}
- (void)insertRowAtTop {
    
    __weak ListContentEntertainmentViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
    });
    
}

-(void)clickLogin:(id)button{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.kaidee.com/member/login/"]];
}
-(void)clickRegister:(id)button{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.kaidee.com/member/register/"]];
}
-(void)clickSell:(id)button{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.kaidee.com/posting/"]];
}
-(void)runLoop:(NSTimer*)NSTimer{
    if(_carousel)
        [_carousel scrollToItemAtIndex:_carousel.currentItemIndex+1 animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0){
        if ( IDIOM == IPAD ) {
            
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]+40);
        }
        else{
            
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]+40);
        }
    }
    else{
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                   withReuseIdentifier:@"BannerHeader" forIndexPath:indexPath];
        
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
        pageControl.numberOfPages = [[Manager sharedManager] bannerArray].count;;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        pageControl.userInteractionEnabled = NO;
        [_carousel addSubview:pageControl];
        [timer invalidate];
        timer = nil;
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
        
        
        return headerView;
        
    }
    return reusableview;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return object.count;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,15,10);
    return inset;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContentPreview *articleTemp = object[indexPath.row];
    NSString *identify = @"BlockCollectionViewCell";
    DtacPlayBlockCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    

        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
                          placeholderImage:[UIImage imageNamed:@"default_image_01_L.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
  
    [cell.label setText:articleTemp.previewTitle];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.layer.shadowRadius = 2;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
    NSLog(@"create cell");
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_1 = (self.view.frame.size.width/2 -15);
    float w_2 = (self.view.frame.size.width -20);
    
    return CGSizeMake(w_1,(w_1*144)/300+(IDIOM == IPAD ? 60 : 50));
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EntertainmentDetailViewController * articleView= [[EntertainmentDetailViewController alloc]init];
  
    //NSMutableArray *temp =  object[indexPath.section];
    ContentPreview *preview = object[indexPath.row];
    articleView.contentID = preview.contentID;
    articleView.pageType = ENTERTAINMENT;
    articleView.themeColor = [UIColor colorWithHexString:COLOR_ENTERTAINMENT];
 
    articleView.titlePage = @"บันเทิง";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    [self.navigationController pushViewController:articleView animated:YES];
}
#pragma mark - Height Calculation Method
- (CGFloat)findHeightForText:(NSString *)text havingMaximumWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        NSDictionary *attributes = @{NSFontAttributeName: font};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        
        
        size = CGSizeMake(rect.size.width, rect.size.height + 1);
    }
    return size.height;
}



#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[Manager sharedManager]bannerArray].count;
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
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
}

@end
