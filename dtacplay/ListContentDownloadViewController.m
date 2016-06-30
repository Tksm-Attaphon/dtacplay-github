//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ListContentDownloadViewController.h"
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
#import "REFrostedViewController.h"
#import "DtacPlayBlockCollectionViewCell.h"
#import "ContentPreview.h"
#import "Banner.h"
#import "BannerImage.h"
#import "SVPullToRefresh.h"
#import "GameContent.h"
#import "AppCell.h"
#import "MusicCell.h"
#import "MusicContent.h"
#import "GameDetailViewController.h"
#import "FreeZoneDetialController.h"
#import "CPACollectionViewCell2.h"
#import "NimbusKitAttributedLabel.h"
#import "CPAContent.h"
@interface ListContentDownloadViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate>
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

@implementation ListContentDownloadViewController

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
    int subcat = self.subCate;
    NSString *jsonString ;
    if(!_isCPA)
        if(self.subCate == DOWNLOAD_GAME ||self.subCate == DOWNLOAD_GAME_NEW ||self.subCate == DOWNLOAD_GAME_HIT ||self.subCate == DOWNLOAD_GAME_GAMECLUB ||self.subCate == DOWNLOAD_GAME_GAMEROOM){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14,\"suggest\":false,\"opera\":null }}",(long)self.subCate,++page];
        }else{
        
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusic\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14,\"suggest\":false }}",(long)self.subCate,++page];
    }
    else{
        switch (subcat) {
            case DOWNLOAD_CPA_NEWS_HIT:
                subcat = 1;
                break;
            case DOWNLOAD_CPA_NEWS_GOSSIP:
                subcat = 2;
                break;
            case DOWNLOAD_CPA_NEWS_ECO:
                subcat = 3;
                break;
            case DOWNLOAD_CPA_HORO:
                subcat = 4;
                break;
            case DOWNLOAD_CPA_LUCKY_NUMBER:
                subcat = 5;
                break;
            case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
                subcat = 6;
                break;
            case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
                subcat = 7;
                break;
            case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
                subcat = 8;
                break;
            case DOWNLOAD_CPA_SPORT_FOOTBALL:
                subcat = 9;
                break;
            case DOWNLOAD_CPA_SPORT_OTHER:
                subcat = 10;
            case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
                subcat = 11;
                break;
            case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
                subcat = 12;
                break;
            default:
                break;
        }
        
        jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getCpaContentBySubCateId\",\"params\":{\"cpaSubCateId\":%d, \"page\":%d, \"limit\":%d }}",subcat,++page,10];
    }
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            if(!_isCPA){
            if(self.subCate == DOWNLOAD_GAME ||self.subCate == DOWNLOAD_GAME_NEW ||self.subCate == DOWNLOAD_GAME_HIT ||self.subCate == DOWNLOAD_GAME_GAMECLUB ||self.subCate == DOWNLOAD_GAME_GAMEROOM){
                for(NSDictionary* temp in content){
                    
                    GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                    [object addObject:preview];
                    
                    
                }
            }
            
            else{
                for(NSDictionary* temp in content){
                    
                    MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                    [object addObject:preview];
                    
                    
                }
            }
            }else{
                for(NSDictionary* temp in content){
                    
                    CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                    [object addObject:preview];
                    
                    
                }
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

-(void)GetContentDownloadSubCate:(int)subcat{
    
    
    NSString *jsonString ;
    if(!_isCPA){
    if(subcat == DOWNLOAD_GAME ||subcat == DOWNLOAD_GAME_NEW ||subcat == DOWNLOAD_GAME_HIT ||subcat == DOWNLOAD_GAME_GAMECLUB ||subcat == DOWNLOAD_GAME_GAMEROOM){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"subCateId\":%d,\"page\":%d,\"limit\":14,\"suggest\":false,\"opera\":null }}",subcat,1];
    }else{
        
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusic\",\"params\":{\"subCateId\":%d,\"page\":%d,\"limit\":14,\"suggest\":false }}",subcat,1];
    }
        
    }else{
        switch (subcat) {
            case DOWNLOAD_CPA_NEWS_HIT:
               subcat = 1;
                break;
            case DOWNLOAD_CPA_NEWS_GOSSIP:
                subcat = 2;
                break;
            case DOWNLOAD_CPA_NEWS_ECO:
                subcat = 3;
                break;
            case DOWNLOAD_CPA_HORO:
                subcat = 4;
                break;
            case DOWNLOAD_CPA_LUCKY_NUMBER:
                subcat = 5;
                break;
            case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
                subcat = 6;
                break;
            case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
                subcat = 7;
                break;
            case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
                subcat = 8;
                break;
            case DOWNLOAD_CPA_SPORT_FOOTBALL:
                subcat = 9;
                break;
            case DOWNLOAD_CPA_SPORT_OTHER:
                subcat = 10;
            case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
                subcat = 11;
                break;
            case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
                subcat = 12;
                break;
            default:
                break;
        }

          jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getCpaContentBySubCateId\",\"params\":{\"cpaSubCateId\":%d, \"page\":null, \"limit\":null }}",subcat];
    }
    NSString *valueHeader;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];

    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
      
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            if(!_isCPA){
            if(subcat == DOWNLOAD_GAME ||subcat == DOWNLOAD_GAME_NEW ||subcat == DOWNLOAD_GAME_HIT ||subcat == DOWNLOAD_GAME_GAMECLUB ||subcat == DOWNLOAD_GAME_GAMEROOM){
                for(NSDictionary* temp in content){
                    
                    GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                    [object addObject:preview];
                    
                    
                }
            }
            
            else{
                for(NSDictionary* temp in content){
                    
                    MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                    [object addObject:preview];
                    
                    
                }
            }
                
            }else{
                for(NSDictionary* temp in content){
                    
                    CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                    [object addObject:preview];
                    
                    
                }
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
-(void)viewDidLoad{
    [super viewDidLoad];
    page = 1;
    [self setCateID:DOWNLOAD];
     if(![[Manager sharedManager]bannerArrayDownload])
         [self getBanner];
    object = [[NSMutableArray alloc]init];
    
    [self GetContentDownloadSubCate:self.subCate];

    [ Manager savePageView:0 orSubCate:self.subCate];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:DOWNLOAD withSubCate:self.subCate :nil]}];
    
    self.navigationItem.title = [Manager getSubcateName:self.subCate withThai:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_DOWNLOAD],
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
    [line setBackgroundColor:[UIColor colorWithHexString:COLOR_DOWNLOAD]];
    [menuView addSubview:line];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0,5,30,30);
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setBackgroundColor:[UIColor clearColor]];
    switch (self.subCate) {
        case DOWNLOAD_GAME_NEW:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_gamenew"]];
            break;
        case DOWNLOAD_GAME_HIT:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_gamehit"]];
            break;
        case DOWNLOAD_GAME_GAMEROOM:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_gamegameroom"]];
            break;
        case DOWNLOAD_GAME_GAMECLUB:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_gamegameclub"]];
            break;
        case DOWNLOAD_MUSIC_HIT:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_musichit"]];
            break;
        case DOWNLOAD_MUSIC_INTER:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_musicinter"]];
            break;
        case DOWNLOAD_MUSIC_LOOKTHOONG:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_musiclukthung"]];
            break;
        case DOWNLOAD_MUSIC_NEW:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_musicnew"]];
            break;
        case DOWNLOAD_CPA_NEWS_HIT:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_news"]];
            break;
        case DOWNLOAD_CPA_NEWS_GOSSIP:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_gossip"]];
            break;
        case DOWNLOAD_CPA_NEWS_ECO:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_eco"]];
            break;
        case DOWNLOAD_CPA_HORO:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_horo"]];
            break;
        case DOWNLOAD_CPA_LUCKY_NUMBER:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_lotto"]];
            break;
        case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_quiz"]];
            break;
        case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_movie"]];
            break;
        case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_buety"]];
            break;
        case DOWNLOAD_CPA_SPORT_OTHER:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_sport"]];
            break;
        case DOWNLOAD_CPA_SPORT_FOOTBALL:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_football"]];
            break;
        case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_clipded"]];
            break;
        case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
            [imageView setImage:[UIImage imageNamed:@"dtacplay_download_premiumclip"]];
            break;
        
        default:
            break;
    }
    
    UILabel* label= [[DtacLabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width+5,imageView.frame.origin.y, w-imageView.frame.size.width+5, 30)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [label setText:[Manager getSubcateName:self.subCate withThai:YES]];
    
    [label setTextColor:[UIColor colorWithHexString:[Manager getColorName:self.cate]]];
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
    if(!_isCPA){
    if(self.subCate == DOWNLOAD_GAME ||self.subCate == DOWNLOAD_GAME_NEW ||self.subCate == DOWNLOAD_GAME_HIT ||self.subCate == DOWNLOAD_GAME_GAMECLUB ||self.subCate == DOWNLOAD_GAME_GAMEROOM){
        [_collectionView registerClass:[AppCell class] forCellWithReuseIdentifier:@"GameCell"];
        
        __weak ListContentDownloadViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [_collectionView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
    }
    else{
        [_collectionView registerClass:[MusicCell class] forCellWithReuseIdentifier:@"MusicCell"];
        
        __weak ListContentDownloadViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [_collectionView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
    }
    }else{
         [_collectionView registerClass:[CPACollectionViewCell2 class] forCellWithReuseIdentifier:@"CPACell"];
    }
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
  
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:menuView];
}
- (void)insertRowAtTop {
    
    __weak ListContentDownloadViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
    });
    
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
        pageControl.numberOfPages = [[Manager sharedManager] bannerArrayDownload].count >0  ? [[Manager sharedManager] bannerArrayDownload].count : [[Manager sharedManager] bannerArray].count;
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
-(void)runLoop:(NSTimer*)NSTimer{
    if(_carousel)
        [_carousel scrollToItemAtIndex:_carousel.currentItemIndex+1 animated:YES];
    
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
    if(!_isCPA){
    if(self.subCate == DOWNLOAD_MUSIC_NEW || self.subCate == DOWNLOAD_MUSIC_HIT || self.subCate == DOWNLOAD_MUSIC_INTER ||self.subCate == DOWNLOAD_MUSIC_LOOKTHOONG){
         MusicContent *articleTemp = object[indexPath.row];
        NSString *identify = @"MusicCell";
        MusicCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
  
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
                              placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
        
      
        [cell.nameMusicLabel setText:articleTemp.title];
        [cell.imageView setBackgroundColor:[UIColor clearColor]];
        [cell.nameArtistLabel setText:articleTemp.artist];
        [cell.nameAlbumLabel setText:articleTemp.album];
        
        //NSLog(@"%f , %f , %f",cell.nameMusicLabel.frame.origin.y,cell.nameArtistLabel.frame.origin.y,cell.nameAlbumLabel.frame.origin.y);
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
        NSLog(@"complete");
        return cell;
        
    }
    else{
         GameContent *articleTemp = object[indexPath.row];
        NSString *identify = @"GameCell";
        AppCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
     
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
                          placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    
        
        [cell.title setText:articleTemp.title];
        [cell.desc setText:articleTemp.descriptionContent];
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
         NSLog(@"complete");
        return cell;
        
    }
    }else{
        CPAContent *articleTemp = object[indexPath.row];
        NSString *identify = @"CPACell";
        CPACollectionViewCell2 *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        switch (self.subCate ) {
                
            case DOWNLOAD_CPA_NEWS_HIT:
                cell.imageView.image = [UIImage imageNamed:@"News_XL"];
                break;
            case DOWNLOAD_CPA_NEWS_GOSSIP:
                cell.imageView.image = [UIImage imageNamed:@"gossip_XL"];
                break;
            case DOWNLOAD_CPA_NEWS_ECO:
                cell.imageView.image = [UIImage imageNamed:@"economic_XL"];
                break;
            case DOWNLOAD_CPA_HORO:
                cell.imageView.image = [UIImage imageNamed:@"horo_XL"];
                break;
            case DOWNLOAD_CPA_LUCKY_NUMBER:
                cell.imageView.image = [UIImage imageNamed:@"lotto_XL"];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
                cell.imageView.image = [UIImage imageNamed:@"quiz_XL"];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
                cell.imageView.image = [UIImage imageNamed:@"Movie_XL"];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
                cell.imageView.image = [UIImage imageNamed:@"beauty&travel_XL"];
                break;
            case DOWNLOAD_CPA_SPORT_OTHER:
                cell.imageView.image = [UIImage imageNamed:@"Sport_etc_XL"];
                break;
            case DOWNLOAD_CPA_SPORT_FOOTBALL:
                cell.imageView.image = [UIImage imageNamed:@"Sport_XL"];
                break;
            case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
                cell.imageView.image = [UIImage imageNamed:@"clip_XL"];
                break;
            case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
                cell.imageView.image = [UIImage imageNamed:@"vip_clip_XL"];
                break;
            default:
                cell.imageView.image = [UIImage imageNamed:@"clip_XL"];
                break;
        }

        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
                          placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
        NSString *imageName= @"Hot_Register.png";
        
        NSString *detail = [NSString stringWithFormat:@"%@ %@",articleTemp.service,articleTemp.descriptionContent];
        if(articleTemp.flgNew ){
            imageName= @"new_Register_2";
        }
        else if(articleTemp.flgHot ){
            imageName= @"hot_Register_2";
        }
        else if(articleTemp.flgRec){
            imageName= @"reccomend_Register_2";
        }
        else{
            imageName= @"register_icon";
        }
        
//                break;
//            case 2:
//                imageName = @"reccomend_Register";
//                break;
//            case 3:
//                imageName = @"hot_Register_2";
//                break;
//            case 4:
//                imageName = @"new_Register_2";
//                break;
//            case 5:
//                imageName = @"reccomend_Register_2";
//                break;
     
        [cell.descriptionLabel setText:[NSString stringWithFormat:@"%@\n\n\n\n\n",detail ]];
        NSString *text = [NSString stringWithFormat:@"%@\n",detail ];
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        cell.descriptionLabel.adjustsFontSizeToFitWidth = NO;
        cell.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];

        if(imageName != nil){
        UIImage *img=[UIImage imageNamed:imageName];
        
        [cell.descriptionLabel insertImage:img atIndex:text.length
                         margins:UIEdgeInsetsZero verticalTextAlignment:NIVerticalTextAlignmentMiddle];
        
        }
        [cell.descriptionLabel setFont:[UIFont fontWithName:FONT_DTAC_BOLD size:IDIOM == IPAD ? 16 : 14] range:(NSRange){0,articleTemp.service.length }    ];

        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isCPA){
        float w_1 = (self.view.frame.size.width-20);
        CPAContent *articleTemp = object[indexPath.row];
       
        
        // Values are fractional -- you should take the ceilf to get equivalent values
        NIAttributedLabel *des= [[NIAttributedLabel alloc]initWithFrame:CGRectMake(0,0, w_1-120-10, 999)];
         [des setText:[NSString stringWithFormat:@"%@ %@ ",articleTemp.service,articleTemp.descriptionContent]];
        des.numberOfLines = 0;
        [des setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [des setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        [des sizeToFit];
        float height = 120;
        
            height = des.frame.size.height+w_1*0.25;
        
        return CGSizeMake(w_1,height);
    }else{
        float w_1 = (self.view.frame.size.width/2 -15);
   
        return CGSizeMake(w_1,w_1+45);
    }
}
- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(_isCPA){
        CPAContent *articleTemp = object[indexPath.row];
        [Manager savePageViewCPA:[articleTemp.cpaConID intValue]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:articleTemp.aocLink]];
    }
    else{
    if(self.subCate == DOWNLOAD_MUSIC_NEW || self.subCate == DOWNLOAD_MUSIC_HIT || self.subCate == DOWNLOAD_MUSIC_INTER ||self.subCate == DOWNLOAD_MUSIC_LOOKTHOONG){
        MusicContent *articleTemp = object[indexPath.row];
        [self getMusicByID:articleTemp.musicID];
      
    }
    else{
        GameContent *articleTemp = object[indexPath.row];
        [self getGameByID:articleTemp.gameID];
    }
    }
}

-(void)getGameByID:(NSString*)ID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGameById\",\"params\":{\"gameId\":%@}}",ID];
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            GameDetailViewController* articleView= [[GameDetailViewController alloc]init];
            articleView.cate = DOWNLOAD;
            articleView.subcate = self.subCate;
            
            GameContent *obj = [[GameContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.gameObject = obj;
            
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
}
-(void)getMusicByID:(NSString*)ID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusicById\",\"params\":{\"musicId\":%@}}",ID];
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            FreeZoneDetialController* articleView= [[FreeZoneDetialController alloc]init];
            articleView.cate = DOWNLOAD;
            articleView.subcate = self.subCate;
            MusicContent *obj = [[MusicContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.musicObject = obj;
            
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
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
    
    if([[Manager sharedManager] bannerArrayDownload]){
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
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    
    if([[Manager sharedManager] bannerArrayDownload]){
        temp  = [[Manager sharedManager] bannerArrayDownload ][index];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
}

@end
