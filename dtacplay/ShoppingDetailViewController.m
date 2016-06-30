//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ShoppingDetailViewController.h"
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
#import "DetailShoppingItem.h"
#import "DWTagList.h"
#import "Banner.h"
#import "BannerImage.h"
#import "ShowImageViewController.h"
@interface ShoppingDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate,DWTagListDelegate,RTLabelDelegate>
{
    UIPageControl *pageControl;
    UIPageControl *pageControlShopping;
    UILabel *title;
    float textHeight;
    NSMutableArray *shoppingItemArray;
    UIView *menuView;
    float lastContentOffset;
    UIView *cellShoppingView;
    NSTimer *timer;
    
    UIImageView *bottomImage;
    NSURL *linkBanner;
    NSString* detailCredit;
}
@property (nonatomic, strong) NSMutableArray        *array;
@property (nonatomic, strong) DWTagList             *tagList;
@end

@implementation ShoppingDetailViewController

-(void)getShoppingItem{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if(self.collectionView.contentOffset.y >=[[Manager sharedManager]bannerHeight]){
        
        [menuView setFrame:CGRectMake(0,0, menuView.frame.size.width, menuView.frame.size.height)];
        
    }
    else{
        [menuView setFrame:CGRectMake(0,[[Manager sharedManager]bannerHeight]-scrollView.contentOffset.y, menuView.frame.size.width, menuView.frame.size.height)];
    }
    NSLog(@"content offset y :%f",scrollView.contentOffset.y);
    lastContentOffset =scrollView.contentOffset.y;
    
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
    [self setCateID:SHOPPING];
     if(![[Manager sharedManager]bannerArrayShopping])
         [self getBanner];
    
     [self getBannerCredit:42];
    
    NSString *string = [NSString stringWithFormat:@"Shopping - %@",_shoppingItem.title];
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
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-60) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"BannerHeader"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"RecommendedHeader"];
    
    
   [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageProduct"] ;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ItemDetail"] ;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"TagList"] ;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BannerBottom"] ;
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:menuView];
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
    
    if(NSTimer == timer)
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
        pageControl.numberOfPages = [[Manager sharedManager] bannerArrayShopping].count >0  ? [[Manager sharedManager] bannerArrayShopping].count : [[Manager sharedManager] bannerArray].count;
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
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;   
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
   
        UIEdgeInsets inset = UIEdgeInsetsMake(10,0,0,0);
        return inset;
    }
    else if(section == 1){
    
        UIEdgeInsets inset = UIEdgeInsetsMake(0,10,15,10);
        return inset;
    }

    UIEdgeInsets inset = UIEdgeInsetsMake(00,10,15,10);
    return inset;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
    NSString *identify = @"ImageProduct";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
   
    if ( IDIOM == IPAD ) {
        _shoppingCarousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 444 )];
    }
    else{
        _shoppingCarousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 280 )];
    }
        UIView *black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, _shoppingCarousel.frame.size.height)];
        
        [black setBackgroundColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        
        [cell addSubview:black];
    _shoppingCarousel.delegate = self;
    _shoppingCarousel.dataSource = self;
    _shoppingCarousel.type = iCarouselTypeLinear;
    _shoppingCarousel.backgroundColor = [UIColor clearColor];
    //_carousel.
    [black addSubview:_shoppingCarousel];
    
    
    
    
    // Page Control
    if(!pageControlShopping)
        pageControlShopping = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (black.frame.size.height-20), _shoppingCarousel.frame.size.width, 20.0f)];
    pageControlShopping.numberOfPages = _shoppingItem.imageThumbName.count;
    pageControlShopping.currentPage = 0;
    pageControlShopping.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    pageControlShopping.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    pageControlShopping.userInteractionEnabled = NO;
    [black addSubview:pageControlShopping];

    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.layer.shadowRadius = 2;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
   [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
    
    return cell;
    }
    else if(indexPath.section == 1){
        NSString *identify = @"ItemDetail";
        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

        [cell addSubview:cellShoppingView];
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
        [cell setUserInteractionEnabled:YES];
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        return cell;
    }
    else if(indexPath.section ==2){
        NSString *identify = @"TagList";
        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        [cell addSubview:bottomImage];
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    else{
        NSString *identify = @"BannerBottom";
        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [img setImage:[UIImage imageNamed:@"default_image_01_L.jpg"]];
        
        [cell addSubview:img];
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_1 = (self.view.frame.size.width);
    float w_1_ipad = (self.view.frame.size.width);
    if(indexPath.section == 0){
    
    if ( IDIOM == IPAD ) {
        
        return CGSizeMake(w_1_ipad-20,444);
    }
    
    return CGSizeMake(w_1-20,300);
    
    }
    else if(indexPath.section == 1){
        
        cellShoppingView = [[UIView alloc]init];
        ShoppingItem *temp = _shoppingItem;
        
        UIFont *font = [UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14];
        UIColor *bgColor =[UIColor colorWithHexString:BLOCK_COLOR];
        
        float cell_width = w_1;
        UIView *view_1  = [[UIView alloc]initWithFrame:CGRectMake(10, 20,cell_width-40 , 200)];
        [view_1 setBackgroundColor:[UIColor whiteColor]];
        
        [cellShoppingView addSubview:view_1];
        
        UIImageView *iconShopping = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [iconShopping setImage:[UIImage imageNamed:@"dtacplay_home_shopping" ]];
        
        [view_1 addSubview:iconShopping];
        
        UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(5, 40, view_1.frame.size.width-10, 1)];
        [line_1 setBackgroundColor:bgColor];
        
        [view_1 addSubview:line_1];
        
        UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, view_1.frame.size.width-50, 30)];
        [labelPrice setText:[NSString stringWithFormat:@"%.2f",temp.price ]];
        [labelPrice setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR ]];
        [labelPrice setFont:font];
        [view_1 addSubview:labelPrice];
        
        //--------///
        float y= line_1.frame.size.height+line_1.frame.origin.y;
        UIImageView *iconPhone = [[UIImageView alloc]initWithFrame:CGRectMake(5,y+5, 30, 30)];
        [iconPhone setImage:[UIImage imageNamed:@"dtacplay_shopping_phone" ]];
        
        [view_1 addSubview:iconPhone];
        
        UIView *line_2 = [[UIView alloc] initWithFrame:CGRectMake(5, y+40, view_1.frame.size.width-10, 1)];
        [line_2 setBackgroundColor:bgColor];
        
        [view_1 addSubview:line_2];
        
        UILabel *labelPhone = [[UILabel alloc]initWithFrame:CGRectMake(40,y+ 5, view_1.frame.size.width-50, 30)];
        [labelPhone setText:temp.telephone];
        [labelPhone setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR ]];
        [labelPhone setFont:font];
        [view_1 addSubview:labelPhone];
        [cellShoppingView setBackgroundColor:bgColor];
        
        //--------////
        
        y= line_2.frame.size.height+line_2.frame.origin.y;
        UIImageView *iconPerson = [[UIImageView alloc]initWithFrame:CGRectMake(5,y+5, 30, 30)];
        [iconPerson setImage:[UIImage imageNamed:@"dtacplay_shopping_person" ]];
        
        [view_1 addSubview:iconPerson];
        
        UIView *line_3 = [[UIView alloc] initWithFrame:CGRectMake(5, y+40, view_1.frame.size.width-10, 1)];
        [line_3 setBackgroundColor:bgColor];
        
        [view_1 addSubview:line_3];
        
        UILabel *labelPerson = [[UILabel alloc]initWithFrame:CGRectMake(40,y+ 5, view_1.frame.size.width-50, 30)];
        [labelPerson setText:temp.memberName];
        [labelPerson setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR ]];
        [labelPerson setFont:font];
        [view_1 addSubview:labelPerson];
        
        [view_1 setFrame:CGRectMake(10, 20,cell_width-40 , y+40)];
        
        //veiw 2 ------ //
        
        UIView *view_2  = [[UIView alloc]initWithFrame:CGRectMake(10, view_1.frame.size.height+view_1.frame.origin.y+10,cell_width-40 , 200)];
        [view_2 setBackgroundColor:[UIColor whiteColor]];
        
        [cellShoppingView addSubview:view_2];
        
        UIImageView *iconAddress = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [iconAddress setImage:[UIImage imageNamed:@"dtacplay_shopping_location" ]];
        
        [view_2 addSubview:iconAddress];
        
        line_1 = [[UIView alloc] initWithFrame:CGRectMake(5, 40, view_1.frame.size.width-10, 1)];
        [line_1 setBackgroundColor:bgColor];
        
        [view_2 addSubview:line_1];
        
        UILabel *labelAddress = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, view_1.frame.size.width-50, 30)];
        [labelAddress setText:temp.address];
        [labelAddress setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR ]];
        [labelAddress setFont:font];
        [view_2 addSubview:labelAddress];
        
        ////-------///
        
        y= line_1.frame.size.height+line_1.frame.origin.y;
        
        UIImageView *iconTime = [[UIImageView alloc]initWithFrame:CGRectMake(5, y+5, 30, 30)];
        [iconTime setImage:[UIImage imageNamed:@"dtacplay_shopping_time" ]];
        
        [view_2 addSubview:iconTime];
        
        line_1 = [[UIView alloc] initWithFrame:CGRectMake(5, y+40, view_1.frame.size.width-10, 1)];
        [line_1 setBackgroundColor:bgColor];
        
        [view_2 addSubview:line_1];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:temp.publishDate];
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDateComponents *componentsTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:temp.publishDate];
        
        NSInteger hour = [componentsTime hour];
        NSInteger minute = [componentsTime minute];
        NSString* hoursString = [NSString stringWithFormat:@"%02li", (long)hour];
        NSString* minutesString = [NSString stringWithFormat:@"%02li", (long)minute];
        
        UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(40, y+5, view_1.frame.size.width-50, 30)];
        [labelTime setText:[NSString stringWithFormat:@"%ld/%ld/%ld เวลา %@:%@ น.", (long)day,(long)month,year+543,hoursString,minutesString]];
        [labelTime setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR ]];
        [labelTime setFont:font];
        [view_2 addSubview:labelTime];
        
        [view_2 setFrame:CGRectMake(10, view_2.frame.origin.y,cell_width-40 , y+40)];
        
        
        ///view 3
        
        UIView *view_3  = [[UIView alloc]initWithFrame:CGRectMake(10, view_2.frame.size.height+view_2.frame.origin.y+10,cell_width-40 , 200)];
        [view_3 setBackgroundColor:[UIColor whiteColor]];
        
        [cellShoppingView addSubview:view_3];
        
        UIImageView *iconInfo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [iconInfo setImage:[UIImage imageNamed:@"dtacplay_shopping_number" ]];
        
        [view_3 addSubview:iconInfo];
        
        line_1 = [[UIView alloc] initWithFrame:CGRectMake(5, 40, view_1.frame.size.width-10, 1)];
        [line_1 setBackgroundColor:bgColor];
        
        [view_3 addSubview:line_1];
        
        UILabel *labelAccount = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, view_1.frame.size.width-50, 30)];
        [labelAccount setText:[NSString stringWithFormat:@"%d",temp.shoppingID ]];
        [labelAccount setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR ]];
        [labelAccount setFont:font];
        [view_3 addSubview:labelAccount];
        
        ////-------///
        
        y= line_1.frame.size.height+line_1.frame.origin.y;
        
        UIImageView *iconEye = [[UIImageView alloc]initWithFrame:CGRectMake(5, y+5, 30, 30)];
        [iconEye setImage:[UIImage imageNamed:@"dtacplay_shopping_eye" ]];
        
        [view_3 addSubview:iconEye];
        
        line_1 = [[UIView alloc] initWithFrame:CGRectMake(5, y+40, view_1.frame.size.width-10, 1)];
        [line_1 setBackgroundColor:bgColor];
        
        [view_3 addSubview:line_1];
        
        UILabel *labelEye = [[UILabel alloc]initWithFrame:CGRectMake(40, y+5, view_1.frame.size.width-50, 30)];
        [labelEye setText:[NSString stringWithFormat:@"เข้าชม :%d",temp.pageCount]];
        [labelEye setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR ]];
        [labelEye setFont:font];
        [view_3 addSubview:labelEye];
        
        [view_3 setFrame:CGRectMake(10, view_3.frame.origin.y,cell_width-40 , y+40)];
        
        //// description
        
        RTLabel *textView = [[RTLabel alloc]initWithFrame:CGRectMake(10,view_3.frame.size.height+view_3.frame.origin.y+10,cell_width-40, 1000)];
        
        //textView.delegate = self;
        textView.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
        textView.backgroundColor = [UIColor clearColor];
      
        // UIFont *test = textView.font;//time news roman 12 pixel
        [textView setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM==IPAD ? 18: 16]];
        textView.tag =80;
        [textView setText:temp.title];
        //textView.text = para.descriptionContent;
        [textView setNeedsDisplay];
        
        [textView setFrame:CGRectMake(10, textView.frame.origin.y, textView.frame.size.width, textView.optimumSize.height)];
        [cellShoppingView addSubview:textView];
        
        // detail
        
        RTLabel *textDetail = [[RTLabel alloc]initWithFrame:CGRectMake(10,textView.frame.size.height+textView.frame.origin.y+10,cell_width-40, 1000)];
        [textDetail setDisableSingleLine:YES];
        
        
        textDetail.delegate = self;
        textDetail.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
        textDetail.backgroundColor = [UIColor clearColor];
        textDetail.userInteractionEnabled = YES;
        // UIFont *test = textView.font;//time news roman 12 pixel
        [textDetail setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 16: 14]];
        textDetail.tag =80;
        
        [textDetail setText:[NSString stringWithFormat:@"%@ \n %@", temp.detail,detailCredit == nil ? @"" : detailCredit]];
        //textView.text = para.descriptionContent;
        [textDetail setNeedsDisplay];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(clickLink:)];
        [self.view addGestureRecognizer:singleFingerTap];
        
        [textDetail setFrame:CGRectMake(10, textDetail.frame.origin.y, textDetail.frame.size.width, textDetail.optimumSize.height)];
        [cellShoppingView addSubview:textDetail];
        
        [cellShoppingView setFrame:CGRectMake(0, 0, cell_width-20, textDetail.frame.size.height+textDetail.frame.origin.y+10)];
        
        return CGSizeMake(w_1-20,cellShoppingView.frame.size.height);
    }
    else if(indexPath.section == 2){
      
            if(!bottomImage)
            bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,  w_1-20, (200*(w_1-20))/940)];
        
            [bottomImage setContentMode:UIViewContentModeScaleAspectFit];
        
    
        
        return CGSizeMake(w_1-20,bottomImage.frame.size.height);
    }
    else{

        return CGSizeMake(w_1-20,((w_1-20)*200)/940);
    }
}

- (void)getBannerCredit:(int)feedID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",_shoppingItem.smrtAdsRefId];
    
    
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

            if(detail)
                detailCredit = [Manager returnSupporter:0 :detail : link ];
            [_collectionView reloadData];

            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imageURL]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression   code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        if(!bottomImage){
                                            bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width-20, (200*(self.view.frame.size.width-20))/940)];
                                        }
                                        [bottomImage setImage:image];
                                        [bottomImage setUserInteractionEnabled:YES];
                                        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
                                        
                                        singleTap.numberOfTapsRequired = 1;
                                        singleTap.numberOfTouchesRequired = 1;
                                        [bottomImage addGestureRecognizer: singleTap];
                                        [self.collectionView reloadData];
                                        
                                    }
                                    else{
                                        [bottomImage setImage:nil];
                                    }
                                    
                                    
                                }];
            
            
            
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        
    }];
    [op start];
}
-(void) handleSingleTap:(UITapGestureRecognizer *)gr {
    if(linkBanner)
        [[UIApplication sharedApplication] openURL:linkBanner];
}
- (void)clickLink:(UITapGestureRecognizer *)recognizer {
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kaidee.com/categories/?utm_source=dtac&utm_medium=dtacplay&utm_campaign=category-button/"]];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ///
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"did select url %@", url);
    [[UIApplication sharedApplication] openURL:url];
    //    DtacWebViewViewController *webViewDtac = [[DtacWebViewViewController alloc]init];
    //    webViewDtac.url = url;
    //    webViewDtac.themeColor = self.themeColor;
    //    webViewDtac.titlePage = self.titlePage;
    //    UIBarButtonItem *newBackButton =
    //    [[UIBarButtonItem alloc] initWithTitle:@" "
    //                                     style:UIBarButtonItemStyleBordered
    //                                    target:nil
    //                                    action:nil];
    //    [self.navigationItem setBackBarButtonItem:newBackButton];
    //    [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    //    [self.navigationController pushViewController:webViewDtac animated:YES];
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
    if(carousel == _carousel)
    {
        if([[Manager sharedManager] bannerArrayShopping]){
            return [[Manager sharedManager]bannerArrayShopping].count;
        }
        else{
            return [[Manager sharedManager]bannerArray].count;
        }
    }
    
    return _shoppingItem.imageName.count;
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
    if(_carousel == carousel)
        pageControl.currentPage = self.carousel.currentItemIndex;
    else
        pageControlShopping.currentPage = self.shoppingCarousel.currentItemIndex;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(carousel == _carousel){
        UIImageView *viewsImage = [[UIImageView alloc] initWithFrame:_carousel.frame];
        Banner *temp  = [[Manager sharedManager] bannerArray ][index];
        
        if([[Manager sharedManager] bannerArrayShopping]){
            temp  = [[Manager sharedManager] bannerArrayShopping ][index];
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
    else{
        UIImageView *views = [[UIImageView alloc] initWithFrame:_shoppingCarousel.frame];

        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:_shoppingItem.imageThumbName[index]]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    views.image = image;
                                }
                                
                                
                                
                            }];

        [views setContentMode:UIViewContentModeScaleAspectFit];
        return views;
    }
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
    if(_carousel == carousel){
        Banner *temp  = [[Manager sharedManager] bannerArray ][index];
        
        if([[Manager sharedManager] bannerArrayShopping]){
            temp  = [[Manager sharedManager] bannerArrayDownload ][index];
        }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
        
    }else{
        ShowImageViewController* showImage= [[ShowImageViewController alloc]init];
        showImage.allImageArray = _shoppingItem.imageName;
        showImage.index = (int)index;
        showImage.titlePage = _shoppingItem.title;
        showImage.themeColor = [UIColor colorWithHexString:COLOR_SHOPPING];
        showImage.cate = SHOPPING;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
        [self.navigationController pushViewController:showImage animated:NO];
    }
}

@end
