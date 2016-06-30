//
//  COLOR_NEWS
//  dtacplay
//
//  Created by attaphon on 10/25/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "EntertainmentViewController.h"

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
#import "EntertainmentDetailViewController.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "Banner.h"
#import "BannerImage.h"
#import "DtacPlayHeaderHoloCollectionViewCell.h"
#import "ListContentEntertainmentViewController.h"
@interface EntertainmentViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
    
    NSMutableArray *variety_array;
    NSMutableArray *variety_news_array;
    NSMutableArray *variety_gossip_array;
    NSMutableArray *variety_music_array;
    
    NSMutableArray *movie_array;
    NSMutableArray *movie_news_array;
    NSMutableArray *movie_trailer_array;
    
    NSMutableArray *tv_array;
    int lastStatPage ;
    
}
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation EntertainmentViewController
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
-(void)refreshPage:(int)current{
    int number = [pageArray[current] intValue];
    number = number + 1;
    pageArray[current] = [NSNumber numberWithInt:number];
    SubCategorry subcate ;
    NSNumber *pageType = self.nameMenu[_swipeView.currentItemIndex];
    
    subcate = [pageType intValue];
    
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
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            for(NSDictionary* temp in content){
                
                ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                [objectArray addObject:preview];
                
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
-(void)GetContentEntertainment:(int)index AndSubCate:(int)subcat limit:(int)limit{


    NSString *
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%d, \"page\":%d,\"limit\":%d }}",subcat,1,limit];

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
        
        if(subcat == ENTERTAINMENT_NEWS){
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {

                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;

                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [variety_news_array addObject:preview];
                    
                    
                }

            }
 
        }
        else if(subcat == ENTERTAINMENT_MUSIC){
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                
                
                variety_music_array = [[NSMutableArray alloc]init];
                 [variety_music_array addObject:[NSNumber numberWithInt:ENTERTAINMENT_MUSIC]];
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [variety_music_array addObject:preview];
                    
                    
                }
                [variety_array addObject:variety_music_array];
                
                if(variety_array.count==3){
                    [variety_array exchangeObjectAtIndex:1 withObjectAtIndex:2];
                }
                
            }
            
        }
        else if(subcat == ENTERTAINMENT_VIDEO){
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                

                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [variety_gossip_array addObject:preview];
                    
                    
                }

            }
            
        }
        else if(subcat == ENTERTAINMENT_MOVIE_NEWS){
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                
                
                movie_news_array = [[NSMutableArray alloc]init];
                [movie_news_array addObject:[NSNumber numberWithInt:ENTERTAINMENT_MOVIE_NEWS]];
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [movie_news_array addObject:preview];
                    
                    
                }
                if(variety_array.count >1){
                    [variety_array exchangeObjectAtIndex:0 withObjectAtIndex:1];
                }
                [movie_array addObject:movie_news_array];
            }
            
        }else if(subcat == ENTERTAINMENT_MOVIE_TRAILER){
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                
                
                movie_trailer_array = [[NSMutableArray alloc]init];
                [movie_trailer_array addObject:[NSNumber numberWithInt:ENTERTAINMENT_MOVIE_TRAILER]];
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [movie_trailer_array addObject:preview];
                    
                    
                }
                [movie_array addObject:movie_trailer_array];
            }
            
        }
        else if(subcat == ENTERTAINMENT_TV){
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                
                NSDictionary *result =[responseObject objectForKey:@"result"] ;
                NSArray * content = [result objectForKey:@"contents"] ;
                

                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [tv_array addObject:preview];
                    
                    
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
-(void)setup{
    allObjectArray = [[NSMutableArray alloc]init];
    pageArray = [[NSMutableArray alloc]init];
     lastStatPage = self.indexPage ;
    
    for (int i = 0; i < self.nameMenu.count; i++) {
        [allObjectArray addObject:[[NSMutableArray alloc]init]];
        [pageArray addObject:[NSNumber numberWithInt:1]];
    }
    
    
    for (int i = 0; i < self.nameMenu.count; i++) {

        if([_nameMenu[i] intValue] == ENTERTAINMENT_NEWS){
    
            variety_news_array = [[NSMutableArray alloc]init];
            allObjectArray[i] =  variety_news_array;
            
           
            
             [self GetContentEntertainment:i AndSubCate :ENTERTAINMENT_NEWS limit:14];
             //[self GetContentEntertainment:i AndSubCate :ENTERTAINMENT_MUSIC limit:8];
            
        }
        else if([_nameMenu[i] intValue] == ENTERTAINMENT_VIDEO){
            variety_gossip_array = [[NSMutableArray alloc]init];
             allObjectArray[i] = variety_gossip_array;
            
            [self GetContentEntertainment:i AndSubCate :ENTERTAINMENT_VIDEO limit:14];
        }
        else if([_nameMenu[i] intValue] == ENTERTAINMENT_MOVIE){
            movie_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = movie_array;
            [self GetContentEntertainment:i AndSubCate :ENTERTAINMENT_MOVIE_NEWS limit:14];
            [self GetContentEntertainment:i AndSubCate :ENTERTAINMENT_MOVIE_TRAILER limit:14];
    
        }else if([_nameMenu[i] intValue] == ENTERTAINMENT_TV){
            tv_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = tv_array;
            [self GetContentEntertainment:i AndSubCate :ENTERTAINMENT_TV limit:14];
        }
        
    }
    [Manager savePageView:2 orSubCate:0];

    
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
        [fooCollection registerClass:[DtacPlayHeaderHoloCollectionViewCell class] forCellWithReuseIdentifier:@"HeaderCell"];
        //HeaderCell
        [fooCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
       [fooCollection setBackgroundColor:[UIColor clearColor]];
        
        [fooCollection scrollsToTop];
        
        [fooCollection addSubview:iconHeader];
        [collectionViewArray addObject:fooCollection];
        
        if(self.indexPage == i){
            self.collectionView =fooCollection;
                __weak EntertainmentViewController *weakSelf = self;
            
                // setup pull-to-refresh
                [fooCollection addInfiniteScrollingWithActionHandler:^{
                    [weakSelf insertRowAtTop];
                }];
            
        }
        
    }
    
    
    
}
- (void)insertRowAtTop {
    int current = _swipeView.currentItemIndex;
    __weak EntertainmentViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage:current];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
    });
    
}
-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdEntertainment]];
    
    
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
            
            [[Manager sharedManager] setBannerArrayEntertainment:bannerArray];
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayEntertainment].count;
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
    [self setCateID:ENTERTAINMENT];
     if(![[Manager sharedManager]bannerArrayEntertainment])
         [self getBanner];
     //[Manager savePageView:2];
    //
    //    for (int i = 0 ; i <50; i++) {
    //        NSInteger randomNumber = arc4random() %1000000;
    //        NSLog(@"%d",randomNumber);
    //    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _themeColor = [UIColor colorWithHexString:COLOR_ENTERTAINMENT];
    self.navigationItem.title = @"บันเทิง";
    
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
    //NSNumber* number = self.nameMenu[self.indexPage];
    //[self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:ENTERTAINMENT withSubCate:[number intValue] :nil]}];
    
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
    pageControl.numberOfPages = [[Manager sharedManager] bannerArrayEntertainment].count >0  ? [[Manager sharedManager] bannerArrayEntertainment].count : [[Manager sharedManager] bannerArray].count;
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
        NSString *nameMenu = [Manager getSubcateName:[self.nameMenu[i]  intValue] withThai:YES];
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
            first = NO;
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
    
    if([_nameMenu[collectionView.tag] intValue] == ENTERTAINMENT_TV){
        return 1;
    }
    NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
    NSLog(@" section %lu",(unsigned long)object.count);
    return 1;
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([_nameMenu[collectionView.tag] intValue] == ENTERTAINMENT_TV){
         NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
        return object.count;
    }
    NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
    return object.count;
    
    
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
//    if([_nameMenu[collectionView.tag] intValue] == ENTERTAINMENT_VARIETY ||[_nameMenu[collectionView.tag] intValue] == ENTERTAINMENT_MOVIE ){
//        NSArray *object = allObjectArray[collectionView.tag];
//        NSMutableArray *tempArray = object[indexPath.section];
//       
//        if(indexPath.row == 0){
//            
//             int subcate = [tempArray[indexPath.row] intValue];
//            
//            NSString *identify = @"HeaderCell";
//            DtacPlayHeaderHoloCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
//            [cell setBackgroundColor:[UIColor whiteColor]];
//            [cell.line setBackgroundColor:[UIColor colorWithHexString:COLOR_ENTERTAINMENT]];
//            [cell.moreButton setImage:[UIImage imageNamed:@"dtacplay_home_more_entertainment"] forState:UIControlStateNormal];
//            [cell.moreButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
//            cell.moreButton.tag = subcate;
//            
//            [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_horo_daily"]];
//            [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
//            [cell.label setTextColor:[UIColor colorWithHexString:COLOR_ENTERTAINMENT]];
//            [cell.imageView setBackgroundColor:[UIColor whiteColor]];
//             [cell.label setText:[Manager getSubcateName:subcate withThai:YES]];
//            
//            switch (subcate ) {
//                case ENTERTAINMENT_NEWS:
//                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_news"]];
//                    break;
//                case ENTERTAINMENT_GOSSIP:
//                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_gossip"]];
//                    break;
//                case ENTERTAINMENT_MUSIC:
//                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_music"]];
//                    break;
//                case ENTERTAINMENT_MOVIE_NEWS:
//                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_movie_news"]];
//                    break;
//                case ENTERTAINMENT_MOVIE_TRAILER:
//                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_entertainment_movie_trailer"]];
//                    break;
//                default:
//                    [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_horo_secert"]];
//                    break;
//            }
// 
//            return cell;
//
//        }
//        else{
//             ContentPreview *articleTemp = tempArray[indexPath.row];
//            NSString *identify = @"BlockCollectionViewCell";
//            DtacPlayBlockCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
//   
//                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
//                                  placeholderImage:[UIImage imageNamed:@"default_image_01_L.jpg"]
//                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                             
//                                         }];
//            
//          
//            [cell.label setText:articleTemp.previewTitle];
//            
//            cell.layer.masksToBounds = NO;
//            cell.layer.shadowOffset = CGSizeMake(2, 2);
//            cell.layer.shadowRadius = 2;
//            cell.layer.shadowOpacity = 0.5;
//            cell.layer.shouldRasterize = YES;
//            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
//            
//            [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
//            NSLog(@"create cell");
//            return cell;
//        }
//    }
    NSArray *object = allObjectArray[collectionView.tag];
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
    
    
    if([_nameMenu[collectionView.tag] intValue] == ENTERTAINMENT_VIDEO || [_nameMenu[collectionView.tag] intValue] == ENTERTAINMENT_NEWS){
        
        return CGSizeMake(w_1,(w_1*144)/300+(IDIOM == IPAD ? 60 : 50));
        
    }else{
        
       return CGSizeMake(w_1,(w_1*144)/300+(IDIOM == IPAD ? 60 : 50));
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_nameMenu[collectionView.tag] intValue] == ENTERTAINMENT_TV){
    EntertainmentDetailViewController * articleView= [[EntertainmentDetailViewController alloc]init];
    NSArray *object = allObjectArray[currentPage];
    //NSMutableArray *temp =  object[indexPath.section];
    ContentPreview *preview = object[indexPath.row];
    articleView.contentID = preview.contentID;
    articleView.pageType = self.pageType;
    articleView.themeColor = self.themeColor;
    
    NSString *nameMenu = [Manager getSubcateName:[self.nameMenu[collectionView.tag]  intValue] withThai:YES];

    articleView.titlePage = nameMenu;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    [self.navigationController pushViewController:articleView animated:YES];
    }else{
       
        EntertainmentDetailViewController * articleView= [[EntertainmentDetailViewController alloc]init];
        NSArray *object = allObjectArray[currentPage];
        ContentPreview *preview = object[indexPath.row];
        articleView.contentID = preview.contentID;
        articleView.pageType = self.pageType;
        articleView.themeColor = self.themeColor;
        
        NSString *nameMenu = [Manager getSubcateName:[self.nameMenu[collectionView.tag]  intValue] withThai:YES];
        
        articleView.titlePage = nameMenu;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];
        
    }
    
}

-(void)moreClick:(UIButton*)button{
    
    ListContentEntertainmentViewController * articleView= [[ListContentEntertainmentViewController alloc]init];

    articleView.cate = ENTERTAINMENT;
    articleView.subCate =(int)ceil(button.tag);
  
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    [self.navigationController pushViewController:articleView animated:YES];
    
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
    
   
        __weak EntertainmentViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [ self.collectionView  addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
        self.collectionView.showsInfiniteScrolling = YES;
    
    
    
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    if(swipeView.currentItemIndex != lastStatPage){
        //
        NSNumber *number = self.nameMenu[swipeView.currentItemIndex];
        
                [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:ENTERTAINMENT withSubCate:[number intValue] :nil]}];
                [Manager savePageView:0 orSubCate:[number intValue]];
        lastStatPage = (int)swipeView.currentItemIndex;
    }
    
}
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView{
    lastStatPage = (int)swipeView.currentItemIndex;
    //
    NSNumber* number = self.nameMenu[swipeView.currentItemIndex];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:ENTERTAINMENT withSubCate:[number intValue] :nil]}];
    [Manager savePageView:0 orSubCate:[number intValue]];
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
    
    if([[Manager sharedManager] bannerArrayEntertainment]){
        temp  = [[Manager sharedManager] bannerArrayEntertainment ][index];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    if([[Manager sharedManager] bannerArrayEntertainment]){
        return [[Manager sharedManager]bannerArrayEntertainment].count;
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
    
    if([[Manager sharedManager] bannerArrayEntertainment]){
        temp  = [[Manager sharedManager] bannerArrayEntertainment ][index];
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
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
    
    _swipeViewHoro.delegate = nil;
    _swipeViewHoro.dataSource = nil;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // The container should have already been opened, otherwise events pushed to
    // the data layer will not fire tags in that container.
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    [dataLayer push:@{@"event": @"openScreen", @"screenName": @"Entertainment"}];
    
}

@end