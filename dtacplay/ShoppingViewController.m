//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ShoppingViewController.h"
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
#import "ShoppingCell.h"
#import "ShoppingDetailViewController.h"
#import "Banner.h"
#import "BannerImage.h"
#import "SVPullToRefresh.h"
#import "BannerView.h"
@interface ShoppingViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate>
{
    UIPageControl *pageControl;
    UILabel *title;
    float textHeight;
    NSMutableArray *shoppingItemArray;
    UIView *menuView;
    float lastContentOffset;
    NSTimer *timer;
    int page;
    BannerView *bannerView;
}

@end

@implementation ShoppingViewController

-(void)viewWillAppear:(BOOL)animated{
    if(!timer)
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if(self.collectionViewShopping.contentOffset.y >=[[Manager sharedManager]bannerHeight]){
        
        [menuView setFrame:CGRectMake(0,0, menuView.frame.size.width, menuView.frame.size.height)];
        
    }
    else{
        [menuView setFrame:CGRectMake(0,[[Manager sharedManager]bannerHeight]- scrollView.contentOffset.y, menuView.frame.size.width, menuView.frame.size.height)];
    }
    NSLog(@"content offset y :%f",scrollView.contentOffset.y);
    lastContentOffset =scrollView.contentOffset.y;
    
}
-(void)refreshPage{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getShopping\",\"params\":{\"page\":%d,\"limit\":12}}",++page];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"shopping"] ;
            
            for(NSDictionary* temp in content){
                
                ShoppingItem *preview = [[ShoppingItem alloc]initWithDictionary:temp];
                [shoppingItemArray addObject:preview];
                
            }
            
            
        }
        else{
            _collectionViewShopping.showsInfiniteScrolling = NO;
            page --;
        }
        
        [_collectionViewShopping.infiniteScrollingView stopAnimating];
        
        [_collectionViewShopping reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        
        [_collectionViewShopping.infiniteScrollingView stopAnimating];
        page--;
    }];
    [op start];
    
}

-(void)getListItem{
    page = 1;
    shoppingItemArray = [[NSMutableArray alloc]init];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getShopping\",\"params\":{\"page\":%d,\"limit\":12}}",1];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"shopping"] ;
            
            
            for(NSDictionary* temp in content){
                
                ShoppingItem* temp_shop = [[ShoppingItem alloc]initWithDictionary:temp];
                [shoppingItemArray addObject:temp_shop];
            }
            
            
        }
        
        
        [self.collectionViewShopping reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
}
-(void)getShoppingByID:(int)shoppingID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getShoppingById\",\"params\":{\"shoppingId\":%d}}",shoppingID];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            
            
            ShoppingItem* temp_shop = [[ShoppingItem alloc]initWithDictionary:result];
            
            
            ShoppingDetailViewController * articleView= [[ShoppingDetailViewController alloc]init];
            articleView.shoppingItem = temp_shop;
            
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
-(void)callSideBar:(id)sender{
    [self.frostedViewController presentMenuViewController];
}
-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdShopping]];
    
    
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
            
            [[Manager sharedManager] setBannerArrayShopping:bannerArray];
            bannerView.bannerArray = [[Manager sharedManager] bannerArrayShopping];
            [bannerView.carousel reloadData];
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
    [self getListItem];
    if(![[Manager sharedManager]bannerArrayShopping])
        [self getBanner];
    [self setCateID:SHOPPING];
    [Manager savePageView:6 orSubCate:0];
    
    NSString *string = [NSString stringWithFormat:@"Shopping"];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": string}];
    self.navigationItem.title = @"ช้อปปิ้ง";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_SHOPPING],
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
    menuView =[[UIView alloc]initWithFrame:CGRectMake(0, [[Manager sharedManager]bannerHeight], self.view.frame.size.width, 50)];
    [menuView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *buttonLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogin addTarget:self
                    action:@selector(clickLogin:)
          forControlEvents:UIControlEventTouchUpInside];
    [buttonLogin setTitle:@"เข้าสู่ระบบ" forState:UIControlStateNormal];
    buttonLogin.frame = CGRectMake(0, 0, 70, 30);
    [buttonLogin setTitleColor:[UIColor colorWithHexString:COLOR_SHOPPING] forState:UIControlStateNormal ];
    [buttonLogin.titleLabel setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:16]];
    [buttonLogin setTintColor:[UIColor colorWithHexString:COLOR_SHOPPING]];
    [menuView addSubview:buttonLogin];
    
    
    UIButton *buttonRegis = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRegis addTarget:self
                    action:@selector(clickRegister:)
          forControlEvents:UIControlEventTouchUpInside];
    [buttonRegis setTitle:@"สมัครสมาชิก" forState:UIControlStateNormal];
    buttonRegis.frame = CGRectMake(0, 0, 90, 30);
    [buttonRegis setTitleColor:[UIColor colorWithHexString:COLOR_SHOPPING] forState:UIControlStateNormal ];
    [buttonRegis.titleLabel setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:16]];
    [buttonRegis setTintColor:[UIColor colorWithHexString:COLOR_SHOPPING]];
    [menuView addSubview:buttonRegis];
    
    UIButton *buttonSale = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSale addTarget:self
                   action:@selector(clickSell:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonSale setTitle:@"ขาย" forState:UIControlStateNormal];
    buttonSale.frame = CGRectMake(0, 0, 40, 30);
    [buttonSale setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [buttonSale setBackgroundColor:[UIColor colorWithHexString:COLOR_SHOPPING]];
    [buttonSale.titleLabel setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:16]];
    [menuView addSubview:buttonSale];
    //[buttonSale sizeToFit];
    //[buttonRegis sizeToFit];
    // [buttonLogin sizeToFit];
    
    [buttonSale setFrame:CGRectMake(self.view.frame.size.width-buttonSale.frame.size.width-10, 10, buttonSale.frame.size.width, buttonSale.frame.size.height)];
    
    [buttonRegis setFrame:CGRectMake(buttonSale.frame.origin.x-buttonRegis.frame.size.width -10 ,10, buttonRegis.frame.size.width, buttonRegis.frame.size.height)];
    [buttonLogin setFrame:CGRectMake(buttonRegis.frame.origin.x-buttonLogin.frame.size.width-10, 10, buttonLogin.frame.size.width, buttonLogin.frame.size.height)];
    
    
    
    
    
    
    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
    
    _collectionViewShopping=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-60) collectionViewLayout:layout];
    
    [_collectionViewShopping setDataSource:self];
    [_collectionViewShopping setDelegate:self];
    
    [_collectionViewShopping registerClass:[UICollectionReusableView class]
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"BannerHeader"];
    [_collectionViewShopping registerClass:[UICollectionReusableView class]
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"RecommendedHeader"];
    UINib *cellNib = [UINib nibWithNibName:@"ShoppingCell" bundle:nil];
    [self.collectionViewShopping registerNib:cellNib forCellWithReuseIdentifier:@"ShoppingCell"];
    
    [_collectionViewShopping setBackgroundColor:[UIColor whiteColor]];
    
    __weak ShoppingViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [_collectionViewShopping addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.view addSubview:_collectionViewShopping];
    [self.view addSubview:menuView];
}
- (void)insertRowAtTop {
    
    __weak ShoppingViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage];
        [weakSelf.collectionViewShopping.infiniteScrollingView stopAnimating];
        
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
    if(bannerView.carousel)
        [bannerView.carousel scrollToItemAtIndex:bannerView.carousel.currentItemIndex+1 animated:YES];
    
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
        
        if(!bannerView)
            bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
        bannerView.backgroundColor = [UIColor clearColor];
        //_carousel.
        [headerView addSubview:bannerView];
        
        if([[Manager sharedManager] bannerArrayShopping]){
            bannerView.bannerArray =  [[Manager sharedManager]bannerArrayShopping];
        }
        else{
            bannerView.bannerArray =  [[Manager sharedManager]bannerArray];
        }
        [bannerView.carousel reloadData];
        
        return headerView;
        
    }
    return reusableview;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return shoppingItemArray.count;
    
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
    
    ShoppingCell *cell=(ShoppingCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ShoppingCell" forIndexPath:indexPath];
    NSString* imageFromURL;
    
    if(shoppingItemArray.count > indexPath.row){
        ShoppingItem* content = shoppingItemArray[indexPath.row];
        imageFromURL = content.images.imageThumbnailL;
        cell.title.text = content.titlePreview;
        cell.price.text = [NSString stringWithFormat:@"%.2f",content.price] ;
        cell.date.text = content.dateReadable;
        cell.address.text = content.address;
        [cell.price setTextColor:[UIColor colorWithHexString:COLOR_SHOPPING]];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:content.publishDate];
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDateComponents *componentsTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:content.publishDate];
        
        NSInteger hour = [componentsTime hour];
        NSInteger minute = [componentsTime minute];
        NSString* hoursString = [NSString stringWithFormat:@"%02li", (long)hour];
        NSString* minutesString = [NSString stringWithFormat:@"%02li", (long)minute];
        
        [cell.date setText: [NSString stringWithFormat:@"%ld/%ld/%ld เวลา %@:%@ น.", (long)day,(long)month,year+543,hoursString,minutesString]];
        
    }
    [cell.title sizeToFit];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageFromURL]
                          placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    }
    else{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageFromURL]
                          placeholderImage:[UIImage imageNamed:@"default_image_02_M.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    }
    
    
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
    float w_1 = (self.view.frame.size.width/2 -15);
    
    
    return CGSizeMake(w_1,w_1+142);
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingItem *temp = shoppingItemArray[indexPath.row];
    [self getShoppingByID:temp.shoppingID];
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

@end
