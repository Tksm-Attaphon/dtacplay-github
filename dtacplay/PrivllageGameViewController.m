//
//  PromotionViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "PrivllageGameViewController.h"
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
#import "AppCell.h"
#import "GameContent.h"
#import "DtacImage.h"
#import "BannerView.h"
@interface PrivllageGameViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    UIPageControl *pageControl;
    UIView *contentView;
    UILabel *title;
    
    NSMutableArray *objectArray;
    
    int page;
    UIView *nodataView;
    NSTimer *timer;
    
    BannerView *bannerView;
    NSURL *linkBanner;
    NSURL *imagePath;
}
@end

@implementation PrivllageGameViewController
-(void)viewWillAppear:(BOOL)animated{
    if(!timer)
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:self];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [NSString stringWithFormat: @"%@",[[[Manager sharedManager]privilageGameCategory ]name]]}];
}
-(void)getListGame{
    page = 1;
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"cateId\":10,\"subCateId\":null,\"page\":%d,\"limit\":100 ,\"suggest\":false,\"opera\":null}}",1];
    
    
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
                
                GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
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
- (void)getBannerCredit{
    int smrtID = -1;
    if([SERVICE isEqual: SERVICE_PRODUCTOIN]){
        smrtID = 57;
    }
    else{
        smrtID = 54;
    }
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\",\"params\":{ \"smrtAdsRefId\":%d}}",smrtID];
    
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSDictionary *result_1 = [responseObject objectForKey:@"result"] ;
            NSArray* result_2 = [result_1 objectForKey:@"banners"];
            
            NSDictionary *result = result_2.count >= 1 ? result_2[0] : nil;
            NSDictionary *imageAll = [[result objectForKey:@"images"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"images"] ;
            NSString *imageURL = [[imageAll objectForKey:@"m"] isEqual:[NSNull null]] ? nil : [imageAll objectForKey:@"m"] ;
            NSString *linkImage = [[result objectForKey:@"imageLink"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"imageLink"] ;
            NSString *detail = [[result objectForKey:@"detail"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"detail"] ;
            NSString *link = [[result objectForKey:@"link"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"link"];
            
            linkBanner = [NSURL URLWithString:linkImage];

            imagePath = [NSURL URLWithString:imageURL];
            [self.collectionView reloadData];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
      
        
    }];
    [op start];
}


-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdPrivilageGame]];
    
    
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
            
            [[Manager sharedManager] setBannerArrayPrivilageGame:bannerArray];
            bannerView.bannerArray = [[Manager sharedManager] bannerArrayPrivilageGame];
            [bannerView.carousel reloadData];
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
    [self getBannerCredit];
    [Manager savePageView:10 orSubCate:0];
    if(![[Manager sharedManager]bannerArrayPrivilageGame])
        [self getBanner];
    /// set navigation bar image
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];
    self.navigationItem.title = [[[Manager sharedManager] privilageGameCategory]name];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_FREEZONE]   ,
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
    [_collectionView registerClass:[AppCell class] forCellWithReuseIdentifier:@"GameCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BannerCredit"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];

    
    [self getListGame];

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
    if(bannerView.carousel)
        [bannerView.carousel scrollToItemAtIndex:bannerView.carousel.currentItemIndex+1 animated:YES];
    
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
        
        
        if(!bannerView)
            bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
        bannerView.backgroundColor = [UIColor clearColor];
        //_carousel.
        [headerView addSubview:bannerView];
        
        if([[Manager sharedManager] bannerArrayPrivilageGame]){
            bannerView.bannerArray =  [[Manager sharedManager]bannerArrayPrivilageGame];
        }
        else{
            bannerView.bannerArray =  [[Manager sharedManager]bannerArray];
        }
        [bannerView.carousel reloadData];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, bannerView.frame.size.height+bannerView.frame.origin.y+10, 30, 30)];
        
        [imageView setImage:[UIImage imageNamed:@"dtacplay_download_gamehit"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [headerView addSubview:imageView];
        title=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+15,bannerView.frame.size.height+bannerView.frame.origin.y+10, self.view.frame.size.width-20, 30)];
        
        [title setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM == IPAD ? 22 : 18]];
        
        [title setTextColor:[UIColor colorWithHexString:COLOR_FREEZONE]];
        [title setText:[[[Manager sharedManager] privilageGameCategory]name]];
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

//////////
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(linkBanner){
        return objectArray.count+1;
    }
    return objectArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        NSMutableArray *tempArray = objectArray[section];
        return tempArray.count;
    }else{
        return 1;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(section == 0){
    if ( IDIOM == IPAD ) {
        UIEdgeInsets inset = UIEdgeInsetsMake(20,20,20,20);
        return inset;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,15,10);
    return inset;
    }
    else{
        if ( IDIOM == IPAD ) {
            UIEdgeInsets inset = UIEdgeInsetsMake(10,20,20,20);
            return inset;
        }
        UIEdgeInsets inset = UIEdgeInsetsMake(5,10,15,10);
        return inset;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section == 1){
        
        
        NSString *identify = @"BannerCredit";
        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [cell addSubview:imageView];
        [imageView sd_setImageWithURL:imagePath
                          placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         imageView.image = image;
                                     }
                                 }];
    
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
        
        return cell;
    }
     NSMutableArray *tempArray = objectArray[indexPath.section];
    GameContent *articleTemp = tempArray[indexPath.row];

    NSString *identify = @"GameCell";
    AppCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailXL]
                      placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 if (image) {
                                     cell.imageView.image = image;
                                 }
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
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
    float w_1 = (self.view.frame.size.width/2 -15);

    return CGSizeMake(w_1,w_1+45);
    }else{
        return CGSizeMake(self.view.frame.size.width -15,0.2119*(self.view.frame.size.width - 15));
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    if(indexPath.section == 0){
    NSMutableArray *temp = objectArray[indexPath.section];
    
    
    GameContent *prom = temp[indexPath.row];
    if(prom.link){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:prom.link]];
    }
        
    }else{
        [[UIApplication sharedApplication] openURL:linkBanner];
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
