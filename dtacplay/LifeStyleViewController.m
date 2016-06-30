//
//  LifeStyleViewController.m
//  dtacplay
//
//  Created by attaphon on 10/25/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "LifeStyleViewController.h"

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
#import "DtacPlayHeaderHoloCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HoroViewController.h"
#import "SVPullToRefresh.h"
#import "Manager.h"
#import "Banner.h"
#import "BannerImage.h"
@interface LifeStyleViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
    NSMutableArray *colorArray;
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
    
    UIView *nodataView;
    
    float menuHeight;
    NSTimer *timer;
    
    int lastStatPage ;
}
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation LifeStyleViewController
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{ if(scrollView.contentOffset.x==0){
    if(self.lastContentOffset <=posTopCollectionView ){
        
        if(self.collectionView.contentOffset.y !=0){
            menuView.frame = CGRectMake(0,posTopCollectionView-scrollView.contentOffset.y, self.view.frame.size.width, menuHeight);
            
        }
        else{
            
            menuView.frame = CGRectMake(0,menuPosition- scrollView.contentOffset.y, self.view.frame.size.width, menuHeight);
        }
    }
    else{
        menuView.frame = CGRectMake(0,0, self.view.frame.size.width,menuHeight);
    }
    
    imageHeader.frame = CGRectMake(0,1-scrollView.contentOffset.y, imageHeader.frame.size.width, imageHeader.frame.size.height);
    if(scrollView.contentOffset.y == 0){
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }
    NSLog(@"%f",scrollView.contentOffset.y);
    self.lastContentOffset =scrollView.contentOffset.y;
}
}
-(void)refreshPage:(int)current{
    int number = [pageArray[current] intValue];
    number = number + 1;
    pageArray[current] = [NSNumber numberWithInt:number];
    SubCategorry subcate = [self.nameMenu[current] intValue] ;

    if(subcate != LIFESTYLE_HOROSCOPE){
        NSString *jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%ld, \"page\":%d,\"limit\":14 }}",(long)subcate,number];
        
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
                
                NSMutableArray *objectArray = allObjectArray[page];
                NSMutableArray *tempArray =  objectArray[0] ;
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                
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
    }else{
        NSString *jsonString =
        [NSString stringWithFormat:@"{ \"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getContentByFeedId\",\"params\":{ \"feedIds\":[22,23,24],\"page\":%d,\"limit\":6 }}",number];
        
        NSString *valueHeader;
        
        NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
        op.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                       [NSString stringWithFormat:@"%d",current] , @"page",nil];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            int page = [[operation.userInfo objectForKey:@"page"] intValue];
            UICollectionView *collectionView = collectionViewArray[page];
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
                NSMutableArray *objectArray = allObjectArray[page];
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                
                for(NSDictionary* temp in content){
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    if(objectArray.count==3)
                    [objectArray[2] addObject:preview];
                    
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
}

-(void)GetContentLifeStyle:(int)index AndSubcate:(int)subcate{

    if(subcate != LIFESTYLE_HOROSCOPE){
        NSString *jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%ld, \"page\":1,\"limit\":14 }}",(long)subcate];
        
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
                
                
                NSMutableArray*  tempArray ;
                
                tempArray = [[NSMutableArray alloc]init];
                if(index != 4){
                    for(NSDictionary* temp in content){
                        
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [tempArray addObject:preview];
                        
                    }
                    
                    [objectArray addObject:tempArray];
                    
                    
                    allObjectArray[index] = objectArray;
                    
                }
                else{
                    
                    tempArray = [[NSMutableArray alloc]init];
                    [tempArray addObject:[NSNull null]];
                    for(NSDictionary* temp in content){
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [tempArray addObject:preview];
                    }
                    [objectArray addObject:tempArray];
                    
                    tempArray = [[NSMutableArray alloc]init];
                    [tempArray addObject:[NSNull null]];
                    for(NSDictionary* temp in content){
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [tempArray addObject:preview];
                    }
                    [objectArray addObject:tempArray];
                    
                    tempArray = [[NSMutableArray alloc]init];
                    [tempArray addObject:[NSNull null]];
                    for(NSDictionary* temp in content){
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [tempArray addObject:preview];
                    }
                    [objectArray addObject:tempArray];
                    
                    allObjectArray[index] = objectArray;
                }
                
            }
            
            
            [self.collectionView reloadData];
            
            //  ...
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"JSON responseObject: %@ ",error);
             [hud hide:YES];
        }];
        [op start];
    }else{
        NSString *jsonString =
        [NSString stringWithFormat:@"{ \"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getContentByFeedId\",\"params\":{ \"feedIds\":[20],\"page\":1,\"limit\":7 }}"];
        
        NSString *valueHeader;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setColor:[UIColor whiteColor]];
        [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
        NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
        
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];
             NSMutableArray *objectArray = [[NSMutableArray alloc]init];
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
               
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                
                
                NSMutableArray*  tempArray ;
                
                tempArray = [[NSMutableArray alloc]init];
                [tempArray addObject:[NSNull null]];
                for(NSDictionary* temp in content){
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [tempArray addObject:preview];
                    NSString* data = preview.dateString;
                    
                    tempArray[0] = data != nil ? data : [NSNull null];
                }
                [objectArray addObject:tempArray];
                
            }else{
                [objectArray addObject:[[NSMutableArray alloc] init]];
                allObjectArray[index] = objectArray;
            }
                NSString *jsonString =
                [NSString stringWithFormat:@"{ \"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getContentByFeedId\",\"params\":{ \"feedIds\":[21],\"page\":1,\"limit\":12 }}"];
                
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
                        
                        
                        NSMutableArray*  tempArray ;
                        
                        tempArray = [[NSMutableArray alloc]init];
                        [tempArray addObject:[NSNull null]];
                        
                        for(NSDictionary* temp in content){
                            ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                            [tempArray addObject:preview];
                            
                            NSString* data = preview.dateString;
                            
                            tempArray[0] = data != nil ? data : [NSNull null];
                        }
                        [objectArray addObject:tempArray];
                    }
                    else{
                        [objectArray addObject:[[NSMutableArray alloc] init]];
                        allObjectArray[index] = objectArray;
                    }
                        NSString *jsonString =
                        [NSString stringWithFormat:@"{ \"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getContentByFeedId\",\"params\":{ \"feedIds\":[22,23,24],\"page\":1,\"limit\":6 }}"];
                        
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
                                
                                
                                NSMutableArray*  tempArray ;
                                
                                tempArray = [[NSMutableArray alloc]init];
                                [tempArray addObject:[NSNull null]];
                                for(NSDictionary* temp in content){
                                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                                    [tempArray addObject:preview];
                                    NSString* data = preview.dateString;
                                    
                                    tempArray[0] = data != nil ? data : [NSNull null];
                                }
                                [objectArray addObject:tempArray];
                                
                                
                                
                            }
                            allObjectArray[index] = objectArray;
                            
                            [self.collectionView reloadData];
                            
                            //  ...
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"JSON responseObject: %@ ",error);
                        }];
                        [op start];
                    
                    
                    
                    [self.collectionView reloadData];
                    
                    //  ...
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"JSON responseObject: %@ ",error);
                     [hud hide:YES];
                }];
                [op start];
                
            [self.collectionView reloadData];
            
            //  ...
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"JSON responseObject: %@ ",error);
             [hud hide:YES];
        }];
        [op start];
    }
}
-(void)setup{
    allObjectArray = [[NSMutableArray alloc]init];
    pageArray = [[NSMutableArray alloc]init];
     lastStatPage = self.indexPage ;
    for (int i = 0; i < self.nameMenu.count; i++) {
        [allObjectArray addObject:[[NSMutableArray alloc]init]];
        [pageArray addObject:[NSNumber numberWithInt:1]];
    }
    
    for (int i = 0; i < self.nameMenu.count; i++) {
        
        [self GetContentLifeStyle:i AndSubcate:[self.nameMenu[i] intValue]];
        
    }
[Manager savePageView:3 orSubCate:0];

    //initial submenu
    menuArray = self.nameMenu;
    
    totalPage = (int)menuArray.count;
    colorArray = [[NSMutableArray alloc] init];
    
    indicatorMenu = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 10 )];
    [indicatorMenu setBackgroundColor:_themeColor];
    for (int i = 0; i < totalPage; i++) {
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.42;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [colorArray addObject:color];
        
    }
    
    
    collectionViewArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i<menuArray.count; i++) {
        
        sizeArray = [[NSMutableArray alloc]init];
        MyFlowLayout *layout=[[MyFlowLayout alloc] init];
        
        UICollectionView *fooCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-110) collectionViewLayout:layout];
        
        fooCollection.tag = i;
        [fooCollection setDataSource:self];
        [fooCollection setDelegate:self];
        if([self.nameMenu[i] intValue] == LIFESTYLE_HOROSCOPE){
            [fooCollection registerClass:[DtacPlayHeaderHoloCollectionViewCell class] forCellWithReuseIdentifier:@"HeaderCell"];
        }
        [fooCollection registerClass:[DtacPlayBlockCollectionViewCell class] forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
        [fooCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        //            UINib *cellNib = [UINib nibWithNibName:@"BlockCollectionViewCell" bundle:nil];
        //            [fooCollection registerNib:cellNib forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
        [fooCollection setBackgroundColor:[UIColor clearColor]];
        
        [fooCollection scrollsToTop];
        
        [fooCollection addSubview:iconHeader];
        [collectionViewArray addObject:fooCollection];
        if(self.indexPage == i){
            self.collectionView =fooCollection;
            __weak LifeStyleViewController *weakSelf = self;
            
            // setup pull-to-refresh
            [fooCollection addInfiniteScrollingWithActionHandler:^{
                [weakSelf insertRowAtTop];
            }];
        }
        
    }
    
}
- (void)insertRowAtTop {
    int current = _swipeView.currentItemIndex;
    __weak LifeStyleViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage:current];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
    });
    
}
-(void)viewWillAppear:(BOOL)animated{
    //[_swipeView scrollToItemAtIndex:self.indexPage duration:0.25];
}

-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdLifestyle]];
    
    
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
            
            [[Manager sharedManager] setBannerArrayLifeStyle:bannerArray];
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayLifeStyle].count;
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
     if(![[Manager sharedManager]bannerArrayLifeStyle])
         [self getBanner];
     [self setCateID:LIFESTYLE];
     //[Manager savePageView:3];
    //
    //    for (int i = 0 ; i <50; i++) {
    //        NSInteger randomNumber = arc4random() %1000000;
    //        NSLog(@"%d",randomNumber);
    //    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _themeColor = [UIColor colorWithHexString:COLOR_LIFESTYLE];
    self.navigationItem.title = @"ไลฟ์สไตล์";
    
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
    pageControl.numberOfPages = [[Manager sharedManager] bannerArrayLifeStyle].count >0  ? [[Manager sharedManager] bannerArrayLifeStyle].count : [[Manager sharedManager] bannerArray].count;
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
 
    //[self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:LIFESTYLE withSubCate:[self.nameMenu[self.indexPage] intValue] :nil]}];

    if(IDIOM == IPAD){
        menuView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, imageHeader.frame.origin.y+imageHeader.frame.size.height,self.view.frame.size.width, 55)];
        
    }
    else{
        menuView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, imageHeader.frame.origin.y+imageHeader.frame.size.height,self.view.frame.size.width, 55)];
        
    }
    
    menuHeight =menuView.frame.size.height;
    posTopCollectionView = menuView.frame.origin.y;
    self.lastContentOffset = 0;
    menuPosition = menuView.frame.origin.y;
    [menuView setBackgroundColor:[UIColor whiteColor]];
    
    
    buttonArray = [[NSMutableArray alloc]init];
    float x= 10;
    BOOL first = YES;
    for (int i = 0; i< menuArray.count; i++) {
        NSString *nameMenu  = [Manager getSubcateName:[self.nameMenu[i] intValue] withThai:YES];
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
            [indicatorMenu setFrame:CGRectMake(button.frame.origin.x, button.frame.size.height-5, button.frame.size.width, 2.5)];
            //  first = NO;
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
    //[self.view setBackgroundColor:[UIColor blackColor]];
    
    
    //    nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40  )];
    //    [nodataView setBackgroundColor:[UIColor whiteColor]];
    //    UILabel *lablTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,0, nodataView.frame.size.width, 40)];
    //    // [lblHeader setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]];
    //    lablTitle.backgroundColor = [UIColor clearColor];
    //    [lablTitle setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size: IDIOM==IPAD ? 21: 14]];
    //    lablTitle.textAlignment = NSTextAlignmentCenter;
    //    [lablTitle setTextColor:[UIColor colorWithHexString:COLOR_LIFESTYLE]];
    //    // lblHeader.textColor =  [UIColor colorWithHexString:SIDE_BAR_COLOR];
    //    lablTitle.text = @"ไม่พบข้อมูล";
    //    [nodataView addSubview:lablTitle];
    //    [self.view addSubview:nodataView];
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
    if(collectionView.tag <5){
        NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
        return object.count;
    }
    else{
        return 2;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
    NSMutableArray *temp = object[section];//collectionView.tag
    return temp.count;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if(section == 0 ){
        if(collectionView.tag != 2){
            
            UIEdgeInsets inset = UIEdgeInsetsMake(posTopCollectionView+10,10,10,10);
            return inset;
        }else{
            
            UIEdgeInsets inset = UIEdgeInsetsMake(posTopCollectionView+10,10,10,10);
            return inset;
        }
        
    }
    else{
        
        UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
        return inset;
    }
    
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag !=2){
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        ContentPreview *articleTemp = tempArray[indexPath.row];
        
        NSString *identify = @"BlockCollectionViewCell";
        DtacPlayBlockCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
    
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
                              placeholderImage:[UIImage imageNamed:@"default_image_01_L.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
        NSLog(@"%@",articleTemp.images.imageThumbnailL);
        [cell.label setText:articleTemp.previewTitle];
        //
        //        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        //        [style setLineBreakMode:NSLineBreakByWordWrapping];
        //
        //        CGSize size = [articleTemp.title boundingRectWithSize:CGSizeMake(cell.label.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
        //
        //        float h = IPAD == IDIOM ? 60 : 50;
        //        [cell.label setFrame:CGRectMake(cell.label.frame.origin.x,cell.label.frame.origin.y, cell.label.frame.size.width,((size.height<h)? size.height : h))];
        [cell.imageView setBackgroundColor:[UIColor blackColor]];
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
        
        return cell;
    }
    else{
        if(indexPath.row == 0){
            NSArray *object = allObjectArray[collectionView.tag];
            NSMutableArray *tempArray = object[indexPath.section];
            
            NSString *dateString = tempArray[0];
            
            NSString *identify = @"HeaderCell";
            DtacPlayHeaderHoloCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.moreButton setHidden:YES];
            [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_horo_daily"]];
            [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.label setTextColor:[UIColor colorWithHexString:COLOR_LIFESTYLE]];
            [cell.imageView setBackgroundColor:[UIColor whiteColor]];
            switch (indexPath.section ) {
                case 0:
                    [cell.label setText: [NSString stringWithFormat:@"ดูดวงรายวันประจำวันที่ %@",dateString ]];
                    
                    break;
                case 1:
                    [cell.label setText: [NSString stringWithFormat:@"ดูดวงรายสัปดาห์ประจำวันที่ %@",dateString ]];
                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_horo_weekly"]];
                    break;
                case 2:
                    [cell.label setText: [NSString stringWithFormat:@"เคล็ดลับเสริมดวง" ]];
                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_horo_secert"]];
                    break;
                default:
                    break;
            }

            
            return cell;
        }
        else{
            NSArray *object = allObjectArray[collectionView.tag];
            NSMutableArray *tempArray = object[indexPath.section];
            ContentPreview *articleTemp = tempArray[indexPath.row];
            
            NSString *identify = @"BlockCollectionViewCell";
            DtacPlayBlockCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
      
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
                                  placeholderImage:[UIImage imageNamed:@"default_image_01_L.jpg"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             
                                         }];
         
            
            [cell.label setText:articleTemp.previewTitle];
            [cell.imageView setBackgroundColor:[UIColor blackColor]];
            //            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            //            [style setLineBreakMode:NSLineBreakByWordWrapping];
            //
            //            CGSize size = [articleTemp.title boundingRectWithSize:CGSizeMake(cell.label.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
            //
            //            float h = IPAD == IDIOM ? 60 : 50;
            //            [cell.label setFrame:CGRectMake(cell.label.frame.origin.x,cell.label.frame.origin.y, cell.label.frame.size.width,((size.height<h)? size.height : h))];
            
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
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_1 = (self.view.frame.size.width/2 -15);
    float w_2 = (self.view.frame.size.width -20);
    
    
    if(collectionView.tag !=2){
        
        
        return CGSizeMake(w_1,(w_1*144)/300+(IDIOM == IPAD ? 60 : 50));
    }else{
        
        if(indexPath.row == 0){
            
            return CGSizeMake(w_2,40);
        }
        
        
        return CGSizeMake(w_1,(w_1*144)/300+(IDIOM == IPAD ? 60 : 50));
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

        self.articleView= [[ArticleViewController alloc]init];
        NSArray *object = allObjectArray[currentPage];
        NSMutableArray *temp =  object[indexPath.section];
        ContentPreview *preview = temp[indexPath.row];
        
        self.articleView.contentID = preview.contentID;
        self.articleView.pageType = self.pageType;
        self.articleView.themeColor = self.themeColor;
        self.articleView.subCateType = self.subeType;
        NSString *nameMenu =[Manager getSubcateName:[self.nameMenu[collectionView.tag]  intValue] withThai:YES];
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
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    //    if(collectionView.tag <2){
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
    //    }
    //    else{
    return CGSizeZero;
    //  }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-160+10,0, 320-20, 100)];
        [imageView setImage:[UIImage imageNamed:@"ads.jpg"]];
        [imageView setBackgroundColor:[UIColor redColor]];
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
    
    __weak LifeStyleViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [ self.collectionView  addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    self.collectionView.showsInfiniteScrolling = YES;
   
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    if(swipeView.currentItemIndex != lastStatPage){
        //

        [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:LIFESTYLE withSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue] :nil]}];
        [Manager savePageView:0 orSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue]];
  
        lastStatPage = (int)swipeView.currentItemIndex;
    }
    
}
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView{
    lastStatPage = (int)swipeView.currentItemIndex;
    //
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:LIFESTYLE withSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue] :nil]}];
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
    if([[Manager sharedManager] bannerArrayLifeStyle]){
        return [[Manager sharedManager]bannerArrayLifeStyle].count;
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
    if([[Manager sharedManager] bannerArrayLifeStyle]){
        temp  = [[Manager sharedManager] bannerArrayLifeStyle ][index];
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
    if([[Manager sharedManager] bannerArrayLifeStyle]){
        temp  = [[Manager sharedManager] bannerArrayLifeStyle ][index];
    }
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