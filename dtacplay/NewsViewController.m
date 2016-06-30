//
//  COLOR_NEWS
//  dtacplay
//
//  Created by attaphon on 10/25/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "NewsViewController.h"

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
#import "OilObject.h"
#import "GoldObject.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "Manager.h"
#import "Banner.h"
#import "BannerImage.h"
#import "LotteryObject.h"
#import "LotteryCellCollectionViewCell.h"
@interface NewsViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *sizeArray;
    
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
    
    NSMutableArray *oilArray;
    NSMutableArray *GoldArray;
    
    MBProgressHUD *hudRefresh;
    NSTimer *timer;
    
    NSMutableArray *lotteryArray;
    
    int lastStatPage;;
   
}
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation NewsViewController
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

-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdNews]];
    
    
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
            
            [[Manager sharedManager] setBannerArrayNews:bannerArray];
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayNews].count;
            [_carousel reloadData];
           // [self.collectionView reloadData];
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
    }];
    [op start];
    
    
}


-(void)refreshPage:(int)current{
    int number = [pageArray[current] intValue];
    number = number + 1;
    pageArray[current] = [NSNumber numberWithInt:number];
    
    SubCategorry subcate = [self.nameMenu[current] intValue] ;
//    switch (current) {
//        case 0:
//            subcate = NEWS_HOT_NEWS;
//            break;
//        case 1:
//            subcate = NEWS_INTER_NEWS;
//            break;
//        case 2:
//            subcate = NEWS_FINANCE;
//            break;
//        case 3:
//            subcate = NEWS_TECHNOLOGY;
//            break;
//        case 4:
//            subcate = NEWS_LOTTO;
//            break;
//            //        case 4:
//            //            subcate = NEWS_GAS_PRICE;
//            //            break;
//            //        case 5:
//            //            subcate = NEWS_GOLD_PRICE;
//            //            break;
//            //
//        default:
//            subcate = NEWS_HOT_NEWS;
//            break;
//    }
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%ld, \"page\":%d,\"limit\":14 }}",(long)subcate,number];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [NSString stringWithFormat:@"%d",current] , @"page",nil];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int page = [[operation.userInfo objectForKey:@"page"] intValue];
        UICollectionView *collectionView = collectionViewArray[page];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;//subCateId
            
            NSMutableArray *objectArray = allObjectArray[page];
            NSMutableArray *tempArray = objectArray[0];
            
            
            for(NSDictionary* temp in content){
                
                ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                [tempArray addObject:preview];
                
            }
            
            
        }
        else{
            
            
            collectionView.showsInfiniteScrolling = NO;
            int number = [pageArray[page] intValue];
            number = number - 1;
            pageArray[page] = [NSNumber numberWithInt:number];
        }
        
        
        [collectionView.infiniteScrollingView stopAnimating];
        
        [collectionView reloadData];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        int page = [[operation.userInfo objectForKey:@"page"] intValue];
        NSLog(@"JSON responseObject: %@ ",error);
        UICollectionView *collectionView = collectionViewArray[page];
        
        [collectionView.infiniteScrollingView stopAnimating];
        
        int number = [pageArray[page] intValue];
        number = number - 1;
        pageArray[page] = [NSNumber numberWithInt:number];
        
    }];
    [op start];
}
-(void)GetContentNEWS:(int)index AndSubcate:(int)subcate{

//    switch (index) {
//        case 0:
//            subcate = NEWS_HOT_NEWS;
//            break;
//        case 1:
//            subcate = NEWS_INTER_NEWS;
//            break;
//        case 2:
//            subcate = NEWS_FINANCE;
//            break;
//        case 3:
//            subcate = NEWS_TECHNOLOGY;
//            break;
//        case 4:
//            subcate = NEWS_LOTTO;
//            break;
//        case 5:
//            subcate = NEWS_GAS_PRICE;
//            break;
//        case 6:
//            subcate = NEWS_GOLD_PRICE;
//            break;
//            
//        default:
//            subcate = NEWS_HOT_NEWS;
//            break
//            ;
//    }
    
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%ld, \"page\":%d,\"limit\":14 }}",(long)subcate,1];
    
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
            
            NSMutableArray *objectArray = [[NSMutableArray alloc]init];
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
           // int smrtAdsRefId = [[result objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null] ] ? 0 : [[result objectForKey:@"smrtAdsRefId"]intValue];
            
            NSMutableArray*  tempArray ;
            
            tempArray = [[NSMutableArray alloc]init];
            
            for(NSDictionary* temp in content){
                
                ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                [tempArray addObject:preview];
                
                
            }
            
            [objectArray addObject:tempArray];
            
            
            allObjectArray[index] = objectArray;
            
        }
        
        
        [self.collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
}
-(void)getOilAndGasPrice{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getOilPrice\",\"params\":{ \"stationId\":1 }}"];
    
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
            oilArray = [[NSMutableArray alloc]init];
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            for(NSDictionary* oil in result){
                OilObject *temp = [[OilObject alloc]initWithDictionary:oil];
                [oilArray addObject:temp];
            }
            
            
        }
        [self.collectionView reloadData];
        
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGoldPrice\"}"];
    
    NSString *valueHeader2;
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud2 setColor:[UIColor whiteColor]];
    [hud2 setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    NSMutableURLRequest *requestHTTP2 = [Manager createRequestHTTP:jsonString cookieValue:valueHeader2];
    AFHTTPRequestOperation *op2 = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP2];
    
    op2.responseSerializer = [AFJSONResponseSerializer serializer];
    [op2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud2 hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            GoldArray = [[NSMutableArray alloc]init];
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            
            GoldObject *temp = [[GoldObject alloc]initWithDictionary:result];
            [GoldArray addObject:temp];
            
            
            
        }
        
        
        [self.collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud2 hide:YES];
    }];
    [op2 start];
    
    
    
}

-(void)getLottery{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getLotto\"}"];
    
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
            lotteryArray = [[NSMutableArray alloc]init];
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
             NSArray *array =[result objectForKey:@"lotto"] ;
            for(NSDictionary* lottery in array){
                LotteryObject *temp = [[LotteryObject alloc]initWithDictionary:lottery];
                [lotteryArray addObject:temp];
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
-(void)setup{
    allObjectArray = [[NSMutableArray alloc]init];
    pageArray = [[NSMutableArray alloc]init];
    lastStatPage = self.indexPage ;
    [Manager savePageView:1 orSubCate:0];

    for (int i = 0; i < self.nameMenu.count; i++) {
        [allObjectArray addObject:[[NSMutableArray alloc]init]];
        [pageArray addObject:[NSNumber numberWithInt:1]];
    }
    
    for (int i = 0; i < self.nameMenu.count; i++) {
       
        if([self.nameMenu[i] intValue] != NEWS_LOTTERRY ||[self.nameMenu[i] intValue] != NEWS_GAS_PRICE  || [self.nameMenu[i] intValue] == NEWS_GOLD_PRICE){
            [self GetContentNEWS:i AndSubcate:[self.nameMenu[i] intValue]];
        }
        
    }

    [self getLottery];
    [self getOilAndGasPrice];
    //initial submenu
    menuArray = self.nameMenu;
    
    totalPage = (int)menuArray.count;
    
    indicatorMenu = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 2.5 )];
    [indicatorMenu setBackgroundColor:_themeColor];
    
    collectionViewArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i<menuArray.count; i++) {
        
        sizeArray = [[NSMutableArray alloc]init];
        MyFlowLayout *layout=[[MyFlowLayout alloc] init];
        
        UICollectionView *fooCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-110) collectionViewLayout:layout];
        
        fooCollection.tag = i;
        [fooCollection setDataSource:self];
        [fooCollection setDelegate:self];
        [fooCollection registerClass:[DtacPlayBlockCollectionViewCell class] forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
        if([self.nameMenu[i] intValue] == NEWS_GAS_PRICE){
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GasDateCell"];
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GasContentCell"];
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SpaceCell"];
        }
        else if([self.nameMenu[i] intValue] == NEWS_GOLD_PRICE){
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GoldDateCell"];
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GoldContentCell"];
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SpaceCell"];
        }
        else if([self.nameMenu[i] intValue] == NEWS_LOTTERRY){
            UINib *nib = [UINib nibWithNibName:@"LotteryCellCollectionViewCell" bundle:nil];
            [fooCollection registerNib:nib forCellWithReuseIdentifier:@"LotteryCell"];
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SpaceCell"];
        }
        else if([self.nameMenu[i] intValue] == NEWS_WIKI ){
          
            [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SpaceCell"];
        }
        [fooCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        //            UINib *cellNib = [UINib nibWithNibName:@"BlockCollectionViewCell" bundle:nil];
        //            [fooCollection registerNib:cellNib forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
        [fooCollection setBackgroundColor:[UIColor clearColor]];
        
        [fooCollection scrollsToTop];
        
        [fooCollection addSubview:iconHeader];
        [collectionViewArray addObject:fooCollection];
        
        if(self.indexPage == i){
            self.collectionView =fooCollection;
            __weak NewsViewController *weakSelf = self;
            
            // setup pull-to-refresh
            [fooCollection addInfiniteScrollingWithActionHandler:^{
                [weakSelf insertRowAtTop];
            }];
        }
        
    }
    
    
    
}
- (void)insertRowAtTop {
    int current = _swipeView.currentItemIndex;
    __weak NewsViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage:current];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setCateID:NEWS];
    if(![[Manager sharedManager]bannerArrayNews])
        [self getBanner];
    // [Manager savePageView:1];
    //
    //    for (int i = 0 ; i <50; i++) {
    //        NSInteger randomNumber = arc4random() %1000000;
    //        NSLog(@"%d",randomNumber);
    //    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _themeColor = [UIColor colorWithHexString:COLOR_NEWS];
    self.navigationItem.title = [Manager getCateName:NEWS withThai:YES];
    
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
    
    //[self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:NEWS withSubCate:self.subeType :nil]}];
    
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.swipeView setBackgroundColor:[UIColor clearColor]];
    _swipeView.pagingEnabled = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    [self.view addSubview:_swipeView];
    
    
    imageHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
    
    
    
    imageHeader.clipsToBounds = YES;
    imageHeaderColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeader.frame.size.height )];
    
    
    if(!_carousel)
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageHeader.frame.size.width, imageHeader.frame.size.height)];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    _carousel.backgroundColor = [UIColor clearColor];
    //_carousel.
    [imageHeader addSubview:_carousel];
    
    
    
    
    // Page Control
    if(!pageControl)
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (self.carousel.frame.size.height-20), self.carousel.frame.size.width, 20.0f)];
    pageControl.numberOfPages = [[Manager sharedManager] bannerArrayNews].count >0  ? [[Manager sharedManager] bannerArrayNews].count : [[Manager sharedManager] bannerArray].count;
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    pageControl.userInteractionEnabled = NO;
    [_carousel addSubview:pageControl];
    [timer invalidate];
    timer = nil;
    timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                              target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
    
    
    //            imageHeaderImage = [[JBKenBurnsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300 )];
    //            [imageHeaderImage animateWithImages:@[[UIImage imageNamed:@"banner_dtacplay.png"]]
    //                             transitionDuration:50
    //                                   initialDelay:0
    //                                           loop:YES
    //                                    isLandscape:YES];
    
    [_swipeView addSubview:imageHeader];
    
    
    if(IDIOM == IPAD){
        menuView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, imageHeader.frame.origin.y+imageHeader.frame.size.height,self.view.frame.size.width, 55)];
        
    }
    else{
        menuView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, imageHeader.frame.origin.y+imageHeader.frame.size.height,self.view.frame.size.width, 55)];
        
    }
    
    menuHeight = menuView.frame.size.height;
    posTopCollectionView = menuView.frame.origin.y;
    self.lastContentOffset = 0;
    menuPosition = menuView.frame.origin.y;
    [menuView setBackgroundColor:[UIColor whiteColor]];
    
    
    buttonArray = [[NSMutableArray alloc]init];
    float x= 10;
    BOOL first = YES;
    for (int i = 0; i< menuArray.count; i++) {
        NSString* nameMenu = [Manager getSubcateName:[self.nameMenu[i]  intValue] withThai:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button addTarget:self
                   action:@selector(menuPress:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%@",nameMenu ] forState:UIControlStateNormal];
        
        [button setTintColor:_themeColor];
        UIFont *myFont = [UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM==IPAD ? 21: 16];
        button.titleLabel.font = myFont;
        CGSize textSize = [[NSString stringWithFormat:@"%@",nameMenu ]  sizeWithAttributes:@{NSFontAttributeName:myFont}];
        
        button.frame = CGRectMake(x, 0.0, textSize.width, menuView.frame.size.height-10);
        if(self.indexPage == i){
            [indicatorMenu setFrame:CGRectMake(button.frame.origin.x, button.frame.size.height-5, button.frame.size.width,2.5)];
            //first = NO;
            [menuView addSubview:indicatorMenu];
        }
        button.tag = i;
        x += button.frame.size.width+20;
        [menuView addSubview:button];
        [buttonArray addObject:button];
    }
    [menuView setContentSize:CGSizeMake(x, menuView.frame.size.height)];
    
    isChangeCollection = NO;
    [self.view addSubview:menuView];
    
    
    UIButton *button = buttonArray[self.indexPage];
    
    [indicatorMenu setFrame:CGRectMake(button.frame.origin.x, button.frame.size.height-5,  button.frame.size.width, 2.5)];
    
    float w = menuView.frame.size.width;
    float h = menuView.frame.size.height;
    
    CGRect toVisible = CGRectMake(button.frame.origin.x-self.view.frame.size.width/2+button.frame.size.width/2, 0, w, h);
    [menuView scrollRectToVisible:toVisible animated:YES];
    _swipeView.currentPage = self.indexPage;
    currentPage = self.indexPage;
    inmediatelyIndex = self.indexPage;

    
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
   if( [self.nameMenu[collectionView.tag] intValue]== NEWS_WIKI  ||[self.nameMenu[collectionView.tag] intValue]== NEWS_FINANCE || [self.nameMenu[collectionView.tag] intValue]== NEWS_HOT_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_INTER_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTO || [self.nameMenu[collectionView.tag] intValue]== NEWS_TECHNOLOGY ){
        NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
        return object.count;
    }
   else if([self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTERRY){
       return lotteryArray.count;
   }else{
        return 1;
    }
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.nameMenu[collectionView.tag] intValue]== NEWS_WIKI ||[self.nameMenu[collectionView.tag] intValue]== NEWS_FINANCE || [self.nameMenu[collectionView.tag] intValue]== NEWS_HOT_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_INTER_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTO || [self.nameMenu[collectionView.tag] intValue]== NEWS_TECHNOLOGY ){
        NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
        NSMutableArray *temp = object.count>0 ? object[section] : nil;//collectionView.tag
        return temp.count;
    }else if([self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTERRY){
        return 1;
    }
    else{
        return 2;
    }
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if([self.nameMenu[collectionView.tag] intValue]== NEWS_WIKI ||[self.nameMenu[collectionView.tag] intValue]== NEWS_FINANCE || [self.nameMenu[collectionView.tag] intValue]== NEWS_HOT_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_INTER_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTO || [self.nameMenu[collectionView.tag] intValue]== NEWS_TECHNOLOGY ){
        
        return 10;
    }
    else{
        return 0;
    }
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if([self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTERRY){
        
        if(section == 0){
            
            UIEdgeInsets inset = UIEdgeInsetsMake(posTopCollectionView+10,10,0,10);
            return inset;
            
        }
        else{
            
            UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
            return inset;
        }
    }
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
    if([self.nameMenu[collectionView.tag] intValue]== NEWS_FINANCE || [self.nameMenu[collectionView.tag] intValue]== NEWS_HOT_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_INTER_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTO || [self.nameMenu[collectionView.tag] intValue]== NEWS_TECHNOLOGY ){
        
        
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        ContentPreview *articleTemp = tempArray[indexPath.row];
        NSLog(@"%@",articleTemp.title);
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
        
        return cell;
    }
    else if([self.nameMenu[collectionView.tag] intValue]== NEWS_WIKI  ){
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        ContentPreview *articleTemp = tempArray[indexPath.row];
        
        if(indexPath.row == 0){
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
        
        return cell;
        }else{
        
                NSString *identify = @"SpaceCell";
                UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                return cell;
            
        }
    }
    else if([self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTERRY){
         NSString *identify = @"LotteryCell";
        LotteryCellCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        LotteryObject *obj = lotteryArray[indexPath.section];
        NSLog(@"%@",obj.title);
        
        if(indexPath.section == 1){
            [cell.line setHidden:YES];
        }
        [cell.line setBackgroundColor:[UIColor colorWithHexString:COLOR_NEWS]];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:0];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
        
        
        cell.layer.masksToBounds = NO;
        
        cell.view1.layer.masksToBounds = NO;
        cell.view1.layer.shadowOffset = CGSizeMake(2, 2);
        cell.view1.layer.shadowRadius = 2;
        cell.view1.layer.shadowOpacity = 0.5;
        cell.view1.layer.shouldRasterize = YES;
        cell.view1.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        cell.view2.layer.masksToBounds = NO;
        cell.view2.layer.shadowOffset = CGSizeMake(2, 2);
        cell.view2.layer.shadowRadius = 2;
        cell.view2.layer.shadowOpacity = 0.5;
        cell.view2.layer.shouldRasterize = YES;
        cell.view2.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        cell.view3.layer.masksToBounds = NO;
        cell.view3.layer.shadowOffset = CGSizeMake(2, 2);
        cell.view3.layer.shadowRadius = 2;
        cell.view3.layer.shadowOpacity = 0.5;
        cell.view3.layer.shouldRasterize = YES;
        cell.view3.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        cell.view4.layer.masksToBounds = NO;
        cell.view4.layer.shadowOffset = CGSizeMake(2, 2);
        cell.view4.layer.shadowRadius = 2;
        cell.view4.layer.shadowOpacity = 0.5;
        cell.view4.layer.shouldRasterize = YES;
        cell.view4.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        cell.title.text = obj.title;
        cell.number_1.text = obj.number1;
        cell.reward_1.text = [NSString stringWithFormat:@"รางวัลละ %@ บาท",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:obj.reward1]]];
        
        cell.number_3_back.text = [obj.numberLast3 stringByReplacingOccurrencesOfString:@" "
                                                                 withString:@" | "];
        cell.reward_3_back.text = [NSString stringWithFormat:@"รางวัลละ %@ บาท",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:obj.rewardLast3]]];
        
        cell.number_3_front.text = [obj.numberFirst3 stringByReplacingOccurrencesOfString:@" "
                                                                              withString:@" | "];
        cell.reward_3_front.text = [NSString stringWithFormat:@"รางวัลละ %@ บาท",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:obj.rewardFirst3]]];
        
        cell.number_2.text = obj.numberLast2;
        cell.reward_2.text = [NSString stringWithFormat:@"รางวัลละ %@ บาท",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:obj.rewardLast2]]];
        return cell;
    }
    else{
        if([self.nameMenu[collectionView.tag] intValue] ==  NEWS_GAS_PRICE){
            if(indexPath.row == 0){
                OilObject *object = oilArray[0];
                if(object){
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:object.publicDate];
                    NSInteger day = [components day];
                    NSInteger month = [components month];
                    NSInteger year = [components year];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    //[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                    
                    NSDateComponents *componentsTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:object.publicDate];
                    NSInteger hour = [componentsTime hour];
                    NSInteger minute = [componentsTime minute];
                    NSString* hoursString = [NSString stringWithFormat:@"%02li", (long)hour];
                    NSString* minutesString = [NSString stringWithFormat:@"%02li", (long)minute];
                    
                    NSString *identify = @"GasContentCell";
                    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                    
                    
                    UILabel*  labelName= [[UILabel alloc]initWithFrame:CGRectMake(5,5,cell.frame.size.width, 20)];
                    labelName.lineBreakMode = NSLineBreakByWordWrapping;
                    labelName.numberOfLines = 0;
                    [labelName setText: [NSString stringWithFormat:@"ปตท."]];
                    [labelName setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                    [labelName setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 18]];
                    
                    [cell addSubview:labelName];
                    UILabel*  label= [[UILabel alloc]initWithFrame:CGRectMake(5,25,cell.frame.size.width, 30)];
                    label.lineBreakMode = NSLineBreakByWordWrapping;
                    label.numberOfLines = 0;
                    [label setText: [NSString stringWithFormat:@"ประจำวันที่ %ld/%ld/%ld เวลา %@:%@ น.", (long)day,(long)month,year+543,hoursString,minutesString]];
                    [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                    [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 12]];
                    
                    [cell addSubview:label];
                    
                    
                    
                    [cell setBackgroundColor:[UIColor whiteColor]];
                    
                    UILabel *labelUnit= [[UILabel alloc]initWithFrame:CGRectMake(5,25,cell.frame.size.width-10, 30)];
                    labelUnit.textAlignment = NSTextAlignmentRight;
                    [labelUnit setText:@"บาท/ลิตร"];
                    [labelUnit setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                    [labelUnit setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 12]];
                    
                    [cell addSubview:labelUnit];
                    float y = labelUnit.frame.size.height+labelUnit.frame.origin.y+5;
                    for (int i = 0 ; i <7; i++) {
                        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, y, cell.frame.size.width-20, 50)];
                        [view setBackgroundColor:[UIColor colorWithHexString:@"e0e0e0"]];
                        [cell addSubview:view];
                        
                        UILabel*  label= [[UILabel alloc]initWithFrame:CGRectMake(10,0,cell.frame.size.width-20, 50)];
                        label.textAlignment = NSTextAlignmentLeft;
                        switch (i) {
                            case 0:
                                [label setText:@"เบนซิน 95"];//เบนซลิ 95
                                break;
                            case 1:
                                [label setText:@"แก๊สโซฮอล์ 91"];//เบนซลิ 95
                                break;
                            case 2:
                                [label setText:@"แก๊สโซฮอล์ 95"];//เบนซลิ 95
                                break;
                            case 3:
                                [label setText:@"แก๊สโซฮอล์ E20"];//เบนซลิ 95
                                break;
                            case 4:
                                [label setText:@"แก๊สโซฮอล์ E85"];//เบนซลิ 95
                                break;
                            case 5:
                                [label setText:@"ดีเซล"];//เบนซลิ 95
                                break;
                            case 6:
                                [label setText:@"NGV"];//เบนซลิ 95
                                break;
                            default:
                                break;
                        }
                        
                        [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                        [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 18 : 14]];
                        
                        [view addSubview:label];
                        
                        label= [[UILabel alloc]initWithFrame:CGRectMake(5,0,cell.frame.size.width-30, 50)];
                        label.textAlignment = NSTextAlignmentRight;
                        
                        switch (i) {
                            case 0:
                                [label setText:[NSString stringWithFormat:@"%.2f",object.pure95 ]];
                                break;
                            case 1:
                                [label setText:[NSString stringWithFormat:@"%.2f",object.gasohol91 ]];
                                break;
                            case 2:
                                [label setText:[NSString stringWithFormat:@"%.2f",object.gasohol95 ]];
                                break;
                            case 3:
                                [label setText:[NSString stringWithFormat:@"%.2f",object.gasoholE20 ]];
                                break;
                            case 4:
                                [label setText:[NSString stringWithFormat:@"%.2f",object.gasoholE85 ]];
                                break;
                            case 5:
                                [label setText:[NSString stringWithFormat:@"%.2f",object.diesel ]];
                                break;
                            case 6:
                                [label setText:[NSString stringWithFormat:@"%.2f",object.ngv ]];
                                break;
                            default:
                                break;
                        }
                        [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                        [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 18 : 14]];
                        [view addSubview:label];
                        y += view.frame.size.height+10;
                    }
                    //                UIButton *OilInPassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
                    //                CGRect frame = CGRectMake(0,y+5, cell.frame.size.width, 30);
                    //                if ( IDIOM == IPAD ) {
                    //                    frame = CGRectMake(0,y+5, cell.frame.size.width, 30);
                    //                }
                    //                OilInPassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    //                OilInPassButton.frame = frame;
                    //                [OilInPassButton setTitle:@"ราคาน้ำมันย้อนหลัง" forState:UIControlStateNormal];
                    //
                    //                [OilInPassButton addTarget:self action:@selector(goOldOil:) forControlEvents:UIControlEventTouchUpInside];
                    //                [OilInPassButton sizeToFit];
                    //                [OilInPassButton setTintColor:[UIColor grayColor]];
                    //
                    //                [OilInPassButton setFrame:CGRectMake(cell.frame.size.width-OilInPassButton.frame.size.width-5, y+5, OilInPassButton.frame.size.width, OilInPassButton.frame.size.height)];
                    //                [cell addSubview:OilInPassButton];
                    //
                    //                y += OilInPassButton.frame.size.height;
                    //
                    //                UIButton *OilSellButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
                    //                frame = CGRectMake(0,y+5, self.view.frame.size.width, 30);
                    //                if ( IDIOM == IPAD ) {
                    //                    frame = CGRectMake(0,y+5, self.view.frame.size.width, 30);
                    //                }
                    //                OilSellButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    //                OilSellButton.frame = frame;
                    //                [OilSellButton setTitle:@"ราคาน้ำมันขายปลีกภูมิภาค" forState:UIControlStateNormal];
                    //
                    //                [OilSellButton addTarget:self action:@selector(goOldOil:) forControlEvents:UIControlEventTouchUpInside];
                    //                [OilSellButton sizeToFit];
                    //                [OilSellButton setTintColor:[UIColor grayColor]];
                    //
                    //                [OilSellButton setFrame:CGRectMake(cell.frame.size.width-OilSellButton.frame.size.width-5, y+5, OilSellButton.frame.size.width, OilSellButton.frame.size.height)];
                    //                [cell addSubview:OilSellButton];
                    cell.layer.masksToBounds = NO;
                    cell.layer.shadowOffset = CGSizeMake(2, 2);
                    cell.layer.shadowRadius = 2;
                    cell.layer.shadowOpacity = 0.5;
                    cell.layer.shouldRasterize = YES;
                    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
                    return cell;
                }else{
                    NSString *identify = @"SpaceCell";
                    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                    return cell;
                }
            }else{
                NSString *identify = @"SpaceCell";
                UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                return cell;
            }
        }
        else{
            if(indexPath.row == 0){
                GoldObject *object = GoldArray[0];
                if(GoldArray != nil){
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:object.publicDate];
                    NSInteger day = [components day];
                    NSInteger month = [components month];
                    NSInteger year = [components year];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    // [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                    NSDateComponents *componentsTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:object.publicDate];
                    
                    NSInteger hour = [componentsTime hour];
                    NSInteger minute = [componentsTime minute];
                    NSString* hoursString = [NSString stringWithFormat:@"%02li", (long)hour];
                    NSString* minutesString = [NSString stringWithFormat:@"%02li", (long)minute];
                    NSString *identify = @"GoldContentCell";
                    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                    UILabel*  label= [[UILabel alloc]initWithFrame:CGRectMake(5,5,cell.frame.size.width, 30)];
                    label.lineBreakMode = NSLineBreakByWordWrapping;
                    label.numberOfLines = 0;
                    [label setText: [NSString stringWithFormat:@"ประจำวันที่ %ld/%ld/%d เวลา %@:%@ น.", (long)day,(long)month,year+543,hoursString,minutesString]];
                    [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                    [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 18 : 14]];
                    
                    [cell addSubview:label];
                    
                    
                    
                    [cell setBackgroundColor:[UIColor whiteColor]];
                    
                    float y = label.frame.origin.y+label.frame.size.height+5;
                    for (int i = 0 ; i <4; i++) {
                        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, y, cell.frame.size.width-20, 50)];
                        [view setBackgroundColor:[UIColor colorWithHexString:@"e0e0e0"]];
                        [cell addSubview:view];
                        
                        UILabel*  label= [[UILabel alloc]initWithFrame:CGRectMake(10,0,cell.frame.size.width-30, 50)];
                        label.textAlignment = NSTextAlignmentLeft;
                        switch (i) {
                            case 0:
                                [label setText:@"ทองคำแท่ง รับซื้อบาทละ"];//เบนซลิ 95
                                break;
                            case 1:
                                [label setText:@"ทองคำแท่ง ขายออกบาทละ"];//เบนซลิ 95
                                break;
                            case 2:
                                [label setText:@"ทองรูปพรรณ รับซื้อบาทละ"];//เบนซลิ 95
                                break;
                            case 3:
                                [label setText:@"ทองรูปพรรณ ขายออกบาทละ"];//เบนซลิ 95
                                
                                break;
                            default:
                                break;
                        }
                        [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                        [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 18 : 14]];
                        
                        [view addSubview:label];
                        
                        label= [[UILabel alloc]initWithFrame:CGRectMake(5,0,cell.frame.size.width-30, 50)];
                        label.textAlignment = NSTextAlignmentRight;
                        
                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                        [formatter setCurrencySymbol:@""];
                        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
                        [formatter setGroupingSeparator:groupingSeparator];
                        [formatter setGroupingSize:3];
                        [formatter setAlwaysShowsDecimalSeparator:NO];
                        [formatter setUsesGroupingSeparator:YES];
                        
                        switch (i) {
                            case 0:
                                
                                [label setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:object.barBuy]]]];
                                
                                break;
                            case 1:
                                [label setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:object.barSell]]]];
                                break;
                            case 2:
                                [label setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:object.ornamentBuy]]]];
                                break;
                            case 3:
                                [label setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:object.ornamentSell]]]];
                                
                                break;
                            default:
                                break;
                        }
                        [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
                        [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 18 : 14]];
                        [view addSubview:label];
                        y += view.frame.size.height+10;
                    }
                    cell.layer.masksToBounds = NO;
                    cell.layer.shadowOffset = CGSizeMake(2, 2);
                    cell.layer.shadowRadius = 2;
                    cell.layer.shadowOpacity = 0.5;
                    cell.layer.shouldRasterize = YES;
                    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
                    return cell;
                }
                else{
                    NSString *identify = @"SpaceCell";
                    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                    return cell;
                }
            }else{
                NSString *identify = @"SpaceCell";
                UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                return cell;
            }
            
        }
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_1 = (self.view.frame.size.width/2 -15);
    float w_2 = (self.view.frame.size.width -20);
    
    
    if( [self.nameMenu[collectionView.tag] intValue]== NEWS_FINANCE || [self.nameMenu[collectionView.tag] intValue]== NEWS_HOT_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_INTER_NEWS ||[self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTO || [self.nameMenu[collectionView.tag] intValue]== NEWS_TECHNOLOGY ){
        
        return CGSizeMake(w_1,(w_1*144)/300+(IPAD == IDIOM  ? 60 : 50));
    }else if([self.nameMenu[collectionView.tag] intValue]== NEWS_LOTTERRY ){
        switch (indexPath.row) {
            case 0:
                
                return CGSizeMake(w_2,380);
                
                break;
                
            default:
                
                return CGSizeMake(w_2, (self.view.frame.size.height -menuHeight - 480) > 0 ? self.view.frame.size.height -menuHeight- 480 : 0 );
                
                break;
        }
        
    }else if([self.nameMenu[collectionView.tag] intValue]== NEWS_GAS_PRICE ){
        switch (indexPath.row) {
            case 0:
                
                return CGSizeMake(w_2,480);
                
                break;
                
            default:
                
                return CGSizeMake(w_2, (self.view.frame.size.height -menuHeight - 480) > 0 ? self.view.frame.size.height -menuHeight- 480 : 0 );
                
                break;
        }
        
    }
    else if([self.nameMenu[collectionView.tag] intValue]== NEWS_WIKI ){
        switch (indexPath.row) {
            case 0:
                
                return CGSizeMake(w_2,(w_2*312)/650+60);
                
                break;
                
            default:
                
                return CGSizeMake(w_2, (self.view.frame.size.height -menuHeight - (w_2*312)/650) > 0 ? self.view.frame.size.height -menuHeight- (w_2*312)/650 : 0 );
           
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
                
                return CGSizeMake(w_2,280);
                
                break;
            default:
                
                return CGSizeMake(w_2, (self.view.frame.size.height-menuHeight - 280) > 0 ? self.view.frame.size.height -menuHeight- 280 : 0 );
                
                break;
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.nameMenu[collectionView.tag] intValue]!= NEWS_GAS_PRICE && [self.nameMenu[collectionView.tag] intValue]!= NEWS_GOLD_PRICE){
        self.articleView= [[NewsDetailViewController alloc]init];
        NSArray *object = allObjectArray[currentPage];
        NSMutableArray *temp =  object[indexPath.section];
        ContentPreview *preview = temp[indexPath.row];
        
        self.articleView.contentID = preview.contentID;
        self.articleView.pageType = self.pageType;
        self.articleView.themeColor = self.themeColor;
        
        NSString* nameMenu = [Manager getSubcateName:[self.nameMenu[collectionView.tag]  intValue] withThai:YES];
       

        
        self.articleView.titlePage = nameMenu;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:self.articleView animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    //    if(collectionView.tag<4){
    //    if(section>=1){
    //        if(section == 1){
    //             NSArray* temp = allObjectArray[collectionView.tag] ;
    //            NSArray*temp2 = temp[1];
    //            if(temp2.count <8){
    //                return CGSizeZero;
    //            }
    //            else{
    //                 return CGSizeMake(self.view.frame.size.width,100);
    //            }
    //        }
    //        return CGSizeZero;
    //    }
    //    return CGSizeMake(self.view.frame.size.width,100);
    //    }else{
    return CGSizeZero;
    // }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-160+10,0, 320-20, 100)];
        [imageView setImage:[UIImage imageNamed:@"ads.jpg"]];
        [imageView setBackgroundColor:[UIColor blackColor]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [footerview addSubview:imageView];
        
        reusableview = footerview;
    }
    
    return reusableview;
}
#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return menuArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    view = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        
        
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self setRoundedView:iconHeader toDiameter:60];
        
        NSLog(@"swipView main %ld",(long)index);
        UICollectionView *temp = collectionViewArray[index];
        
        if(self.lastContentOffset <=posTopCollectionView){
            
            temp.contentOffset = CGPointMake(0, self.lastContentOffset);
        }
        else{
            temp.contentOffset = CGPointMake(0, posTopCollectionView);
        }
        
        [view addSubview:collectionViewArray[index]];
        
    }
    else
    {
        //get a reference to the label in the recycled view
        //  label = (UILabel *)[view viewWithTag:1];
    }
    
    return view;
}
-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    
    return  swipeView == _swipeViewHoro ? self.swipeViewHoro.bounds.size :  self.swipeView.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    for (UIButton *buttonTemp in buttonArray) {
        if(buttonTemp.tag == swipeView.currentItemIndex){
            
            
            [UIView animateWithDuration:0.5 animations:^{
                [indicatorMenu setFrame:CGRectMake(buttonTemp.frame.origin.x, buttonTemp.frame.size.height-5,  buttonTemp.frame.size.width, 2.5)];
                
            }];
            float w = menuView.frame.size.width;
            float h = menuView.frame.size.height;
            
            CGRect toVisible = CGRectMake(buttonTemp.frame.origin.x-self.view.frame.size.width/2+buttonTemp.frame.size.width/2, 0, w, h);
            [menuView scrollRectToVisible:toVisible animated:YES];
        }
    }
    
    currentPage = (int)swipeView.currentItemIndex;
    NSLog(@"didchange Main %d",currentPage);
    self.indexPage =(int)swipeView.currentItemIndex;
    self.collectionView = collectionViewArray[currentPage];
    
    if([self.nameMenu[swipeView.currentItemIndex] intValue] == NEWS_LOTTERRY || [self.nameMenu[swipeView.currentItemIndex] intValue] == NEWS_GAS_PRICE ||[self.nameMenu[swipeView.currentItemIndex] intValue] == NEWS_GOLD_PRICE){
         self.collectionView.showsInfiniteScrolling = NO;
    }
    else{
       
        __weak NewsViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [ self.collectionView  addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
        self.collectionView.showsInfiniteScrolling = YES;
    }
    
    
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    if(swipeView.currentItemIndex != lastStatPage){

            [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:NEWS withSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue] :nil]}];
            
            [Manager savePageView:0 orSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue]];
  
        lastStatPage = (int)swipeView.currentItemIndex;
    }

}
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView{
     lastStatPage = (int)swipeView.currentItemIndex;
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:NEWS withSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue] :nil]}];
    
    [Manager savePageView:0 orSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue]];
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

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    if([[Manager sharedManager] bannerArrayNews]){
       return [[Manager sharedManager]bannerArrayNews].count;
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
        temp  = [[Manager sharedManager] bannerArrayNews ][index];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
    
    _swipeViewHoro.delegate = nil;
    _swipeViewHoro.dataSource = nil;
}


@end