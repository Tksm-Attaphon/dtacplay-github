//
//  COLOR_NEWS
//  dtacplay
//
//  Created by attaphon on 10/25/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DownloadCPAViewController.h"

#import "JBKenBurnsView.h"
#import "UINavigationBar+Awesome.h"
#import "SearchTableViewController.h"
#import "REFrostedViewController.h"
#import "MyFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "ContentPreview.h"
#import "MBProgressHUD.h"
#import "DtacPlayBlockCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HoroViewController.h"
#import "SVPullToRefresh.h"
#import "Manager.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "Banner.h"
#import "BannerImage.h"
#import "DtacPlayHeaderHoloCollectionViewCell.h"
#import "GameContent.h"
#import "AppCell.h"
#import "MusicCell.h"
#import "MusicContent.h"
#import "GameDetailViewController.h"
#import "FreeZoneDetialController.h"
#import "ListContentDownloadViewController.h"
#import "CPACollectionViewCell.h"
#import "DownloadViewController.h"
@interface DownloadCPAViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *sizeArray;
    
    NSTimer *timer;
    
    int currentPage;
    float posTopCollectionView;
    float menuPosition;
    UIScrollView *menuView;
    BOOL isChangeCollection;
    
    UIImageView *iconHeader;
    
    UIColor *currentNavColor;
    int totalPage;
    UIView *imageHeader;
    JBKenBurnsView *imageHeaderImage;
    UIView *imageHeaderColor;
    
    NSArray *menuArray;
    NSMutableArray *menuTypeArray;
    NSArray *iconHeaderArray;
    NSMutableArray *buttonArray;
    UIView *indicatorMenu;
    
    
    UICollectionView *tempCollection;
    NSMutableArray *collectionViewArray;
    NSMutableArray* allObjectArray;
    
    int inmediatelyIndex;
    NSMutableArray *pageArray;
    
    float menuHeight;
    UIView *nodataView;
    
}
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation DownloadCPAViewController
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x==0){
        if(self.lastContentOffset <=posTopCollectionView ){
            
            if(self.collectionView.contentOffset.y !=0){
                menuView.frame = CGRectMake(0,posTopCollectionView-scrollView.contentOffset.y, self.view.frame.size.width, menuHeight);
                
            }
            else{
                
                menuView.frame = CGRectMake(0,menuPosition- scrollView.contentOffset.y, self.view.frame.size.width, menuHeight);
            }
        }
        else{
            menuView.frame = CGRectMake(0,0, self.view.frame.size.width, menuHeight);
        }
        
        
        imageHeader.frame = CGRectMake(0,1-scrollView.contentOffset.y, imageHeader.frame.size.width, imageHeader.frame.size.height);
        if(scrollView.contentOffset.y ==0){
            self.collectionView.contentOffset = CGPointMake(0, 0);
        }
        NSLog(@"content offset y :%f",scrollView.contentOffset.y);
        self.lastContentOffset =scrollView.contentOffset.y;
    }
}

-(void)setup{

        MyFlowLayout *layout=[[MyFlowLayout alloc] init];
        
        UICollectionView *fooCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-110) collectionViewLayout:layout];

        [fooCollection setDataSource:self];
        [fooCollection setDelegate:self];
        
        [fooCollection registerNib:[UINib nibWithNibName:@"CPACollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CPACell"];
        
        //HeaderCell
        [fooCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
        [fooCollection setBackgroundColor:[UIColor clearColor]];
        
        [fooCollection scrollsToTop];
        
        [fooCollection addSubview:iconHeader];
        [collectionViewArray addObject:fooCollection];
    
}
-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdDownload]];
    
    
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
            
            [[Manager sharedManager] setBannerArrayDownload:bannerArray];
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayDownload].count;
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
    [self setCateID:DOWNLOAD];
    
    if(![[Manager sharedManager]bannerArrayDownload])
        [self getBanner];
    // [Manager savePageView:8];
    //
    //    for (int i = 0 ; i <50; i++) {
    //        NSInteger randomNumber = arc4random() %1000000;
    //        NSLog(@"%d",randomNumber);
    //    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _themeColor = [UIColor colorWithHexString:COLOR_DOWNLOAD];
    self.navigationItem.title = @"ดาวน์โหลด";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:_themeColor,
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
    [self setup];
    
    
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];

    
    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
    
    UICollectionView *fooCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-65) collectionViewLayout:layout];
    
    [fooCollection setDataSource:self];
    [fooCollection setDelegate:self];
    [fooCollection registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"BannerHeader"];
    
    [fooCollection registerNib:[UINib nibWithNibName:@"CPACollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CPACell"];
    [fooCollection registerNib:[UINib nibWithNibName:@"CPACollectionViewCell2Line" bundle:nil] forCellWithReuseIdentifier:@"CPACell2"];
    [fooCollection registerClass:[DtacPlayHeaderHoloCollectionViewCell class] forCellWithReuseIdentifier:@"HeaderCell"];
    //HeaderCell
    [fooCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    [fooCollection setBackgroundColor:[UIColor clearColor]];
    
    [fooCollection scrollsToTop];
    
    [fooCollection addSubview:iconHeader];
    [self.view addSubview:fooCollection];

    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0){
        if ( IDIOM == IPAD ) {
            
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]);
        }
        else{
            
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]);
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

-(void)callSideBar:(id)sender{
    [self.frostedViewController presentMenuViewController];
}
-(void)menuPress:(UIButton*)button{
    
    if(button.tag != currentPage){
        
        //[indicatorMenu setFrame:CGRectMake(button.frame.origin.x, button.frame.size.height-5,  button.frame.size.width, 5)];
        
        float w = menuView.frame.size.width;
        float h = menuView.frame.size.height;
        
        CGRect toVisible = CGRectMake(button.frame.origin.x-self.view.frame.size.width/2+button.frame.size.width/2, 0, w, h);
        [menuView scrollRectToVisible:toVisible animated:YES];
        
        [_swipeView scrollToItemAtIndex:button.tag  duration:0.5];
    }else{
        [self.collectionView reloadData];
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView.tag < 3){
        
        return 10;
    }
    else{
        return 0;
    }
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if(section == 0){
        
        UIEdgeInsets inset = UIEdgeInsetsMake(posTopCollectionView+10,10,10,10);
        return inset;
        
    }
    else{
        
        UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
        return inset;
    }
    
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.row == 0){
            
   
            
            NSString *identify = @"HeaderCell";
            DtacPlayHeaderHoloCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.line setBackgroundColor:[UIColor colorWithHexString:COLOR_DOWNLOAD]];
            [cell.moreButton setHidden:YES];
  
            [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_gameclub"]];
            [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.label setTextColor:[UIColor colorWithHexString:COLOR_DOWNLOAD]];
            [cell.imageView setBackgroundColor:[UIColor whiteColor]];
            [cell.label setText:[Manager getCateName:DOWNLOAD withThai:YES]];
            
            return cell;
            
        }
        else{
            NSString *identify = @"CPACell";
            if(indexPath.row == 8){
                identify = @"CPACell2";
            }
            
                CPACollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@""]
                                  placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             
                                         }];
                
            switch (indexPath.row) {
                case 1:
                     [cell.text setText:[Manager getSubcateName:DOWNLOAD_MUSIC withThai:YES]];
                   
                    break;
                case 2:
                   
                     [cell.text setText:[Manager getSubcateName:DOWNLOAD_GAME withThai:YES]];
                    break;
                case 3:
                  [cell.text setText:[Manager getSubcateName:DOWNLOAD_CPA_NEWS withThai:YES]];
                    break;
                case 4:
                    [cell.text setText:[Manager getSubcateName:DOWNLOAD_CPA_HORO withThai:YES]];
                    break;
                case 5:
                    [cell.text setText:[Manager getSubcateName:DOWNLOAD_CPA_LUCKY_NUMBER withThai:YES]];
                    break;
                case 6:
                    [cell.text setText:[Manager getSubcateName:DOWNLOAD_CPA_LIFESTYLE withThai:YES]];
                    break;
                case 7:
                   [cell.text setText:[Manager getSubcateName:DOWNLOAD_CPA_SPORT withThai:YES]];
                    break;
                case 8:
                    [cell.text setText:@"คลิปฟรี\nอินเตอร์เนต"];
                    break;
                default:
                    break;
            }
            
                [cell.imageView setBackgroundColor:[UIColor clearColor]];
                
                //NSLog(@"%f , %f , %f",cell.nameMusicLabel.frame.origin.y,cell.nameArtistLabel.frame.origin.y,cell.nameAlbumLabel.frame.origin.y);
                cell.layer.masksToBounds = NO;
                cell.layer.shadowOffset = CGSizeMake(2, 2);
                cell.layer.shadowRadius = 2;
                cell.layer.shadowOpacity = 0.5;
                cell.layer.shouldRasterize = YES;
                cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
                
                [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
                
                return cell;
            }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_1 = (self.view.frame.size.width/2 -15);
    
    float w_2 = (self.view.frame.size.width -20);
    
    if(indexPath.row == 0){
        
        return CGSizeMake(w_2,40);
    }
    return CGSizeMake(w_1,w_1);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != 0){
        DownloadViewController *catePage= [[DownloadViewController alloc] init];
       
        catePage.indexPage = 0;
        
        
        catePage.pageType = DOWNLOAD;
        switch (indexPath.row) {
            case 1:
                catePage.subeType = DOWNLOAD_MUSIC;
                catePage.subeType = DOWNLOAD_MUSIC_NEW;
                 catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_MUSIC], nil];
                break;
            case 2:
                catePage.subeType = DOWNLOAD_GAME;
                catePage.subeType = DOWNLOAD_GAME_HIT;
                catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_GAME], nil];
                break;
            case 3:
                catePage.subeType = DOWNLOAD_CPA_NEWS;
                catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_CPA_NEWS], nil];
                break;
            case 4:
                catePage.subeType = DOWNLOAD_CPA_HORO;
                catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_CPA_HORO], nil];
                break;
            case 5:
                catePage.subeType = DOWNLOAD_CPA_LUCKY_NUMBER;
                catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_CPA_LUCKY_NUMBER], nil];
                break;
            case 6:
                catePage.subeType = DOWNLOAD_CPA_LIFESTYLE;
                catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_CPA_LIFESTYLE], nil];
                break;
            case 7:
                catePage.subeType = DOWNLOAD_CPA_SPORT;
                catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_CPA_SPORT], nil];
                break;
            case 8:
                catePage.subeType = DOWNLOAD_CPA_CLIP_FREE;
                catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_CPA_CLIP_FREE], nil];
                break;
            default:
                break;
        }
        

        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:catePage animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    //    if(collectionView.tag<3){
    //        if(section>=1){
    //            if(section == 1){
    //                NSArray* temp = allObjectArray[collectionView.tag] ;
    //                NSArray*temp2 = temp[1];
    //                if(temp2.count <8){
    //                    return CGSizeZero;
    //                }
    //                else{
    //                    return CGSizeMake(self.view.frame.size.width,100);
    //                }
    //            }
    //            return CGSizeZero;
    //        }
    //        return CGSizeMake(self.view.frame.size.width,100);
    //    }else{
    return CGSizeZero;
    //}
}


-(void)runLoop:(NSTimer*)NSTimer{
    
    if(_carousel)
        [_carousel scrollToItemAtIndex:self.carousel.currentItemIndex+1 animated:YES];
    
    
    
}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    // _bannerView.frame =CGRectMake(0.0f, 0.0f, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
//    pageControl.frame = CGRectMake(0.0f, (self.bannerView.frame.size.height-30), self.bannerView.frame.size.width, 20.0f);
//}
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    NSLog(@"xx");
}
#pragma mark -
#pragma mark iCarousel methods
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    
    if([[Manager sharedManager] bannerArrayDownload]){
        temp  = [[Manager sharedManager] bannerArrayDownload ][index];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    if([[Manager sharedManager] bannerArrayDownload]){
        return [[Manager sharedManager]bannerArrayDownload].count;
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
    
    if([[Manager sharedManager] bannerArrayNews]){
        temp  = [[Manager sharedManager] bannerArrayDownload ][index];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // The container should have already been opened, otherwise events pushed to
    // the data layer will not fire tags in that container.
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    [dataLayer push:@{@"event": @"openScreen", @"screenName": @"Download"}];
    
}

@end