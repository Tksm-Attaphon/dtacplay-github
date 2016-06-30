//
//  COLOR_NEWS
//  dtacplay
//
//  Created by attaphon on 10/25/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "FreeZoneViewController.h"
#import "DtacImage.h"
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
#import "MusicContent.h"
#import "GameContent.h"
#import "AppContent.h"
#import "Manager.h"
#import "MBProgressHUD.h"
#import "DtacPlayBlockCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HoroViewController.h"
#import "SVPullToRefresh.h"
#import "MusicCell.h"
#import "GameCell.h"
#import "AppCell.h"
#import "FreeZoneDetialController.h"
#import "GameDetailViewController.h"
#import "ApplicationFreeViewController.h"
#import "RegisterFreeZone.h"
#import "PopUp.h"
#import "Banner.h"
#import "BannerImage.h"
#import "FreeSMSCollectionViewCell.h"
#import "PopUpYESAndNO.h"
#import <CommonCrypto/CommonDigest.h>
@interface FreeZoneViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RegisterFreeZoneDelegate,PopUpDelegate,RegisterFreeZoneDelegate,UITextViewDelegate,PopUpYESAndNODelegate>
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
    
    BOOL isKeyboardShow;
    RegisterFreeZone *views;
    PopUp* ppp;
    UIView *black;
    PopUpYESAndNO * popupYesAndNo;
    
    NSString* vierfyCode ;
    NSString *phonNumber_Mssid;
    
    NSTimer *timer;
    
    int lastStatPage ;
    
    FreeSMSCollectionViewCell *tempCell;
    
    int freeZoneValue;
}
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation FreeZoneViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"alert"
                                                  object:nil];
}
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
         NSLog(@"%f",imageHeader.frame.origin.y);
        if(scrollView.contentOffset.y == 0){
            self.collectionView.contentOffset = CGPointMake(0, 0);
        }
       
        self.lastContentOffset =scrollView.contentOffset.y;
    }
}
-(void)refreshPage:(int)current{
    int number = [pageArray[current] intValue];
    number = number + 1;
    pageArray[current] = [NSNumber numberWithInt:number];
    
    SubCategorry subcate ;
    NSString *jsonString ;
    switch ([self.nameMenu[current] intValue]) {
        case FREEZONE_MUSIC:
            subcate = FREEZONE_MUSIC;
            jsonString = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusic\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14 ,\"suggest\":false}}",(long)subcate,number];
            break;
        case FREEZONE_GAME:
            subcate = FREEZONE_GAME;
            jsonString = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14 ,\"suggest\":false,\"opera\":null}}",(long)FREEZONE_GAME,number];
            break;
        case FREEZONE_APPLICATION:
            subcate = FREEZONE_APPLICATION;
            jsonString = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplication\",\"params\":{\"page\":%d,\"limit\":14 ,\"suggest\":false}}",number];
            
            break;
        case FREEZONE_RECOMMENDED_APPLICATION:
            subcate = FREEZONE_RECOMMENDED_APPLICATION;
            jsonString = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplication\",\"params\":{\"page\":%d,\"limit\":14 ,\"suggest\":false}}",number];
            
            break;
        default:
            break;
    }
    
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
            NSMutableArray *tempArray =  objectArray.count >0 ? objectArray[0]  : nil;
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            
            for(NSDictionary* temp in content){
                if(subcate == FREEZONE_MUSIC){
                    MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                    [tempArray addObject:preview];
                }
                else if(subcate == FREEZONE_GAME){
                    GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                    [tempArray addObject:preview];
                }
                else{
                    AppContent *preview = [[AppContent alloc]initWithDictionary:temp];
                    [tempArray addObject:preview];
                }
                
                
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
-(void)getMusicAtIndex:(int)index{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusic\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14,\"suggest\":false }}",(long)FREEZONE_MUSIC,1];
    
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
            
            for(NSDictionary* temp in content){
                
                MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
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
-(void)getGameAtIndex:(int)index{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14 ,\"suggest\":false,\"opera\":null}}",(long)FREEZONE_GAME,1];
    
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
            // int i = 0;
            
            NSMutableArray*  tempArray ;
            
            tempArray = [[NSMutableArray alloc]init];
            
            for(NSDictionary* temp in content){
                
                GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
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
-(void)getAppAtIndex:(int)index{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplication\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14 ,\"suggest\":false}}",FREEZONE_APPLICATION,1];
    
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
            int i = 0;
            
            NSMutableArray*  tempArray ;
            
            tempArray = [[NSMutableArray alloc]init];
            
            for(NSDictionary* temp in content){
                
                AppContent *preview = [[AppContent alloc]initWithDictionary:temp];
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
-(void)getRecAppAtIndex:(int)index{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplication\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14 ,\"suggest\":false}}",FREEZONE_RECOMMENDED_APPLICATION,1];
    
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
            int i = 0;
            
            NSMutableArray*  tempArray ;
            
            tempArray = [[NSMutableArray alloc]init];
            
            for(NSDictionary* temp in content){
                
                AppContent *preview = [[AppContent alloc]initWithDictionary:temp];
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
            articleView.cate = FREEZONE;
            articleView.subcate = FREEZONE_MUSIC;
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
-(void)getAppByID:(NSString*)ID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplicationById\",\"params\":{\"appId\":%@}}",ID];
    
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
            
            ApplicationFreeViewController* articleView= [[ApplicationFreeViewController alloc]init];
            AppContent *obj = [[AppContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.appObject = obj;
            articleView.cate = obj.cate;
            articleView.subcate = obj.subcate;

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
            
            articleView.cate = FREEZONE;
            articleView.subcate = FREEZONE_GAME;
            
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

-(void)setup{
    allObjectArray = [[NSMutableArray alloc]init];
    pageArray = [[NSMutableArray alloc]init];
     lastStatPage = self.indexPage ;
    
    for (int i = 0; i < self.nameMenu.count; i++) {
        [allObjectArray addObject:[[NSMutableArray alloc]init]];
        [pageArray addObject:[NSNumber numberWithInt:1]];
        switch ([self.nameMenu[i] intValue]) {
            case FREEZONE_MUSIC:
                [self getMusicAtIndex:i];
                break;
            case FREEZONE_GAME:
                [self getGameAtIndex:i];
                break;
                
            case FREEZONE_APPLICATION:
                [self getAppAtIndex:i];
                break;
            case FREEZONE_RECOMMENDED_APPLICATION:
                [self getRecAppAtIndex:i];
                break;
            default:
                break;
        }
    }
    
    
    [Manager savePageView:4 orSubCate:0];
    
    //initial submenu
    menuArray = self.nameMenu;
    
    totalPage = (int)menuArray.count;
    
    indicatorMenu = [[UIView alloc]initWithFrame:CGRectMake(0, 0,50, 2.5 )];
    [indicatorMenu setBackgroundColor:_themeColor];
    
    collectionViewArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i<menuArray.count; i++) {
        
        sizeArray = [[NSMutableArray alloc]init];
        MyFlowLayout *layout=[[MyFlowLayout alloc] init];
        
        UICollectionView *fooCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-65) collectionViewLayout:layout];
        
        fooCollection.tag = i;
        [fooCollection setDataSource:self];
        [fooCollection setDelegate:self];
        [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmptyCell"];
        switch ([self.nameMenu[i] intValue]) {
            case FREEZONE_MUSIC:
                [fooCollection registerClass:[MusicCell class] forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
                break;
            case FREEZONE_GAME:
                [fooCollection registerClass:[AppCell class] forCellWithReuseIdentifier:@"GameCell"];
                break;
            case FREEZONE_APPLICATION:
                [fooCollection registerClass:[AppCell class] forCellWithReuseIdentifier:@"AppCell"];
                break;
            case FREEZONE_RECOMMENDED_APPLICATION:
                [fooCollection registerClass:[AppCell class] forCellWithReuseIdentifier:@"AppCell"];
                break;
            case FREEZONE_REGISTER:
                [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"RegisFreeZone"];//FreeSMSCell
                
                break;
            case FREEZONE_FREESMS:
         
                [fooCollection registerNib:[UINib nibWithNibName:@"FreeSMS" bundle:nil] forCellWithReuseIdentifier:@"FreeSMSCell"];
                
                break;
            default:
                
            
                break;
        }
        
        
        [fooCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        //            UINib *cellNib = [UINib nibWithNibName:@"BlockCollectionViewCell" bundle:nil];
        //            [fooCollection registerNib:cellNib forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
        [fooCollection setBackgroundColor:[UIColor clearColor]];
        
        [fooCollection scrollsToTop];
        
        [fooCollection addSubview:iconHeader];
        [collectionViewArray addObject:fooCollection];
        
        if(self.indexPage == i && self.indexPage != 4){
            self.collectionView =fooCollection;
            __weak FreeZoneViewController *weakSelf = self;
            
            // setup pull-to-refresh
            [fooCollection addInfiniteScrollingWithActionHandler:^{
                [weakSelf insertRowAtTop];
            }];
        }
        
    }
    
    
    
}
- (void)insertRowAtTop {
    int current = _swipeView.currentItemIndex;
    __weak FreeZoneViewController *weakSelf = self;
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
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdFreezone]];
    
    
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
            
            [[Manager sharedManager] setBannerArrayFreezone:bannerArray];
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayFreezone].count;
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
    [self setCateID:FREEZONE];
    if(![[Manager sharedManager]bannerArrayFreezone])
        [self getBanner];
     //[Manager savePageView:4];
    //
    //    for (int i = 0 ; i <50; i++) {
    //        NSInteger randomNumber = arc4random() %1000000;
    //        NSLog(@"%d",randomNumber);
    //    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _themeColor = [UIColor colorWithHexString:COLOR_FREEZONE];
    self.navigationItem.title = @"ฟรีโซน";
    
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
    
    self.swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-45)];
    [self.swipeView setBackgroundColor:[UIColor clearColor]];
    _swipeView.pagingEnabled = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    [self.view addSubview:_swipeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
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
    pageControl.numberOfPages = [[Manager sharedManager] bannerArrayFreezone].count >0  ? [[Manager sharedManager] bannerArrayFreezone].count : [[Manager sharedManager] bannerArray].count;
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    pageControl.userInteractionEnabled = NO;
    [_carousel addSubview:pageControl];
    [timer invalidate];
    timer = nil;
    timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                              target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];    //            imageHeaderImage = [[JBKenBurnsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300 )];
    //            [imageHeaderImage animateWithImages:@[[UIImage imageNamed:@"banner_dtacplay.png"]]
    //                             transitionDuration:50
    //                                   initialDelay:0
    //                                           loop:YES
    //                                    isLandscape:YES];
    
    [_swipeView addSubview:imageHeader];

   // [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:FREEZONE withSubCate:self.subeType :nil]}];


    
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
        NSString *nameMenu= [Manager getSubcateName:[self.nameMenu[i]  intValue] withThai:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button addTarget:self
                   action:@selector(menuPress:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%@",nameMenu] forState:UIControlStateNormal];
        
        [button setTintColor:_themeColor];
        UIFont *myFont = [UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM==IPAD ? 21: 16];
        button.titleLabel.font = myFont;
        CGSize textSize = [[NSString stringWithFormat:@"%@",nameMenu]  sizeWithAttributes:@{NSFontAttributeName:myFont}];
        
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
     NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
    switch ([self.nameMenu[collectionView.tag] intValue]) {
        case FREEZONE_MUSIC:
            return object.count;
            break;
        case FREEZONE_GAME:
            return object.count;
            break;
        case FREEZONE_APPLICATION:
            return object.count;
            break;
        case FREEZONE_RECOMMENDED_APPLICATION:
            return object.count;
            break;
        default:
            return 1;
            break;
    }
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
        NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
        NSMutableArray *temp = object.count>0 ? object[section] : nil;
       
  
    switch ([self.nameMenu[collectionView.tag] intValue]) {
        case FREEZONE_MUSIC:
            return temp.count;
            break;
        case FREEZONE_GAME:
            return temp.count;
            break;
        case FREEZONE_APPLICATION:
            if(temp.count>4)
                return temp.count;
            else
                return temp.count+1;
            break;
        case FREEZONE_RECOMMENDED_APPLICATION:
            if(temp.count>4)
                return temp.count;
            else
                return temp.count+1;
            break;
        case FREEZONE_REGISTER:
            return 2;
            break;
        case FREEZONE_FREESMS:
            return 2;
            break;
        default:
            return 3;
            break;
    }
    
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
    
    if(section == 0){
        
        UIEdgeInsets inset = UIEdgeInsetsMake(posTopCollectionView+menuHeight,10,10,10);
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
    
    NSLog(@"draw cell of collection : %ld",(long)collectionView.tag);
    
    if([self.nameMenu[collectionView.tag] intValue]== FREEZONE_MUSIC){
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        MusicContent *articleTemp = tempArray[indexPath.row];
        
        NSString *identify = @"BlockCollectionViewCell";
        MusicCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailXL]
                              placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
     
        [cell.nameMusicLabel setText:articleTemp.title];
        [cell.imageView setBackgroundColor:[UIColor clearColor]];
        [cell.nameArtistLabel setText:articleTemp.artist];
        [cell.nameAlbumLabel setText:articleTemp.album];
        
        NSLog(@"%f , %f , %f",cell.nameMusicLabel.frame.origin.y,cell.nameArtistLabel.frame.origin.y,cell.nameAlbumLabel.frame.origin.y);
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
        
        return cell;
    }
    else if ([self.nameMenu[collectionView.tag] intValue]== FREEZONE_GAME){
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
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
    else if([self.nameMenu[collectionView.tag] intValue]== FREEZONE_APPLICATION||[self.nameMenu[collectionView.tag] intValue]== FREEZONE_RECOMMENDED_APPLICATION){
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        
        if(tempArray.count != indexPath.row){
        AppContent *articleTemp = tempArray[indexPath.row];
        NSString *identify = @"AppCell";
        
        AppCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
                              placeholderImage:[UIImage imageNamed:@"default_image_02_L.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
   
        
        [cell.title setText:articleTemp.title];
        [cell.imageView setBackgroundColor:[UIColor clearColor]];
        [cell.desc setText:articleTemp.descriptionContent];
        
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
        
        return cell;
        }else{
      
            NSString *identify = @"EmptyCell";
            UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            
            [cell setBackgroundColor:[UIColor whiteColor]];
                return cell;
        }
    }
    else if([self.nameMenu[collectionView.tag] intValue]== FREEZONE_REGISTER){
        if(indexPath.row == 0){
            NSString *identify = @"RegisFreeZone";
            UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            [img setImage:[UIImage imageNamed:@"freezoneImage.jpg"]];
            [cell addSubview:img];
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(registerFreezone:)];
            [img addGestureRecognizer:singleFingerTap];
            [img setUserInteractionEnabled:YES];
            
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
            NSString *identify = @"EmptyCell";
            UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            return cell;
        }
    }
    else if([self.nameMenu[collectionView.tag] intValue]== FREEZONE_FREESMS){
        if(indexPath.row == 0){
            NSString *identify = @"FreeSMSCell";
            FreeSMSCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            cell.head_1.textColor = [UIColor colorWithHexString:COLOR_FREEZONE];
            [cell.line setBackgroundColor:[UIColor colorWithHexString:COLOR_FREEZONE]];
            
            cell.messageTextView.delegate = self;
            cell.boxView.layer.masksToBounds = NO;
            cell.boxView.layer.shadowOffset = CGSizeMake(2, 2);
            cell.boxView.layer.shadowRadius = 2;
            cell.boxView.layer.shadowOpacity = 0.5;
            cell.boxView.layer.shouldRasterize = YES;
            cell.boxView.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
            [cell.boxView setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
            
            [cell.sendButton addTarget:self
                                action:@selector(sendSMS:) forControlEvents:UIControlEventTouchDown];
            [cell.cancelButton addTarget:self
                                  action:@selector(cancelSMS:) forControlEvents:UIControlEventTouchDown];
            
            tempCell = cell;
            return cell;
        }
        else{
            NSString *identify = @"EmptyCell";
            UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            return cell;
        }
    }
    else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_1 = (self.view.frame.size.width/2 -15);
    //float w_1_ipad = (self.view.frame.size.width/2 -30);
    
    
    switch ([self.nameMenu[collectionView.tag] intValue]) {
        case FREEZONE_MUSIC://video
            
            
            return CGSizeMake(w_1,w_1+45);
            break;
        case FREEZONE_GAME://video
            
            return CGSizeMake(w_1,w_1+45);
            break;
        case FREEZONE_APPLICATION://video
            
            return CGSizeMake(w_1,w_1+45);
            break;
        case FREEZONE_RECOMMENDED_APPLICATION://video
            
            return CGSizeMake(w_1,w_1+45);
            break;
        case FREEZONE_REGISTER://register freezone
            if(indexPath.row == 0)
                return CGSizeMake(self.view.frame.size.width-20,((self.view.frame.size.width-20)*500)/750);
            else
                return CGSizeMake(self.view.frame.size.width-20, (self.view.frame.size.height-menuHeight - (((self.view.frame.size.width-20)*500)/750)) > 0 ? self.view.frame.size.height -menuHeight- (((self.view.frame.size.width-20)*500)/750)+50 : 50 );
            break;
        case FREEZONE_FREESMS://register freezone
            if(indexPath.row == 0)
                 return CGSizeMake(self.view.frame.size.width-20,386);

            else
                return CGSizeMake(self.view.frame.size.width-20, (self.view.frame.size.height-menuHeight - (((self.view.frame.size.width-20)*500)/750)) > 0 ? self.view.frame.size.height -menuHeight- (((self.view.frame.size.width-20)*500)/750)+50 : 50 );
            break;
        default:
            
            return CGSizeMake(w_1,w_1+45);
            break;
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_nameMenu[collectionView.tag] intValue] == FREEZONE_MUSIC){
        
        NSArray *object = allObjectArray[currentPage];
        NSMutableArray *temp =  object[indexPath.section];
        MusicContent *preview = temp[indexPath.row];
        
        
        [self getMusicByID:preview.musicID];
    }else if([_nameMenu[collectionView.tag] intValue] == FREEZONE_GAME){
        NSArray *object = allObjectArray[currentPage];
        NSMutableArray *temp =  object[indexPath.section];
        GameContent *preview = temp[indexPath.row];
        
        [self getGameByID:preview.gameID];
    }
    else if([_nameMenu[collectionView.tag] intValue] == FREEZONE_APPLICATION || [_nameMenu[collectionView.tag] intValue] == FREEZONE_RECOMMENDED_APPLICATION){
        NSArray *object = allObjectArray[currentPage];
        NSMutableArray *temp =  object[indexPath.section];
        AppContent *preview = temp[indexPath.row];
        
        [self getAppByID:preview.appID];
    }
    else if([_nameMenu[collectionView.tag] intValue] == FREEZONE_REGISTER){
        [self.view endEditing:YES];
    }
    else if([_nameMenu[collectionView.tag] intValue] == FREEZONE_FREESMS){
        [self.view endEditing:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    //        if(section>=1){
    //            if(section == 1){
    //               // NSArray* temp = allObjectArray[collectionView.tag] ;
    //               // NSArray*temp2 = temp[1];
    //                //if(temp2.count <8){
    //                //    return CGSizeZero;
    //                //}
    //               // else{
    //                    return CGSizeMake(self.view.frame.size.width,110);
    //              //  }
    //            }
    return CGSizeZero;
    //        }
    //        return CGSizeMake(self.view.frame.size.width,110);
    
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
- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    isKeyboardShow = YES;
    NSDictionary* keyboardInfo = [notif userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float y =views.frame.origin.y-  keyboardFrameBeginRect.size.height/2;
    [UIView animateWithDuration:0.1 animations:^{
        views.frame =  CGRectMake(views.frame.origin.x,y , views.frame.size.width, views.frame.size.height);
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
  
}
- (void)textViewDidChange:(UITextView *)textView{
    if(textView == tempCell.messageTextView){
        tempCell.text70word.text = [NSString stringWithFormat:@"1 ข้อความไม่เกิน %lu ตัวอักษร",70-textView.text.length];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 69)
    {
        return NO;
    }
    return YES;
}
- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    isKeyboardShow = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        [views setCenter:CGPointMake(views.center.x, self.view.frame.size.height / 2.0 - 60)];
    }];
}
-(void)sendSMS:(id)sender{
    if(tempCell.phoneNumber.text.length==10 && tempCell.messageTextView.text.length>0){
    [Manager savePageView:0 orSubCate:FREEZONE_FREESMS];
    
    freeZoneValue = 2;// sms
    NSString *phoneNumber;
    if([[Manager sharedManager] phoneNumber].length > 0){
        phoneNumber = [[[Manager sharedManager] phoneNumber]
                       stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
    }
    black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.view addSubview:black];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hidePopup:)];
    [black addGestureRecognizer:singleFingerTap];
    
    views = [[[NSBundle mainBundle] loadNibNamed:@"RegisterFreeZone" owner:self options:nil] objectAtIndex:0];
    [views setFrame:CGRectMake(10,100, self.view.frame.size.width-20, 329)];
    views.tag = 1;
    views.phoneNumberTextField.text = phoneNumber;
    views.delegate = self;
    [views setBackgroundColor:[UIColor whiteColor]];
    views.alpha = 0.8;
    [views setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0 -60)];
    [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0 -60)];
    [self.view addSubview:views];
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        views.alpha = 1;
                        [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
                    }
                    completion:nil];
        
    }else{
        if(tempCell.phoneNumber.text.length == 0){
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@""
                                      message:@"กรุณากรอกเบอร์ปลายทางค่ะ"
                                      delegate:self
                                      cancelButtonTitle:@"ตกลง"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if(tempCell.phoneNumber.text.length!=10){
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@""
                                      message:@"กรุณากรอกเบอร์ปลายทางให้ถูกต้องค่ะ"
                                      delegate:self
                                      cancelButtonTitle:@"ตกลง"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@""
                                      message:@"กรุณากรอกข้อความที่ต้องการส่งค่ะ"
                                      delegate:self
                                      cancelButtonTitle:@"ตกลง"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }

}
-(void)cancelSMS:(id)sender{
    black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.view addSubview:black];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hidePopup:)];
    [black addGestureRecognizer:singleFingerTap];
    popupYesAndNo = [[[NSBundle mainBundle] loadNibNamed:@"PopUpYESAndNO" owner:self options:nil] objectAtIndex:0];
    popupYesAndNo.delegate = self;
    [popupYesAndNo setBackgroundColor:[UIColor whiteColor]];
    [popupYesAndNo setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    [self.view addSubview:popupYesAndNo];
    [popupYesAndNo setFrame:CGRectMake(popupYesAndNo.frame.origin.x+self.view.frame.size.width,popupYesAndNo.frame.origin.y, 257, 132)];
    [UIView transitionWithView:self.view
                      duration:0.2
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        [popupYesAndNo setFrame:CGRectMake(popupYesAndNo.frame.origin.x-self.view.frame.size.width,popupYesAndNo.frame.origin.y, 257, 132)];
                    }
                    completion:^(BOOL finished){
                      //  [popupYesAndNo removeFromSuperview];
                    }];
    

}
-(void)buttonPupUpYesAndNOPress:(BOOL)isYES{
    
    if(isYES){
         tempCell.messageTextView.text = @"";
        tempCell.phoneNumber.text = @"";
        [popupYesAndNo removeFromSuperview];
        [black removeFromSuperview];
        
    }
    else{
        [popupYesAndNo removeFromSuperview];
        [black removeFromSuperview];
    }
}
-(void)submitFreeSMS:(NSString*)number{
    
    //mGAD
    //Psvi
    NSString *newStr = [tempCell.phoneNumber.text substringFromIndex:1];
   NSString* numberPhone =  [NSString stringWithFormat:@"66%@",newStr ];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"sendSMS\",\"params\":{ \"verifyMsg\":\"%@\", \"verifyCode\":\"%@\",\"sender\":%@,\"receiver\":%@, \"message\":\"%@\",\"mms\":null }}",vierfyCode,[self calculateSHA:number],phonNumber_Mssid,numberPhone,tempCell.messageTextView.text];
    
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject objectForKey:@"result"]){
            if ([[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
                ppp.titleLabel.text = @"คุณกรอกรหัสผ่านไม่ถูกต้อง";
                ppp.delegate = self;
                [ppp setBackgroundColor:[UIColor whiteColor]];
                [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
                [self.view addSubview:ppp];
                [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                [UIView transitionWithView:self.view
                                  duration:0.2
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    views.alpha = 1;
                                    [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                    [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                                }
                                completion:^(BOOL finished){
                                    
                                }];
            }
            else{
                NSDictionary *temp = [responseObject objectForKey:@"result"];//คุณส่งข้อความในเดือนนี้เต็มจำนวน 30 ข้อความแล้ว กรุณาส่งใหม่ในเดือนถัดไปนะคะ
                ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
                ppp.titleLabel.text = [NSString stringWithFormat:@"คุณส่งข้อความในเดือนนี้ไปแล้วจำนวน %@ ข้อความ",[temp objectForKey:@"total"]/*[[temp objectForKey:@"total"] intValue]*/];
                
                if([[temp objectForKey:@"total"] intValue]>30){
                    ppp.titleLabel.text = [NSString stringWithFormat:@"คุณส่งข้อความในเดือนนี้เต็มจำนวน 30 ข้อความแล้ว กรุณาส่งใหม่ในเดือนถัดไปนะคะ"];

                }
                ppp.delegate = self;
                ppp.type = 1;
                [ppp setBackgroundColor:[UIColor whiteColor]];
                [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
                [self.view addSubview:ppp];
                [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                [UIView transitionWithView:self.view
                                  duration:0.2
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    views.alpha = 1;
                                    [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                    [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                                }
                                completion:^(BOOL finished){
                                    
                                }];
            }
        }
        else{
            ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
            ppp.titleLabel.text = @"คุณกรอกรหัสผ่านไม่ถูกต้อง";
            ppp.delegate = self;
            [ppp setBackgroundColor:[UIColor whiteColor]];
            [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
            [self.view addSubview:ppp];
            [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
            [UIView transitionWithView:self.view
                              duration:0.2
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                views.alpha = 1;
                                [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                            }
                            completion:^(BOOL finished){
                                
                            }];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
    
}
-(void)registerFreezone:(id*)button{
     [Manager savePageView:0 orSubCate:FREEZONE_REGISTER];
    freeZoneValue = 1;
    NSString *phoneNumber;
    if([[Manager sharedManager] phoneNumber].length > 0){
        phoneNumber = [[[Manager sharedManager] phoneNumber]
                       stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
    }
    black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.view addSubview:black];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hidePopup:)];
    [black addGestureRecognizer:singleFingerTap];
    
    views = [[[NSBundle mainBundle] loadNibNamed:@"RegisterFreeZone" owner:self options:nil] objectAtIndex:0];
    [views setFrame:CGRectMake(10,100, self.view.frame.size.width-20, 329)];
    views.tag = 1;
    views.phoneNumberTextField.text = phoneNumber;
    views.delegate = self;
    [views setBackgroundColor:[UIColor whiteColor]];
    views.alpha = 0.8;
    [views setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0 -60)];
    [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0 -60)];
    [self.view addSubview:views];
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        views.alpha = 1;
                        [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
                    }
                    completion:nil];
    
}
-(void)buttonPupUpPress:(PopUp*)type{
    if(type.type != 1){
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x+self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                        }
                        completion:^(BOOL finished){
                            [ppp removeFromSuperview];
                        }];
    }else{
        [ppp removeFromSuperview];
        [black removeFromSuperview];
        [views removeFromSuperview];
    }
}
-(void)submitPhoneNumber:(int)type phone:(NSString *)number{
    
    if(type == 0){
        ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
        ppp.titleLabel.text = @"กรุณากรอกหมายเลขโทรศัพท์มือถือเพื่อรับรหัสผ่านก่อนนะคะ";
        ppp.delegate = self;
        [ppp setBackgroundColor:[UIColor whiteColor]];
        [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        [self.view addSubview:ppp];
        [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                        }
                        completion:^(BOOL finished){
                            
                        }];
        
        
        
    }
    else{
        
        [self sendRegisterFreezone:number];
    }
}
-(void)submitOTPNumber:(int)type code:(NSString *)number{
    if(type == 0){
        ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
        ppp.titleLabel.text = @"คุณกรอกรหัสผ่านไม่ถูกต้อง";
        ppp.delegate = self;
        [ppp setBackgroundColor:[UIColor whiteColor]];
        [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        [black addSubview:ppp];
        [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                        }
                        completion:^(BOOL finished){
                            
                        }];
        
        
        
    }
    else{
        if(freeZoneValue == 1){
            [self submitRegisterFreezone:number];
            
        }
        else{
            [self submitFreeSMS:number ];
        }
       
    }
}
-(void)hidePopup:(id)sender{
    
    if(isKeyboardShow == NO){
        [UIView transitionWithView:self.view
                          duration:0.25
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [black removeFromSuperview];
                            [ppp removeFromSuperview];
                            [views removeFromSuperview];
                        }
                        completion:nil];
        
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)sendRegisterFreezone:(NSString*)number{
    
    NSString *phoneNumber = [number substringWithRange:NSMakeRange(1, [number length]-1)];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getOTP\",\"params\":{ \"otpType\":%d, \"msisdn\":66%@ }}",freeZoneValue,phoneNumber];
    
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]] && [responseObject objectForKey:@"result"]) {
            
            NSDictionary* dic = [responseObject objectForKey:@"result"];
            
            vierfyCode = [dic objectForKey:@"verifyMsg"];//verifyMsg;
            phonNumber_Mssid =  [NSString stringWithFormat:@"66%@", phoneNumber];
            [views.submitPhoneButton setUserInteractionEnabled:NO];
            [views.submitPhoneButton setAlpha:0.5];
            views.codeReference.text = [NSString stringWithFormat:@"กรอกรหัสผ่านเพื่อเข้าใช้งาน (%@)",vierfyCode];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@""
                                      message:@"กรุณารอรับรหัส OTP ผ่านทาง SMS ค่ะ"
                                      delegate:self
                                      cancelButtonTitle:@"ตกลง"
                                      otherButtonTitles:nil];
            [alertView show];
            
        }
        else{
            ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
            ppp.titleLabel.text = @"เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง";
            ppp.delegate = self;
            [ppp setBackgroundColor:[UIColor whiteColor]];
            [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
            [self.view addSubview:ppp];
            [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
            [UIView transitionWithView:self.view
                              duration:0.2
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                views.alpha = 1;
                                [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                            }
                            completion:^(BOOL finished){
                                
                            }];
            
            
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
        ppp.titleLabel.text = @"เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง";
        ppp.delegate = self;
        [ppp setBackgroundColor:[UIColor whiteColor]];
        [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        [self.view addSubview:ppp];
        [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                        }
                        completion:^(BOOL finished){
                            
                        }];
    }];
    [op start];
    
}
-(void)submitRegisterFreezone:(NSString*)number{
    
    //mGAD
    //Psvi
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"freeZoneReg\",\"params\":{ \"verifyMsg\":\"%@\", \"verifyCode\":\"%@\",\"msisdn\":%@ }}",vierfyCode,[self calculateSHA:number],phonNumber_Mssid];
    
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject objectForKey:@"result"]){
            if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
                ppp.titleLabel.text = @"คุณกรอกรหัสผ่านไม่ถูกต้อง";
                ppp.delegate = self;
                [ppp setBackgroundColor:[UIColor whiteColor]];
                [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
                [self.view addSubview:ppp];
                [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                [UIView transitionWithView:self.view
                                  duration:0.2
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    views.alpha = 1;
                                    [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                    [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                                }
                                completion:^(BOOL finished){
                                    
                                }];
            }
            else{
                
                ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
                if(freeZoneValue == 1)
                    ppp.titleLabel.text = @"คุณสมัครสมาชิกฟรีโซนเรียบร้อยเเล้วค่ะ";
                ppp.delegate = self;
                ppp.type = 1;
                [ppp setBackgroundColor:[UIColor whiteColor]];
                [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
                [self.view addSubview:ppp];
                [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                [UIView transitionWithView:self.view
                                  duration:0.2
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    views.alpha = 1;
                                    [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                    [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                                }
                                completion:^(BOOL finished){
                                    
                                }];
            }
        }
        else{
            ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
            ppp.titleLabel.text = @"คุณกรอกรหัสผ่านไม่ถูกต้อง";
            ppp.delegate = self;
            [ppp setBackgroundColor:[UIColor whiteColor]];
            [ppp setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
            [self.view addSubview:ppp];
            [ppp setFrame:CGRectMake(ppp.frame.origin.x+self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
            [UIView transitionWithView:self.view
                              duration:0.2
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                views.alpha = 1;
                                [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                [ppp setFrame:CGRectMake(ppp.frame.origin.x-self.view.frame.size.width,ppp.frame.origin.y, 257, 132)];
                            }
                            completion:^(BOOL finished){
                                
                            }];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
    
}
-(void)whenClosePopUp:(int)type{
    [ppp removeFromSuperview];
    [black removeFromSuperview];
    [views removeFromSuperview];
}
- (NSString *)calculateSHA:(NSString *)yourString
{
    const char *ptr = [yourString UTF8String];
    
    int i =0;
    int len = strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}
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
    if(currentPage !=4){
        __weak FreeZoneViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [ self.collectionView  addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
        self.collectionView.showsInfiniteScrolling = YES;
    }
    
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    if(swipeView.currentItemIndex != lastStatPage){
        //

                [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:FREEZONE withSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue] :nil]}];
                [Manager savePageView:0 orSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue]];
 
        lastStatPage = (int)swipeView.currentItemIndex;
    }
    
}
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView{
    lastStatPage = (int)swipeView.currentItemIndex;
    //
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:FREEZONE withSubCate:[self.nameMenu[swipeView.currentItemIndex] intValue] :nil]}];
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
    if([[Manager sharedManager] bannerArrayFreezone]){
        return [[Manager sharedManager]bannerArrayFreezone].count;
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
    
    if([[Manager sharedManager] bannerArrayFreezone]){
        temp  = [[Manager sharedManager] bannerArrayFreezone ][index];
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
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    
    if([[Manager sharedManager] bannerArrayFreezone]){
        temp  = [[Manager sharedManager] bannerArrayFreezone ][index];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
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

@end