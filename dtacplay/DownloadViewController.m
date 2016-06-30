//
//  COLOR_NEWS
//  dtacplay
//
//  Created by attaphon on 10/25/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DownloadViewController.h"

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
#import "CPACell.h"
#import "GameDetailViewController.h"
#import "FreeZoneDetialController.h"
#import "ListContentDownloadViewController.h"

#import "CPAContent.h"

@interface DownloadViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
    
    NSMutableArray *game_array;
    NSMutableArray *game_new_array;
    NSMutableArray *game_hit_array;
    NSMutableArray *game_club_array;
    NSMutableArray *game_room_array;
    
    NSMutableArray *music_array;
    NSMutableArray *music_new_array;
    NSMutableArray *music_hit_array;
    NSMutableArray *music_inter_array;
    NSMutableArray *music_lookthoong_array;
    
    NSMutableArray *news_array;
    NSMutableArray *news_hit_array;
    NSMutableArray *news_gossip_array;
    NSMutableArray *news_eco_array;
    
    NSMutableArray *horo_array;
    NSMutableArray *horo_sub_array;
    
    NSMutableArray *lucky_array;
    NSMutableArray *lucky_sub_array;
    
    NSMutableArray *lifestyle_array;
    NSMutableArray *lifestyle_quize_array;
    NSMutableArray *lifestyle_movie_array;
    NSMutableArray *lifestyle_buety_array;
    
    NSMutableArray *sport_array;
    NSMutableArray *sport_football_array;
    NSMutableArray *sport_other_array;
    
    NSMutableArray *clip_array;
    NSMutableArray *clip_free_array;
    NSMutableArray *clip_premium_array;
    int lastStatPage ;
    
}
@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation DownloadViewController
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
            NSMutableArray *tempArray = objectArray[0] ;
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
    
}
-(void)GetContentDownload:(int)index AndSubCate:(int)subcat limit:(int)limit{
    
    
    NSString *
    jsonString ;
    if([_nameMenu[index] intValue] == DOWNLOAD_GAME){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"subCateId\":%d,\"page\":%d,\"limit\":%d,\"suggest\":false ,\"opera\":null}}",subcat,1,limit];
    }else if([_nameMenu[index] intValue] == DOWNLOAD_MUSIC){
        
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusic\",\"params\":{\"subCateId\":%d,\"page\":%d,\"limit\":%d,\"suggest\":false }}",subcat,1,limit];
    }
    else{
        
        switch (subcat) {
            case DOWNLOAD_CPA_NEWS_HIT:
                jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":1,\"cpaSubCateId\":1 }}"];
                break;
            case DOWNLOAD_CPA_NEWS_GOSSIP:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":1,\"cpaSubCateId\":2 }}"];
                break;
            case DOWNLOAD_CPA_NEWS_ECO:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":1,\"cpaSubCateId\":3 }}"];
                break;
            case DOWNLOAD_CPA_HORO:
                jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":2,\"cpaSubCateId\":4 }}"];
                break;
            case DOWNLOAD_CPA_LUCKY_NUMBER:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":3,\"cpaSubCateId\":5 }}"];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":4,\"cpaSubCateId\":6 }}"];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":4,\"cpaSubCateId\":7 }}"];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
              jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":4,\"cpaSubCateId\":8 }}"];
                break;
            case DOWNLOAD_CPA_SPORT_FOOTBALL:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":5,\"cpaSubCateId\":9 }}"];
                break;
            case DOWNLOAD_CPA_SPORT_OTHER:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":5,\"cpaSubCateId\":10 }}"];
                break;
            case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
                 jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":6,\"cpaSubCateId\":11 }}"];
                break;
            case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
                jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaHightlight\", \"params\":{\"cpaCateId\":6,\"cpaSubCateId\":12 }}"];
                break;
            default:
                break;
        }
//        if(subcat == DOWNLOAD_CPA_HORO || subcat == DOWNLOAD_CPA_LUCKY_NUMBER ||subcat == DOWNLOAD_CPA_SPORT_OTHER ||subcat == DOWNLOAD_CPA_SPORT_FOOTBALL|| subcat == DOWNLOAD_CPA_CLIP_FREE_PREMIUM ||subcat == DOWNLOAD_CPA_CLIP_FREE_INTERNET)
//            jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%d, \"page\":%d,\"limit\":6 }}",1,1];
//        else
//            jsonString =  [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentBySubCateId\",\"params\":{ \"subCateId\":%d, \"page\":%d,\"limit\":4 }}",1,1];
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
        
        switch (subcat) {
            case DOWNLOAD_GAME_NEW:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    game_new_array = [[NSMutableArray alloc]init];
                    [game_new_array addObject:[NSNumber numberWithInt:DOWNLOAD_GAME_NEW]];
                    for(NSDictionary* temp in content){
                        
                        GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                        [game_new_array addObject:preview];
                        
                        
                    }
                    
                    [game_array addObject:game_new_array];
                    
                    
                    
                }
                
                break;
            case DOWNLOAD_GAME_HIT:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    game_hit_array = [[NSMutableArray alloc]init];
                    [game_hit_array addObject:[NSNumber numberWithInt:DOWNLOAD_GAME_HIT]];
                    for(NSDictionary* temp in content){
                        
                        GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                        [game_hit_array addObject:preview];
                        
                        
                    }
                    [game_array addObject:game_hit_array];
                    
                }
                
                break;
            case DOWNLOAD_GAME_GAMECLUB:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    game_club_array = [[NSMutableArray alloc]init];
                    [game_club_array addObject:[NSNumber numberWithInt:DOWNLOAD_GAME_GAMECLUB]];
                    for(NSDictionary* temp in content){
                        
                        GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                        [game_club_array addObject:preview];
                        
                        
                    }
                    
                    [game_array addObject:game_club_array];
                }
                
                break;
            case DOWNLOAD_GAME_GAMEROOM:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    game_room_array = [[NSMutableArray alloc]init];
                    [game_room_array addObject:[NSNumber numberWithInt:DOWNLOAD_GAME_GAMEROOM]];
                    for(NSDictionary* temp in content){
                        
                        GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                        [game_room_array addObject:preview];
                        
                        
                    }
                    [game_array addObject:game_room_array];
                }
                break;
            case DOWNLOAD_MUSIC_NEW:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    
                    [music_new_array addObject:[NSNumber numberWithInt:DOWNLOAD_MUSIC_NEW]];
                    for(NSDictionary* temp in content){
                        
                        MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                        [music_new_array addObject:preview];
                        
                        
                    }
                    
                    
                }
                
                break;
            case DOWNLOAD_MUSIC_HIT:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    
                    [music_hit_array addObject:[NSNumber numberWithInt:DOWNLOAD_MUSIC_HIT]];
                    for(NSDictionary* temp in content){
                        
                        MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                        [music_hit_array addObject:preview];
                        
                        
                    }
                    
                }
                
                break;
            case DOWNLOAD_MUSIC_INTER:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    
                    [music_inter_array addObject:[NSNumber numberWithInt:DOWNLOAD_MUSIC_INTER]];
                    for(NSDictionary* temp in content){
                        
                        MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                        [music_inter_array addObject:preview];
                        
                        
                    }
                    
                    
                }
                break;
            case DOWNLOAD_MUSIC_LOOKTHOONG:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * content = [result objectForKey:@"contents"] ;
                    
                    
                    
                    [music_lookthoong_array addObject:[NSNumber numberWithInt:DOWNLOAD_MUSIC_LOOKTHOONG]];
                    for(NSDictionary* temp in content){
                        
                        MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                        [music_lookthoong_array addObject:preview];
                        
                        
                    }
                    
                }
                break;
            case DOWNLOAD_CPA_NEWS_HIT:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                     content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    [news_hit_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_NEWS_HIT]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [news_hit_array addObject:preview];
                        
                        
                    }
                    
                    
                    
                }
                break;
            case DOWNLOAD_CPA_NEWS_GOSSIP:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    
                    
                    [news_gossip_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_NEWS_GOSSIP]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [news_gossip_array addObject:preview];
                        
                        
                    }
                    
                    
                    
                }
                break;
            case DOWNLOAD_CPA_NEWS_ECO:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    
                    
                    [news_eco_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_NEWS_ECO]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [news_eco_array addObject:preview];
                        
                        
                    }
                    
                    
                    
                }
                break;
            case DOWNLOAD_CPA_HORO:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    
                    
                    [horo_sub_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_HORO]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [horo_sub_array addObject:preview];
                        
                        
                    }
                    
                    
                    
                }
                break;
            case DOWNLOAD_CPA_LUCKY_NUMBER:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    
                    
                    [lucky_sub_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_LUCKY_NUMBER]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [lucky_sub_array addObject:preview];
                        
                        
                    }
                    
                    
                    
                }
                break;
            case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    [lifestyle_quize_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_LIFESTYLE_QUIZE]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [lifestyle_quize_array addObject:preview];
                        
                        
                    }
                }
                break;
            case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    [lifestyle_movie_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_LIFESTYLE_MOVIE]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [lifestyle_movie_array addObject:preview];
                        
                        
                    }
                }
                break;
            case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    [lifestyle_buety_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_LIFESTYLE_BEUTY]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [lifestyle_buety_array addObject:preview];
                        
                        
                    }
                }
                break;
                
            case DOWNLOAD_CPA_SPORT_OTHER:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    [sport_other_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_SPORT_OTHER]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [sport_other_array addObject:preview];
                        
                        
                    }
                }
                break;
            case DOWNLOAD_CPA_SPORT_FOOTBALL:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    [sport_football_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_SPORT_FOOTBALL]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [sport_football_array addObject:preview];
                        
                        
                    }
                }
                break;
            case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content = [[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    [clip_free_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_CLIP_FREE_INTERNET]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [clip_free_array addObject:preview];
                        
                        
                    }
                }
                break;
            case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
                if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *result =[responseObject objectForKey:@"result"] ;
                    NSArray * subcontent = [result objectForKey:@"subCates"] ;
                    
                    NSDictionary * content = subcontent[0] ;
                    content =[[content objectForKey:@"contents"] isEqual:[NSNull null] ] ? nil : [content objectForKey:@"contents"]  ;
                    
                    [clip_premium_array addObject:[NSNumber numberWithInt:DOWNLOAD_CPA_CLIP_FREE_PREMIUM]];
                    
                    for(NSDictionary* temp in content){
                        
                        CPAContent *preview = [[CPAContent alloc]initWithDictionary:temp];
                        [clip_premium_array addObject:preview];
                        
                        
                    }
                }
                break;
            
                
            default:
                break;
        }
        
        [self.collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
}
-(void)sortGameOrder{
    //    for (NSMutableArray *temp in game_array){
    //
    //    }
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
        
        if([_nameMenu[i] intValue] == DOWNLOAD_GAME){
            game_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = game_array;
            [self GetContentDownload:i AndSubCate :DOWNLOAD_GAME_NEW limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_GAME_HIT limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_GAME_GAMECLUB limit:6];
            //[self GetContentDownload:i AndSubCate :DOWNLOAD_GAME_GAMEROOM limit:6];
        }
        else if([_nameMenu[i] intValue] == DOWNLOAD_MUSIC){
            music_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = music_array;
            
            music_new_array = [[NSMutableArray alloc]init];
            [music_array addObject:music_new_array];
            
            music_hit_array = [[NSMutableArray alloc]init];
            [music_array addObject:music_hit_array];
            
            music_inter_array = [[NSMutableArray alloc]init];
            [music_array addObject:music_inter_array];
            
            music_lookthoong_array = [[NSMutableArray alloc]init];
            [music_array addObject:music_lookthoong_array];
            
            
            [self GetContentDownload:i AndSubCate :DOWNLOAD_MUSIC_NEW limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_MUSIC_HIT limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_MUSIC_INTER limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_MUSIC_LOOKTHOONG limit:6];
        }
        else if([_nameMenu[i] intValue] == DOWNLOAD_CPA_NEWS){
            news_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = news_array;
            
            news_hit_array = [[NSMutableArray alloc]init];
            [news_array addObject:news_hit_array];
            
            news_gossip_array = [[NSMutableArray alloc]init];
            [news_array addObject:news_gossip_array];
            
            news_eco_array = [[NSMutableArray alloc]init];
            [news_array addObject:news_eco_array];
            
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_NEWS_HIT limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_NEWS_GOSSIP limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_NEWS_ECO limit:6];
            
        }
        else if([_nameMenu[i] intValue] == DOWNLOAD_CPA_HORO){
            horo_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = horo_array;
            
            horo_sub_array = [[NSMutableArray alloc]init];
            [horo_array addObject:horo_sub_array];
            

            
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_HORO limit:6];
            
        }
        else if([_nameMenu[i] intValue] == DOWNLOAD_CPA_LUCKY_NUMBER){
            lucky_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = lucky_array;
            
            lucky_sub_array = [[NSMutableArray alloc]init];
            [lucky_array addObject:lucky_sub_array];
            
            
            
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_LUCKY_NUMBER limit:6];
            
        }//DOWNLOAD_CPA_LIFESTYLE_QUIZE = 503,DOWNLOAD_CPA_LIFESTYLE_MOVIE = 504,DOWNLOAD_CPA_LIFESTYLE_BEUTY = 505,
        else if([_nameMenu[i] intValue] == DOWNLOAD_CPA_LIFESTYLE){
            lifestyle_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = lifestyle_array;
            
            lifestyle_quize_array = [[NSMutableArray alloc]init];
            [lifestyle_array addObject:lifestyle_quize_array];
            
            lifestyle_movie_array = [[NSMutableArray alloc]init];
            [lifestyle_array addObject:lifestyle_movie_array];
            
            lifestyle_buety_array = [[NSMutableArray alloc]init];
            [lifestyle_array addObject:lifestyle_buety_array];
            
           
            

            
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_LIFESTYLE_QUIZE limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_LIFESTYLE_MOVIE limit:6];
            
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_LIFESTYLE_BEUTY limit:6];
            
        }
        else if([_nameMenu[i] intValue] == DOWNLOAD_CPA_SPORT){
            sport_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = sport_array;
            
            sport_football_array = [[NSMutableArray alloc]init];
            [sport_array addObject:sport_football_array];
            
            
            sport_other_array = [[NSMutableArray alloc]init];
            [sport_array addObject:sport_other_array];
 
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_SPORT_OTHER limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_SPORT_FOOTBALL limit:6];
            
        }
        else if([_nameMenu[i] intValue] == DOWNLOAD_CPA_CLIP_FREE){
            clip_array = [[NSMutableArray alloc]init];
            allObjectArray[i] = clip_array;
            
            clip_free_array = [[NSMutableArray alloc]init];
            [clip_array addObject:clip_free_array];
            
            
            clip_premium_array = [[NSMutableArray alloc]init];
            [clip_array addObject:clip_premium_array];
            
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_CLIP_FREE_INTERNET limit:6];
            [self GetContentDownload:i AndSubCate :DOWNLOAD_CPA_CLIP_FREE_PREMIUM limit:6];
            
        }
      
    }
    [Manager savePageView:8 orSubCate:0];

    
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
        
        [fooCollection registerClass:[MusicCell class] forCellWithReuseIdentifier:@"MusicCell"];
        [fooCollection registerClass:[CPACell class] forCellWithReuseIdentifier:@"CPACell"];
        [fooCollection registerClass:[AppCell class] forCellWithReuseIdentifier:@"GameCell"];//BlockCollectionViewCell
        
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
            
            //            if([_nameMenu[i] intValue] == ENTERTAINMENT_TV){
            //                __weak DownloadViewController *weakSelf = self;
            //
            //                // setup pull-to-refresh
            //                [fooCollection addInfiniteScrollingWithActionHandler:^{
            //                    [weakSelf insertRowAtTop];
            //                }];
            //            }
        }
        
    }
    
    
    
}
- (void)insertRowAtTop {
    int current = _swipeView.currentItemIndex;
    __weak DownloadViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage:current];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
    });
    
}
-(void)getCPACategory{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaCategory\", \"params\":{\"cpaCateId\":null } }"];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];

    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *result =[responseObject objectForKey:@"result"] ;
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
    }];
    [op start];
    

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
    
    [self getCPACategory];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _themeColor = [UIColor colorWithHexString:COLOR_DOWNLOAD];
    self.navigationItem.title = @"บริการเสริม";
    
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
  //  NSNumber* number = self.nameMenu[self.indexPage];

   // [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:DOWNLOAD withSubCate:[number intValue] :nil]}];

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
    pageControl.numberOfPages = [[Manager sharedManager] bannerArrayDownload].count >0  ? [[Manager sharedManager] bannerArrayDownload].count : [[Manager sharedManager] bannerArray].count;
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
    
    NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
    NSLog(@" section %lu",(unsigned long)object.count);
    return object.count;
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSArray *object = allObjectArray.count >0 ? allObjectArray[collectionView.tag] : nil;
    NSMutableArray *temp = object.count>0 ? object[section] : nil;//collectionView.tag
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
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        int subcate = [tempArray[indexPath.row] intValue];
        
        NSString *identify = @"HeaderCell";
        DtacPlayHeaderHoloCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.line setBackgroundColor:[UIColor colorWithHexString:COLOR_DOWNLOAD]];
        [cell.moreButton setImage:[UIImage imageNamed:@"dtacplay_home_more_download"] forState:UIControlStateNormal];
        [cell.moreButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moreButton.tag = subcate;
        
        [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_horo_daily"]];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.label setTextColor:[UIColor colorWithHexString:COLOR_DOWNLOAD]];
        [cell.imageView setBackgroundColor:[UIColor whiteColor]];
        [cell.label setText:[Manager getSubcateName:subcate withThai:YES]];
        
        switch (subcate ) {
            case DOWNLOAD_GAME_NEW:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_gamenew"]];
                break;
            case DOWNLOAD_GAME_HIT:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_gamehit"]];
                break;
            case DOWNLOAD_GAME_GAMEROOM:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_gameroom"]];
                break;
            case DOWNLOAD_GAME_GAMECLUB:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_gameclub"]];
                break;
            case DOWNLOAD_MUSIC_NEW:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_musicnew"]];
                break;
            case DOWNLOAD_MUSIC_HIT:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_musichit"]];
                break;
            case DOWNLOAD_MUSIC_INTER:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_musicinter"]];
                break;
            case DOWNLOAD_MUSIC_LOOKTHOONG:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_musiclukthung"]];
                break;
            case DOWNLOAD_CPA_NEWS_HIT:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_news"]];
                break;
            case DOWNLOAD_CPA_NEWS_GOSSIP:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_gossip"]];
                break;
            case DOWNLOAD_CPA_NEWS_ECO:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_eco"]];
                break;
            case DOWNLOAD_CPA_HORO:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_horo"]];
                break;
            case DOWNLOAD_CPA_LUCKY_NUMBER:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_lotto"]];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_quiz"]];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_movie"]];
                break;
            case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_buety"]];
                break;
            case DOWNLOAD_CPA_SPORT_OTHER:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_sport"]];
                break;
            case DOWNLOAD_CPA_SPORT_FOOTBALL:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_football"]];
                break;
            case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_clipded"]];
                break;
            case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_download_premiumclip"]];
                break;
            default:
                [cell.imageView setImage:[UIImage imageNamed:@"dtacplay_horo_secert"]];
                break;
        }
        
        
        return cell;
        
    }
    else{
        if([_nameMenu[collectionView.tag] intValue] == DOWNLOAD_GAME ||[_nameMenu[collectionView.tag] intValue] == DOWNLOAD_MUSIC ){
            NSArray *object = allObjectArray[collectionView.tag];
            NSMutableArray *tempArray = object[indexPath.section];
            
            int subcate  = [tempArray[0] intValue];
            if([_nameMenu[collectionView.tag] intValue] == DOWNLOAD_MUSIC){
                MusicContent *articleTemp = tempArray[indexPath.row];
                
                NSString *identify = @"MusicCell";
                MusicCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailXL]
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
                
                return cell;
                
            }
            else{
                GameContent *articleTemp = tempArray[indexPath.row];
                NSString *identify = @"GameCell";
                AppCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailXL]
                 
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
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
            
        }
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        
        CPAContent *articleTemp = tempArray[indexPath.row];
        NSString *identify = @"CPACell";
        CPACell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:articleTemp.images.imageThumbnailL]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    
                                    cell.imageView.image = image;
                                    
//                                    int subcate = [tempArray[0] intValue];
//                                    switch (subcate ) {
//                                        
//                                        case DOWNLOAD_CPA_NEWS_HIT:
//                                            cell.imageView.image = [UIImage imageNamed:@"News_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_NEWS_GOSSIP:
//                                            cell.imageView.image = [UIImage imageNamed:@"gossip_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_NEWS_ECO:
//                                             cell.imageView.image = [UIImage imageNamed:@"economic_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_HORO:
//                                           cell.imageView.image = [UIImage imageNamed:@"horo_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_LUCKY_NUMBER:
//                                             cell.imageView.image = [UIImage imageNamed:@"lotto_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
//                                            cell.imageView.image = [UIImage imageNamed:@"quiz_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
//                                             cell.imageView.image = [UIImage imageNamed:@"Movie_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
//                                            cell.imageView.image = [UIImage imageNamed:@"beauty&travel_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_SPORT_OTHER:
//                                            cell.imageView.image = [UIImage imageNamed:@"Sport_etc_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_SPORT_FOOTBALL:
//                                            cell.imageView.image = [UIImage imageNamed:@"Sport_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
//                                            cell.imageView.image = [UIImage imageNamed:@"clip_XL"];
//                                            break;
//                                        case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
//                                          cell.imageView.image = [UIImage imageNamed:@"vip_clip_XL"];
//                                            break;
//                                        default:
//                                             cell.imageView.image = [UIImage imageNamed:@"clip_XL"];
//                                            break;
//                                    }
                                   
                                }
                            }];
        
        
        [cell.title setText:[NSString stringWithFormat:@"%@ %@", articleTemp.service,articleTemp.descriptionContent ]];
        
        [cell.title setFont:[UIFont fontWithName:FONT_DTAC_BOLD size:IDIOM == IPAD ? 16 : 14] range:(NSRange){0,articleTemp.service.length }    ];

        
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
    return CGSizeMake(w_1,w_1+45);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row != 0){
        NSArray *object = allObjectArray[collectionView.tag];
        NSMutableArray *tempArray = object[indexPath.section];
        
       
        
        if([_nameMenu[collectionView.tag] intValue] != DOWNLOAD_GAME && [_nameMenu[collectionView.tag] intValue] != DOWNLOAD_MUSIC){
             CPAContent *articleTemp = tempArray[indexPath.row];
            [Manager savePageViewCPA:[articleTemp.cpaConID intValue]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:articleTemp.aocLink]];
        }
        else{
        
        if([_nameMenu[collectionView.tag] intValue] == DOWNLOAD_GAME){
            
            GameContent *articleTemp = tempArray[indexPath.row];
            [self getGameByID:articleTemp.gameID];
        }
        else{
            MusicContent *articleTemp = tempArray[indexPath.row];
            [self getMusicByID:articleTemp.musicID];
        }
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
            
            
            GameContent *obj = [[GameContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.gameObject = obj;
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
            
            MusicContent *obj = [[MusicContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.musicObject = obj;
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
-(void)moreClick:(UIButton*)button{
    if(button.tag == DOWNLOAD_MUSIC ||button.tag == DOWNLOAD_MUSIC_LOOKTHOONG ||button.tag == DOWNLOAD_MUSIC_HIT ||button.tag == DOWNLOAD_MUSIC_NEW ||button.tag == DOWNLOAD_MUSIC_INTER || button.tag == DOWNLOAD_GAME || button.tag == DOWNLOAD_GAME_HIT ||button.tag == DOWNLOAD_GAME_NEW ||button.tag == DOWNLOAD_GAME_GAMECLUB ||button.tag == DOWNLOAD_GAME_GAMEROOM){
        ListContentDownloadViewController * articleView= [[ListContentDownloadViewController alloc]init];
        
        articleView.cate = DOWNLOAD;
        articleView.subCate =(int)ceil(button.tag);
        articleView.isCPA = NO;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];
        
    }else{
        ListContentDownloadViewController * articleView= [[ListContentDownloadViewController alloc]init];
        
        articleView.cate = DOWNLOAD;
        articleView.subCate = button.tag;
        articleView.isCPA = YES;
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
    
    if([_nameMenu[currentPage] intValue] == ENTERTAINMENT_TV){
        __weak DownloadViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [ self.collectionView  addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
        self.collectionView.showsInfiniteScrolling = YES;
    }
    NSNumber* number = self.nameMenu[swipeView.currentItemIndex];

//    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:DOWNLOAD withSubCate:[number intValue] :nil]}];
//    [Manager savePageView:0 orSubCate:[number intValue]];
    
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    if(swipeView.currentItemIndex != lastStatPage){
        NSNumber* number = self.nameMenu[swipeView.currentItemIndex];
        [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:DOWNLOAD withSubCate:[number intValue] :nil]}];
        [Manager savePageView:0 orSubCate:[number intValue]];        lastStatPage = (int)swipeView.currentItemIndex;
    }
    
}
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView{
    lastStatPage = (int)swipeView.currentItemIndex;
    NSNumber* number = self.nameMenu[swipeView.currentItemIndex];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:DOWNLOAD withSubCate:[number intValue] :nil]}];
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
    
    [dataLayer push:@{@"event": @"openScreen", @"screenName": @"Download"}];
    
}

@end