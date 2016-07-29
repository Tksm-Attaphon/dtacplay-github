//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacHomeViewController.h"
#import "MyFlowLayout.h"
#import "RFQuiltLayout.h"
#import "BannerSlideCollectionViewCell.h"
#import "UIColor+Extensions.h"
#import "Constant.h"
#import "SearchTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "PromotionViewController.h"
#import "Manager.h"
#import "ArticleBox.h"
#import "ContentPreview.h"
#import "ContentPreviewPromotion.h"
#import "FreeZoneViewController.h"
#import "LifeStyleViewController.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "DtacPlayBlockCollectionViewCell.h"
#import "DtacPlayBigBlockCollectionViewCell.h"
#import "NewsViewController.h"
#import "HoroViewController.h"
#import "NewsDetailViewController.h"
#import "EntertainmentViewController.h"
#import "EntertainmentDetailViewController.h"
#import "SportViewController.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "AppContent.h"
#import "AppCell.h"
#import "MusicContent.h"
#import "MusicCell.h"
#import "GameContent.h"
#import "FreeZoneDetialController.h"
#import "ApplicationFreeViewController.h"
#import "GameDetailViewController.h"
#import "ShoppingCell.h"
#import "ShoppingItem.h"
#import "ShoppingDetailViewController.h"
#import "ShoppingViewController.h"
#import "RegisterFreeZone.h"
#import "PopUp.h"
#import "Banner.h"
#import "BannerImage.h"
#import "SportDetailViewController.h"
#import "NavigationViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "SVPullToRefresh.h"
#import "DownloadViewController.h"
#import "PopUpCheckIn.h"
#import "DtacWebViewViewController.h"
#import "DownloadCPAViewController.h"
#import "CPACell.h"
#import "DtacCategory.h"
#import "BannerCollectionViewCell.h"
#import "NewsCategory.h"
#import "EntertainmentCategory.h"
#import "LifestyleCategory.h"
#import "FreezoneCategory.h"
#import "DownloadCategory.h"
#import "SportCategory.h"

#import "CPACategory.h"
#import "NewsCPA.h"
#import "HoroCPA.h"
#import "LuckyNumberCPA.h"
#import "LifeStyleCPA.h"
#import "SportCPA.h"
#import "ClipCPA.h"
#import "PrivllageGameViewController.h"
#import "BannerView.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
@interface DtacHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate,RegisterFreeZoneDelegate,PopUpDelegate,PopUpCheckInDelegate>
{
    UIPageControl *pageControl;
    UILabel *title;
    float textHeight;
    NSMutableArray *shoppingItemArray;
    UIView *menuView;
    float lastContentOffset;
    float screenWidth;
    float cellBigImageHeight;
    float cellSmallImageHeight;
    float labelIPAD ;
    float labelIPHONE;
    
    NavigationViewController *navigation;
    
    RegisterFreeZone *view;
    UIView *black;
    
    NSMutableArray* all_array;
    NSMutableArray* news_array;
    NSMutableArray* ent_array;
    NSMutableArray* pro_array;
    NSMutableArray* life_array;
    NSMutableArray* free_array;
    NSMutableArray* shop_array;
    NSMutableArray* download_array;
    NSMutableArray* sport_array;
    NSMutableArray* menu_HOME;
    
    BOOL isKeyboardShow;
    RegisterFreeZone *views;
    PopUp* ppp;
    PopUpCheckIn* checkInPopup;
    
    NSString* vierfyCode ;
    NSString *phonNumber_Mssid;
    
    NSTimer *timer;
    
    UIImageView *imageErrorPage;
    int homeBannerID;
    
    BannerView *bannerView;
    BOOL privilageGameShow;
    NSURL *urlPrivilage;
}

@end

@implementation DtacHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    if(!timer)
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    
}
-(void)getPrivilageGameBanner{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getConstant\", \"params\":{\"name\":\"ButtonPrivilegeGame\"}}"];
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSString *urlBanner = [result objectForKey:@"val"];
            if(urlBanner){
                urlPrivilage = [NSURL URLWithString:urlBanner];
                [self.collectionView reloadData];
            }
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[self change_server];
    }];
    [op start];
}
-(void)testCheckUpdateContent:(int) cateID{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"checkContent\", \"params\":{\"cateId\":%d,\"subCateId\":null}}",cateID];
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            BOOL status = [[dic objectForKey:@"status"] boolValue];
            privilageGameShow = status;
            [self getALLCategory];
            [self getALLCPACategory];
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[self change_server];
    }];
    [op start];
    

}
-(void)musicCheckUpdateContent{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"checkContent\", \"params\":{\"cateId\":null,\"subCateId\":%ld}}",(long)FREEZONE_MUSIC];
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            if(dic){
            BOOL status = [[dic objectForKey:@"status"] boolValue];
            
            [[Manager sharedManager] setIsFreeMusicAvaliable:status];
            }
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[self change_server];
    }];
    [op start];
    
    
}
-(void)callSideBar:(id)sender{
    [self.frostedViewController presentMenuViewController];
}
-(NSString *)getIPAddress
{
    NSUInteger  an_Integer;
    NSArray * ipItemsArray;
    NSString *externalIP;
    
    NSURL *iPURL = [NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"];
    
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSScanner *theScanner;
            NSString *text = nil;
            
            theScanner = [NSScanner scannerWithString:theIpHtml];
            
            while ([theScanner isAtEnd] == NO) {
                
                // find start of tag
                [theScanner scanUpToString:@"<" intoString:NULL] ;
                
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                theIpHtml = [theIpHtml stringByReplacingOccurrencesOfString:
                             [ NSString stringWithFormat:@"%@>", text]
                                                                 withString:@" "] ;
                ipItemsArray =[theIpHtml  componentsSeparatedByString:@" "];
                an_Integer=[ipItemsArray indexOfObject:@"Address:"];
                externalIP =[ipItemsArray objectAtIndex:  ++an_Integer];
            }
            NSLog(@"%@",externalIP);
        } else {
            NSLog(@"Oops... g %d, %@", [error code], [error localizedDescription]);
        }
    }
    return externalIP;
}
-(void)getAccessIDAndDevice{
    
    if([[Manager sharedManager] accessID] == nil ){
        //NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
        // NSString *deviceId = [identifierForVendor UUIDString];
        //NSString *ipaddress = [self getIPAddress];
        
        NSString *phoneWeb = URL_GET_PHONE_NUMBER;
        NSURL *phoneUrl = [NSURL URLWithString:phoneWeb];
        //    NSError *error;
        //    NSString *phoneNumber = [NSString stringWithContentsOfURL:phoneUrl
        //                                                     encoding:NSASCIIStringEncoding
        //                                                        error:&error];
        
        
        NSURLRequest *req = [NSURLRequest requestWithURL:phoneUrl];
        [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSString *phoneNumber = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // etc
            if(phoneNumber.length > 0){
                [[Manager sharedManager] setPhoneNumber:phoneNumber];
                
                phoneNumber = [[[Manager sharedManager] phoneNumber]
                               stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                
                phoneNumber = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"66"];
            }else{
                phoneNumber = @"null";
            }
            
            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            
            NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            
            
            NSString *jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getUserAccess\", \"params\":{\"userAgent\":\"%@\",\"chId\":2,\"nType\":null,\"msisdn\":%@,\"ipAddress\":null}}",secretAgent,phoneNumber];
            
            
            NSString *valueHeader;
            
            valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
            
            NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
            
            op.responseSerializer = [AFJSONResponseSerializer serializer];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject objectForKey:@"result"]) {
                    
                    NSDictionary *item =[responseObject objectForKey:@"result"] ;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"accessId"] ]] forKey:@"accessId"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[item objectForKey:@"device"]] forKey:@"device"];
                    
                    [[Manager sharedManager] setAccessID:[item objectForKey:@"accessId"]];
                    [[Manager sharedManager] setDeviceType:[[item objectForKey:@"device"] intValue]];
                    [[Manager sharedManager] setLanguage:THAI];
                    
                   
                    BOOL isOnReview = ![[item objectForKey:@"iOSsubmitApp"] boolValue];
               
                    [[Manager sharedManager] setIsNormalState:!isOnReview];//iOSsubmitApp
                    [self TestCookie];
                    
                    [self testCheckUpdateContent:10];// check privilage game
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSString *phoneWeb = URL_GET_PHONE_NUMBER;
                        NSURL *phoneUrl = [NSURL URLWithString:phoneWeb];
                        NSError *error;
                        NSString *phoneNumber = [NSString stringWithContentsOfURL:phoneUrl
                                                                         encoding:NSASCIIStringEncoding
                                                                            error:&error];
                        if(phoneNumber.length>0){
                         [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phoneNumber"];
                        
                        [[Manager sharedManager] setPhoneNumber:phoneNumber];
                        if(phoneNumber.length>0){
                            [self LogIn];
                        }
                        }
                    });
                    
                }
                else{
                    [[Manager sharedManager] showServerError:self];
                }
                [self getBanner:homeBannerID];
                //  ...
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [[Manager sharedManager] showServerError:self];
                
                imageErrorPage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60)];
                [imageErrorPage setImage:[UIImage imageNamed:@"DtacUnderConstruction_iOS"]];
                [imageErrorPage setContentMode:UIViewContentModeScaleAspectFit];
                [self.view addSubview:imageErrorPage];
                //  [[Manager sharedManager] showErrorAlert:self title:@"พบปัญหาการเชื่อมต่อ" message:@""];
            }];
            [op start];
            
            
            
        }];
        
    }else{ all_array = [[NSMutableArray alloc]init];
        
        news_array = [[NSMutableArray alloc]init];
        // [self getContentByCategoryID:1];///news
        
        ent_array = [[NSMutableArray alloc]init];
        // [self getContentByCategoryID:2];///entertainment
        
        pro_array = [[NSMutableArray alloc]init];
        [self getContentByCategoryID:7];///promotion
        
        life_array = [[NSMutableArray alloc]init];
        // [self getContentByCategoryID:3];///life style
        
        free_array = [[NSMutableArray alloc]init];
        
        sport_array = [[NSMutableArray alloc]init];
        
        // [self getAppGameMusic];///free style
        download_array = [[NSMutableArray alloc]init];
        
        shop_array = [[NSMutableArray alloc]init];
        [self getShopping];///shopping
        //[self getHilight];
        
        [self getHilight];
        [self getBanner:homeBannerID];
        
        [Manager savePageView:0 orSubCate:0];
    }
    
}


-(void)getALLCPACategory{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCpaCategory\" ,\"params\":{\"cpaCateId\":null }}"];
    
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=2;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            
            for(NSDictionary* d in dic){
                CPACategory *cate = [[CPACategory alloc]initWithDictionary:d];
                
                if (cate.cpaCateID == 1) {
                    NewsCPA *cate = [[NewsCPA alloc]initWithDictionary:d];
                    [[Manager sharedManager] setNewsCPA:cate];
                }
                else if(cate.cpaCateID == 2){
                    HoroCPA *cate = [[HoroCPA alloc]initWithDictionary:d];
                    [[Manager sharedManager] setHoroCPA:cate];
                }
                else if(cate.cpaCateID == 3){
                    
                    LuckyNumberCPA *cate = [[LuckyNumberCPA alloc]initWithDictionary:d];
                    [[Manager sharedManager] setNumberCPA:cate];
                }
                else if(cate.cpaCateID == 4){
                    LifeStyleCPA *cate = [[LifeStyleCPA alloc]initWithDictionary:d];
                    [[Manager sharedManager] setLifeCPA:cate];
                }
                else if(cate.cpaCateID == 5){
                    SportCPA *cate = [[SportCPA alloc]initWithDictionary:d];
                    [[Manager sharedManager] setSportCPA:cate];
                }
                else if(cate.cpaCateID == 6){
                    
                    ClipCPA *cate = [[ClipCPA alloc]initWithDictionary:d];
                    [[Manager sharedManager] setClipCPA:cate];
                }
               
                
            }

            
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
    }];
    [op start];
    

}
-(void)getALLCategory{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"id\":20140317, \"method\":\"getCategory\" }"];
    
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=2;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSDictionary *dic_result = [responseObject objectForKey:@"result"];
            
            menu_HOME = [[NSMutableArray alloc]init];
            for(NSDictionary* dic in dic_result){
                
                
                
                DtacCategory *cate = [[DtacCategory alloc]initWithDictionary:dic];
                if (cate.cateID == 0) {
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdNews:smartID];
                    homeBannerID = smartID;
                    [self getBanner:smartID];
                }
                else if (cate.cateID == 1) {
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdNews:smartID];
                    
                    NewsCategory *cate = [[NewsCategory alloc]initWithDictionary:dic];
                        [[Manager sharedManager] setNewsCategory:cate];
                    
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_NEWS)];
                    }
                }
                else if(cate.cateID == 2){
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdEntertainment:smartID];
                     EntertainmentCategory *cate = [[EntertainmentCategory alloc]initWithDictionary:dic];
                    [[Manager sharedManager] setEntertainmentCategory:cate];
                    
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_ENTERTAINMENT)];
                    }
                    
                   
                    
                }
                else if(cate.cateID == 3){
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdLifestyle:smartID];
                     LifestyleCategory *cate = [[LifestyleCategory alloc]initWithDictionary:dic];
                          [[Manager sharedManager] setLifestyleCategory:cate];
                    
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_LIFESTYLE)];
                    }
                }
                else if(cate.cateID == 4){
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdFreezone:smartID];
                     FreezoneCategory *cate = [[FreezoneCategory alloc]initWithDictionary:dic];
                     [[Manager sharedManager] setFreezoneCategory:cate];
                    
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_FREEZONE)];
                    }
                    
                }
                else if(cate.cateID == 5){
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdSport:smartID];
                    
                     SportCategory *cate = [[SportCategory alloc]initWithDictionary:dic];
                     [[Manager sharedManager] setSportCategory:cate];
                    // cate.isDisable = YES;
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_SPORT)];
                    }
                    
                    
                }
                else if(cate.cateID == 6){
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdShopping:smartID];
                    
                    [[Manager sharedManager] setShoppingCategory:cate];
                   // cate.isDisable = YES;
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_SHOPPING)];
                    }
                }
                else if(cate.cateID == 7){
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdPromotion:smartID];
                     [[Manager sharedManager] setPromotionCategory:cate];
                     // cate.isDisable = YES;
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_PROMOTION)];
                    }
                }
                else if(cate.cateID == 8){
                    
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdDownload:smartID];
                     DownloadCategory *cate = [[DownloadCategory alloc]initWithDictionary:dic];
                     [[Manager sharedManager] setDownloadCategory:cate];
                    
                    if(cate.isDisable == NO){
                        if([[Manager sharedManager] isNormalState] == YES)
                            [menu_HOME addObject:@(HOME_DOWNLOAD)];
                    }
                }
                else if(cate.cateID == 10 && privilageGameShow == YES){
                    int smartID = [[dic objectForKey:@"smrtAdsRefId"] isEqual:[NSNull null]] ? 0 :[[dic objectForKey:@"smrtAdsRefId"] intValue] ;
                    [[Manager sharedManager] setSmrtAdsRefIdPrivilageGame:smartID];
                    [[Manager sharedManager] setPrivilageGameCategory:cate];
                    // cate.isDisable = YES;
                    if(cate.isDisable == NO){
                        [menu_HOME addObject:@(HOME_PRIVILAGE)];
                        
                    }
                    
                }
            }
            
             [menu_HOME addObject:@(HOME_REGISTERFREEZONE)];
            
            NSSortDescriptor *LowToHi = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
           [menu_HOME sortUsingDescriptors:[NSArray arrayWithObject:LowToHi]];
            
            [[Manager sharedManager] setMenu_HOME:menu_HOME];
            
                all_array = [[NSMutableArray alloc]init];
                
                news_array = [[NSMutableArray alloc]init];
                // [self getContentByCategoryID:1];///news
                
                ent_array = [[NSMutableArray alloc]init];
                // [self getContentByCategoryID:2];///entertainment
                
                pro_array = [[NSMutableArray alloc]init];
                [self getContentByCategoryID:7];///promotion
                
                life_array = [[NSMutableArray alloc]init];
                // [self getContentByCategoryID:3];///life style
                
                free_array = [[NSMutableArray alloc]init];
                // [self getAppGameMusic];///free style
                download_array = [[NSMutableArray alloc]init];
                
                sport_array = [[NSMutableArray alloc]init];
                
                
                shop_array = [[NSMutableArray alloc]init];
            
                [[Manager sharedManager] setIsFreeMusicAvaliable:YES];
                [self musicCheckUpdateContent];
                [self getShopping];///shopping
                //[self getHilight];
                [self getRecAppAtIndex];
                [self getHilight];
                
                [Manager savePageView:0 orSubCate:0];
                
                
            
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
    }];
    [op start];

}
-(void)getBanner :(int)smartID{
    
    NSString *jsonString =
     [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",smartID];
    
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
            
            [[Manager sharedManager] setBannerArray:bannerArray];
            bannerView.bannerArray = [[Manager sharedManager] bannerArray];
            [bannerView.carousel reloadData];
            
            [self.collectionView reloadData];
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
    }];
    [op start];
    
    
}
-(void)TestCookie{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplication\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":14 ,\"suggest\":false}}",FREEZONE_RECOMMENDED_APPLICATION,1];
    
    NSString *valueHeader;
    NSMutableURLRequest *requestHTTP = [Manager TestcreateRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",newStr);
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
    
    
}
-(void)getRecAppAtIndex{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"checkContent\", \"params\":{\"cateId\":null,\"subCateId\":%ld}}",(long)FREEZONE_RECOMMENDED_APPLICATION];
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            BOOL status = [[dic objectForKey:@"status"] boolValue];
            
            [[Manager sharedManager] setIsRecAppAvaliable:status];
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[self change_server];
    }];
    [op start];
    
}
-(void)getHilight{
    [self getPrivilageGameBanner];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getHighlight\", \"params\":{\"cateId\":null}}"];
    
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([responseObject objectForKey:@"result"]) {
            
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            NSArray * content = [dic objectForKey:@"categories"] ;
            
            for(NSDictionary* temp in content){
                
                
                int cateID = [[temp objectForKey:@"cateId"] intValue] ;
                
                
                NSArray *allobject = [temp objectForKey:@"content"] ;
                
                if(cateID == 1){
                    for(NSDictionary* temp in allobject){
                        
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [news_array addObject:preview];
                        
                        
                    }
                    [all_array addObject:news_array];
                    
                    
                    
                }
                if(cateID == 2){
                    for(NSDictionary* temp in allobject){
                        
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [ent_array addObject:preview];
                        
                        
                    }
                    [all_array addObject:ent_array];
                    [all_array addObject:[NSNull null]];
                }
                if(cateID == 5){
                    
                    for(NSDictionary* temp in allobject){
                        
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [sport_array addObject:preview];
                        
                        
                    }
                    [all_array addObject:sport_array];
                }
                if(cateID == 7){
                    for(NSDictionary* temp in allobject){
                        
                        ContentPreviewPromotion *preview = [[ContentPreviewPromotion alloc]initWithDictionary:temp];
                        [pro_array addObject:preview];
                        
                        
                    }
                    [all_array addObject:pro_array];
                }
                if(cateID == 3){
                    for(NSDictionary* temp in allobject){
                        
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [life_array addObject:preview];
                        
                        
                    }
                    [all_array addObject:pro_array];
                }
                if(cateID == 4){
                    int i_music = 0;
                    int i_game = 0;
                    int i_app= 0;
                    for(NSDictionary* temp in allobject){
                        
                       
                            if([[temp objectForKey:@"subCateId"] intValue] == 27 && i_music <2){
                                 if([[Manager sharedManager] isNormalState] == YES){
                                     ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                                     [free_array addObject:preview];
                                     i_music++;
                                 }
                        
                            }
                        else if([[temp objectForKey:@"subCateId"] intValue] == 29 && i_app <2){
                            ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                            [free_array addObject:preview];
                            i_app++;
                        }
                        
                        
                        
                    }
                    
                    [all_array addObject:free_array];
                    //
                    //
                    [all_array addObject:[NSNull null]];
                }
                if(cateID == 8){
                    int i_music = 0;
                    int i_game = 0;
                    int i_app= 0;
                    BOOL isMusic = NO;
                    for(NSDictionary* temp in allobject){
                        
//                        int subCate =[[temp objectForKey:@"subCateId"] intValue];
//                        if( (subCate == DOWNLOAD_MUSIC_HIT || subCate == DOWNLOAD_MUSIC_INTER|| subCate == DOWNLOAD_MUSIC_LOOKTHOONG ||  subCate == DOWNLOAD_MUSIC_NEW )&& i_music <2){
//                            ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
//                            [download_array addObject:preview];
//                            i_music++;
//                            isMusic = YES;
//                        }
//                        else if((subCate == DOWNLOAD_GAME_GAMECLUB || subCate == DOWNLOAD_GAME_GAMEROOM|| subCate == DOWNLOAD_GAME_HIT ||  subCate == DOWNLOAD_GAME_NEW )&& i_app <2){
//                            ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
//                            [download_array addObject:preview];
//                            i_app++;
//                        }
//                        
//                        else{
//                            
//                        }
                        
                        ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                        [download_array addObject:preview];
                        
                    }
                    if([[Manager sharedManager] isNormalState ]== NO){
//                        news_tag = 0;
//                        entertain_tag = 1;
//                        dobgame_tag = 2;
//                        promotion_tag = 3;
//                        lifestyle_tag = 4;
//                        download_tag = -1;
//                        freezone_tag = 5;
//                        sport_tag = 6;
//                        regisfreezone_tag =7 ;
//                        shopping_tag =8;
                    }
                   
                    [all_array addObject:download_array];
                    
                }
            }
            [self.collectionView reloadData];
            
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
        [hud hide:YES];
    }];
    [op start];
    
    
}

-(void)getShopping{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getShopping\", \"params\":{\"page\":1,\"limit\":4}}"];
    
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([responseObject objectForKey:@"result"]) {
            
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            NSArray * content = [dic objectForKey:@"shopping"] ;
            
            for(NSDictionary* temp in content){
                ShoppingItem *preview = [[ShoppingItem alloc]initWithDictionary:temp];
                [shop_array addObject:preview];
            }
            [all_array addObject:shop_array];
            [self.collectionView reloadData];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
        [hud hide:YES];
    }];
    [op start];
    
    
}
-(void)getAppGameMusic{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusic\",\"params\":{\"page\":%d,\"limit\":2,\"suggest\":true }}",1];
    
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
            
            for(NSDictionary* temp in content){
                MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
                [free_array addObject:preview];
            }
            
            NSString *jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplication\",\"params\":{\"page\":%d,\"limit\":1 ,\"suggest\":true}}",1];
            
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
                    
                    for(NSDictionary* temp in content){
                        AppContent *preview = [[AppContent alloc]initWithDictionary:temp];
                        [free_array addObject:preview];
                    }
                    
                    NSString *jsonString =
                    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"page\":%d,\"limit\":1 ,\"suggest\":true,\"opera\":null}}",1];
                    
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
                            
                            for(NSDictionary* temp in content){
                                GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                                [free_array addObject:preview];
                            }
                            
                            
                        }
                        [all_array addObject:free_array];
                        [all_array addObject:@"register"];
                        [self.collectionView reloadData];
                        
                        //  ...
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"JSON responseObject: %@ ",error);
                        [hud hide:YES];
                    }];
                    [op start];
                    
                }
                
                
                
                
                //  ...
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"JSON responseObject: %@ ",error);
                [hud hide:YES];
            }];
            [op start];
        }
        
        
        [self.collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
}
-(void)getContentByCategoryID:(int)cateID{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentByCateId\",\"params\":{ \"cateId\":%d, \"page\":1,\"limit\":3 }}",cateID];
    
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    op.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [NSString stringWithFormat:@"%d",cateID] , @"cateID",nil];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int cateID = [[operation.userInfo objectForKey:@"cateID"] intValue];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            if(cateID == 1){
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [news_array addObject:preview];
                    
                    
                }
                [all_array addObject:news_array];
            }
            if(cateID == 2){
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [ent_array addObject:preview];
                    
                    
                }
                [all_array addObject:ent_array];
            }
            if(cateID == 7){
                for(NSDictionary* temp in content){
                    
                    ContentPreviewPromotion *preview = [[ContentPreviewPromotion alloc]initWithDictionary:temp];
                    [pro_array addObject:preview];
                    
                    
                }
                [all_array addObject:pro_array];
            }
            if(cateID == 3){
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [life_array addObject:preview];
                    
                    
                }
                [all_array addObject:pro_array];
            }
            if(cateID == 4){
                for(NSDictionary* temp in content){
                    
                    ContentPreview *preview = [[ContentPreview alloc]initWithDictionary:temp];
                    [free_array addObject:preview];
                    
                    
                }
                [all_array addObject:free_array];
            }
            
            if(cateID == 6){//SHOPPING
                [all_array addObject:[NSNull null]];
            }
        }
        [self.collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
}
-(void)getShoppingByID:(int)shoppingID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getShoppingById\",\"params\":{\"shoppingId\":%d}}",shoppingID];
    
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
            
            articleView.cate = FREEZONE;
            articleView.subcate = FREEZONE_APPLICATION;
            articleView.appObject = obj;
            
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
            
            MusicContent *obj = [[MusicContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            
            articleView.cate = obj.cate;
            articleView.subcate = obj.subcate;
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
            
            GameContent *obj = [[GameContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            
            articleView.cate = obj.cate;
            articleView.subcate = obj.subcate;
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
- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
-(void)LogIn{
    
    NSString *phoneNumber = [[[Manager sharedManager] phoneNumber] substringWithRange:NSMakeRange(1, [[[Manager sharedManager] phoneNumber] length]-1)];
    phonNumber_Mssid =  [NSString stringWithFormat:@"66%@", phoneNumber];
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"msisdnLogin\",\"params\":{ \"msisdn\":%@, \"channel\":1, \"verifyMsg\":null, \"verifyCode\":null}}",phonNumber_Mssid ];
    
    
    NSString *valueHeader;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setColor:[UIColor whiteColor]];
//    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]] && [responseObject objectForKey:@"result"]) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            
            if(![[result objectForKey:@"userId"] isEqual:[NSNull null]]){
         

                [[Manager sharedManager] setUserID:[[result objectForKey:@"userId"] stringValue]];

                
            }
        }
        else{
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // [hud hide:YES];
        
    }];
    [op start];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
//    news_tag = 0;
//    entertain_tag = 1;
//    dobgame_tag = 2;
//    promotion_tag = 3;
//    lifestyle_tag = 4;
//    download_tag = 5;
//    freezone_tag = 6;
//    sport_tag = 7;
//    regisfreezone_tag =8 ;
//    shopping_tag =9;
  
   
  
    if([[Manager sharedManager] menu_HOME]){
        menu_HOME = [[Manager sharedManager] menu_HOME];
    }
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(![self connected]){
            if ([UIAlertController class])
            {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"กรุณาเชื่อมต่ออินเทอร์เน็ทเพื่อเริ่มใช้งานค่ะ"
                                                      message:@""
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   NSLog(@"Cancel action");
                                               }];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               if (&UIApplicationOpenSettingsURLString != NULL) {
                                                   NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                   [[UIApplication sharedApplication] openURL:url];
                                               }
                                           }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"กรุณาเชื่อมต่ออินเทอร์เน็ทเพื่อเริ่มใช้งานค่ะ" message:@"" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            
            
        }
    }];
    
    navigation = [[NavigationViewController alloc]init];
    
    [self getAccessIDAndDevice];
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    NSLog(@"Navframe Height=%f",self.navigationController.navigationBar.frame.size.height);
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setFrame:CGRectMake(0, 0, 65, 30)];
    self.navigationItem.titleView = image;
    ///
    UIImage* image3 = [UIImage imageNamed:@"dtacplay_menu"];
    CGRect frameimg = CGRectMake(0, 0, 30, 30);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(callSideBar:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    menuButton.imageInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    self.navigationItem.leftBarButtonItem=menuButton;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    screenWidth = self.view.frame.size.width;
    
    cellBigImageHeight = ((screenWidth-20)*144)/300;
    cellSmallImageHeight = ((screenWidth/2 - 10)*144)/300;
    labelIPAD = 60;
    labelIPHONE = 50;
    
    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, screenWidth, self.view.frame.size.height-60) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"BannerHeader"];
    
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header1"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header2"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header3"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header4"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header5"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header6"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header7"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header8"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"Header9"];
    UINib *nib = [UINib nibWithNibName:@"BannerSlideCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"BannerSlideCollectionViewCell"];
    
    UINib *cellNib = [UINib nibWithNibName:@"ShoppingCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ShoppingCell"];
    
    [_collectionView registerClass:[MusicCell class] forCellWithReuseIdentifier:@"BlockMusicCollectionViewCell"];
    [_collectionView registerClass:[AppCell class] forCellWithReuseIdentifier:@"BlockAppCollectionViewCell"];
    [_collectionView registerClass:[DtacPlayBlockCollectionViewCell class] forCellWithReuseIdentifier:@"BigCell"];
    [_collectionView registerClass:[DtacPlayBlockCollectionViewCell class] forCellWithReuseIdentifier:@"SmallCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"RegisFreeZone"];
    [_collectionView registerClass:[CPACell class] forCellWithReuseIdentifier:@"CPACell"];
    [_collectionView registerClass:[BannerCollectionViewCell class] forCellWithReuseIdentifier:@"BannerCollectionViewCell"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    
    __weak DtacHomeViewController *weakSelf = self;
    
    UIView *tempView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [tempView setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    // setup pull-to-refresh
    [_collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }] ;
    
    
    NSString *string = [NSString stringWithFormat:@"Home"];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": string}];
    
    [self popupChecker];
    
}
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
-(void)popupChecker{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"counterPopup"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadySubmitPopup"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timePopUp"];
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
//    [imageCache clearDisk];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getPopup\"}"];
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
//    NSArray *keys = [NSArray arrayWithObjects:@"id", @"image", @"link", nil];
//    NSArray *objects = [NSArray arrayWithObjects:@"10",@"http://www.snakeskin.com/doger/doger2.jpg", @"http://dtacplay-web.dev5.thinksmart.co.th/th/main", nil];
//   
//    NSDictionary *result = [NSDictionary dictionaryWithObjects:objects
//                                                               forKeys:keys];
//    
//    NSArray *keys2 = [NSArray arrayWithObjects:@"result", nil];
//    NSArray *objects2 = [NSArray arrayWithObjects:result, nil];
//    
//    NSDictionary *responseObject = [NSDictionary dictionaryWithObjects:objects2
//                                                               forKeys:keys2];
    
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]] && [responseObject objectForKey:@"result"]) {
            
            NSDictionary *object = [responseObject objectForKey:@"result"];
            NSString *linkURL = [object objectForKey:@"link"];
            NSString *imageURL = [object objectForKey:@"image"];
            
            
            NSInteger popUpID = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:@"popUpID"];
            NSInteger popUpID_response = [[object objectForKey:@"id"] intValue];
            int counter= 0;
            if( popUpID_response == popUpID ){
                counter = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:@"counterPopup"];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"counterPopup"];
                [[NSUserDefaults standardUserDefaults] setInteger:popUpID_response forKey:@"popUpID"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timePopUp"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if(counter < 5){
                NSString *checkIn = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"timePopUp"];
                
                if(checkIn){
                    
                    // Convert string to date object
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyyMMdd HH:mm:ss"];
                    NSDate *date = [dateFormat dateFromString:checkIn];
                    NSDate *today =/*[NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];//*/ [NSDate date];
                    
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *componentsForFirstDate = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
                    
                    NSDateComponents *componentsForSecondDate = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:today];
                    
                    
                    if ([componentsForFirstDate day] != [componentsForSecondDate day]){
                        
                        
                        
                        NSDate *today = [NSDate date];
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
                        
                        NSString *stringFromDate = [formatter stringFromDate:today];
                        counter++;
                        NSString *valueToSave = stringFromDate;
                        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"timePopUp"];
                        [[NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"counterPopup"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self callFirstTimePopUp:linkURL AndImage:imageURL];
                    }
                }
                else{
                    
                    NSDate *today = [NSDate date];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
                    
                    NSString *stringFromDate = [formatter stringFromDate:today];
                    
                    NSString *valueToSave = stringFromDate;
                    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"timePopUp"];
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"counterPopup"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self callFirstTimePopUp:linkURL AndImage:imageURL];
                }
            }
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];

}
-(void)callFirstTimePopUp:(NSString*)linkURL AndImage:(NSString*)imageURL{
    checkInPopup = [[[NSBundle mainBundle] loadNibNamed:@"PopUpCheckIn" owner:self options:nil] objectAtIndex:0];
    checkInPopup.url = linkURL;
    checkInPopup.delegate = self;
    [checkInPopup setBackgroundColor:[UIColor whiteColor]];
    [checkInPopup setCenter:CGPointMake(self.view.frame.size.width / 2.0-checkInPopup.frame.size.width/2, self.view.frame.size.height / 2.0)];
    black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.view addSubview:black];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hidePopup:)];
    [black addGestureRecognizer:singleFingerTap];
    
    [black addSubview:checkInPopup];
    if(IPAD ==IDIOM){
        [checkInPopup setFrame:CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width-120)/2,checkInPopup.frame.origin.y+self.view.frame.size.height, (self.view.frame.size.width-120), ((self.view.frame.size.width-120)*500)/350)];
    }
    else{
        [checkInPopup setFrame:CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width-40)/2,checkInPopup.frame.origin.y+self.view.frame.size.height, (self.view.frame.size.width-40), ((self.view.frame.size.width-40)*500)/350)];
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imageURL]
     
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                [checkInPopup.image setImage:image];
                            }
                            
                            
                            
                        }];
    
    [UIView transitionWithView:self.view
                      duration:0.2
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        views.alpha = 1;
                        [checkInPopup setCenter:CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0)];
                        
                    }
                    completion:^(BOOL finished){
                        
                    }];
    
}
-(void)submitPopUpCheckInWithLinkURL:(NSString *)url{
    DtacWebViewViewController *temp = [[DtacWebViewViewController alloc]init];
    temp.url =[NSURL URLWithString: url];
    temp.themeColor = [UIColor colorWithHexString:COLOR_PROMOTION];
    temp.titlePage = @"โปรโมชั่น";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    [self.navigationController pushViewController:temp animated:YES];
}
- (void)insertRowAtTop {
    __weak DtacHomeViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getAccessIDAndDevice];
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
    });
    
}
-(void)runLoop:(NSTimer*)NSTimer{
    if(bannerView.carousel)
        [bannerView.carousel scrollToItemAtIndex:bannerView.carousel.currentItemIndex+1 animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    
    switch ([menu_HOME[section] intValue]) {
        case HOME_NEWS:
            return CGSizeMake( screenWidth, [[Manager sharedManager]bannerHeight]+40);
            break;
        case HOME_ENTERTAINMENT:
            return CGSizeMake( screenWidth,35);
            break;
        case HOME_PRIVILAGE:
            return CGSizeZero;
            break;
            
        case HOME_PROMOTION:
            return CGSizeMake( screenWidth,35);
            break;
        case HOME_LIFESTYLE:
            return CGSizeMake( screenWidth,35);
            break;
        case HOME_DOWNLOAD:
            return CGSizeMake( screenWidth,35);
            break;
        case HOME_FREEZONE:
            return CGSizeMake( screenWidth,35);
            break;
        case HOME_SPORT:
            return CGSizeMake( screenWidth,35);
            break;
        case HOME_REGISTERFREEZONE:
            return CGSizeMake( screenWidth,35);
            break;
        case HOME_SHOPPING:
            return CGSizeMake( screenWidth,35);
            break;
        default:
            return CGSizeZero;
            break;
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if(indexPath.section == 0){
            UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:@"BannerHeader" forIndexPath:indexPath];
            
            [headerView setBackgroundColor:[UIColor whiteColor]];
            
            if(!bannerView)
                bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
            bannerView.backgroundColor = [UIColor clearColor];
            //_carousel.
            [headerView addSubview:bannerView];
       
                bannerView.bannerArray =  [[Manager sharedManager]bannerArray];
            
            [bannerView.carousel reloadData];
            
            //header
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, bannerView.frame.size.height+10, screenWidth-20, 1)];
            [line setBackgroundColor:[UIColor colorWithHexString:COLOR_NEWS]];
            
            [headerView addSubview:line];
            
            UIImageView* circle = [[UIImageView alloc]initWithFrame:CGRectMake(10, line.frame.origin.y+5, 30, 30)];
            [circle setImage:[UIImage imageNamed:@"dtacplay_home_news"]];
            [headerView addSubview:circle];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(circle.frame.size.width+20, line.frame.origin.y+5,200, 30)];
            [label setText:[Manager getCateName:NEWS withThai:YES]];
            [label setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:16]];
            [label setTextColor:[UIColor colorWithHexString:COLOR_NEWS]];
            [headerView addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(touchHeader:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"dtacplay_home_more_news"] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(screenWidth-40, line.frame.origin.y+5, 30, 30)];
            [headerView addSubview:button];
            button.tag = 0;
            return headerView;
        }
        else{
            
            UIColor *color;
            NSString *titleHeader;
            UIImage *imageIcon;
            UIImage *imageMore;
            NSString *header;
         
                switch ([menu_HOME[indexPath.section] intValue]) {
                    case HOME_ENTERTAINMENT:
                        color = [UIColor colorWithHexString:COLOR_ENTERTAINMENT];
                        titleHeader =[Manager getCateName:ENTERTAINMENT withThai:YES];
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_entertainment"];
                        imageMore = [UIImage imageNamed:@"dtacplay_home_more_entertainment"];
                        
                        break;
                    case HOME_PROMOTION:
                        color = [UIColor colorWithHexString:COLOR_PROMOTION];
                        titleHeader = [Manager getCateName:PROMOTION withThai:YES];
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_promotion"];
                        imageMore = [UIImage imageNamed:@"dtacplay_home_more_promotion"];
                        break;
                    case HOME_LIFESTYLE:
                        color = [UIColor colorWithHexString:COLOR_LIFESTYLE];
                        titleHeader = [Manager getCateName:LIFESTYLE withThai:YES];
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_lifestyle"];
                        imageMore = [UIImage imageNamed:@"dtacplay_home_more_lifestyle"];
                        
                        break;
                    case HOME_DOWNLOAD:
                        color = [UIColor colorWithHexString:COLOR_DOWNLOAD];
                        titleHeader = [Manager getCateName:DOWNLOAD withThai:YES];
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_download"];
                        imageMore = [UIImage imageNamed:@"dtacplay_home_more_download"];
                        
                        break;
                    case HOME_FREEZONE:
                        color = [UIColor colorWithHexString:COLOR_FREEZONE];
                        titleHeader = [Manager getCateName:FREEZONE withThai:YES];
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_freezone"];
                        imageMore = [UIImage imageNamed:@"dtacplay_home_more_freezone"];
                        break;
                    case HOME_SPORT:
                        color = [UIColor colorWithHexString:COLOR_SPORT];
                        titleHeader = [Manager getCateName:SPORT withThai:YES];
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_sport"];
                        imageMore = [UIImage imageNamed:@"dtacplay_home_more_sport"];
                        break;
                    case HOME_REGISTERFREEZONE:
                        color = [UIColor colorWithHexString:COLOR_FREEZONE];
                        titleHeader = @"สมัครฟรีโซน";
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_free_regis"];
                        //imageMore = [UIImage imageNamed:@"dtacplay_home_more_freezone"];
                        break;
                        
                    case HOME_SHOPPING:
                        color = [UIColor colorWithHexString:COLOR_SHOPPING];
                        titleHeader = [Manager getCateName:SHOPPING withThai:YES];
                        imageIcon = [UIImage imageNamed:@"dtacplay_home_shopping"];
                        imageMore = [UIImage imageNamed:@"dtacplay_home_more_shopping"];
                        break;
                    default:
                        break;
                }
        
            
            header = [NSString stringWithFormat:@"Header%ld" ,(long)indexPath.section];
            UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:header forIndexPath:indexPath];
            
            
            [headerView setBackgroundColor:[UIColor whiteColor]];
            
            //header
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,5, screenWidth-20, 1)];
            [line setBackgroundColor:color];
            
            [headerView addSubview:line];
            
            UIImageView* circle = [[UIImageView alloc]initWithFrame:CGRectMake(10, line.frame.origin.y+5, 30, 30)];
            [circle setImage:imageIcon];
            [headerView addSubview:circle];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(circle.frame.size.width+20, line.frame.origin.y+5,screenWidth-50, 30)];
            [label setText:titleHeader];
            [label setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:16]];
            [label setTextColor:color];
            [headerView addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(touchHeader:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [button setImage:imageMore forState:UIControlStateNormal];
            [button setFrame:CGRectMake(screenWidth-40, line.frame.origin.y+5, 30, 30)];
            [headerView addSubview:button];
            button.tag = indexPath.section;
            [button setUserInteractionEnabled:YES];
            
            return headerView;
        }
    }
    return reusableview;
}
-(void)touchHeader:(UIButton*)button{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    
    if([menu_HOME[button.tag] intValue] == HOME_PROMOTION){
        PromotionViewController*   promotionPage= [[PromotionViewController alloc] init];
        navigation.viewControllers = @[promotionPage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([menu_HOME[button.tag] intValue] == HOME_LIFESTYLE){
        LifeStyleViewController *catePage= [[LifeStyleViewController alloc] init];
        catePage.nameMenu = [NSArray arrayWithObjects:[NSNumber numberWithInteger:LIFESTYLE_TRAVEL] , [NSNumber numberWithInteger:LIFESTYLE_RESTAURANT], [NSNumber numberWithInteger:LIFESTYLE_HOROSCOPE], nil];
        catePage.indexPage = 0;
        catePage.pageType = LIFESTYLE;
        catePage.subeType = LIFESTYLE;
        navigation.viewControllers = @[catePage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([menu_HOME[button.tag] intValue] == HOME_NEWS){
        NewsViewController *catePage= [[NewsViewController alloc] init];
        catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:NEWS_HOT_NEWS],[NSNumber numberWithInteger:NEWS_INTER_NEWS],[NSNumber numberWithInteger:NEWS_WIKI], [NSNumber numberWithInteger:NEWS_FINANCE], [NSNumber numberWithInteger:NEWS_TECHNOLOGY],[NSNumber numberWithInteger:NEWS_LOTTO],[NSNumber numberWithInteger:NEWS_LOTTERRY],[NSNumber numberWithInteger:NEWS_GAS_PRICE],[NSNumber numberWithInteger:NEWS_GOLD_PRICE], nil];
        catePage.indexPage = 0;
        catePage.pageType = NEWS;
        
        catePage.subeType = NEWS;
        navigation.viewControllers = @[catePage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([menu_HOME[button.tag] intValue] == HOME_DOWNLOAD){
        if([[Manager sharedManager] isNormalState] == YES){
            
            DownloadViewController *catePage= [[DownloadViewController alloc] init];
            catePage.nameMenu = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_MUSIC],[NSNumber numberWithInteger:DOWNLOAD_GAME],[NSNumber numberWithInteger:DOWNLOAD_CPA_NEWS],[NSNumber numberWithInteger:DOWNLOAD_CPA_HORO],[NSNumber numberWithInteger:DOWNLOAD_CPA_LUCKY_NUMBER],[NSNumber numberWithInteger:DOWNLOAD_CPA_LIFESTYLE],[NSNumber numberWithInteger:DOWNLOAD_CPA_SPORT],[NSNumber numberWithInteger:DOWNLOAD_CPA_CLIP_FREE], nil];
            catePage.indexPage = 0;
            catePage.pageType = DOWNLOAD;
   
            catePage.subeType = DOWNLOAD_MUSIC_NEW;
            navigation.viewControllers = @[catePage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
        }
        else{
            DownloadViewController *catePage= [[DownloadViewController alloc] init];
            catePage.nameMenu = [NSArray arrayWithObjects:[NSNumber numberWithInteger:DOWNLOAD_GAME], nil];
            catePage.indexPage = 0;
            catePage.pageType = DOWNLOAD;
            
            catePage.subeType = DOWNLOAD_MUSIC_NEW;
            navigation.viewControllers = @[catePage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
        }
        
    }
    else if([menu_HOME[button.tag] intValue] == HOME_FREEZONE ){
        NSMutableArray *menu = [[NSMutableArray alloc]init];
        
        if([[Manager sharedManager] isNormalState] == YES){
            if([[Manager sharedManager]isFreeMusicAvaliable] == YES)
                [menu addObject:[NSNumber numberWithInteger:FREEZONE_MUSIC]];
            [menu addObject:[NSNumber numberWithInteger:FREEZONE_GAME]];
        }
        [menu addObject:[NSNumber numberWithInteger:FREEZONE_APPLICATION]];
        
        if([[Manager sharedManager] isRecAppAvaliable] == YES)
            [menu addObject:[NSNumber numberWithInteger:FREEZONE_RECOMMENDED_APPLICATION]];
        
        [menu addObject:[NSNumber numberWithInteger:FREEZONE_REGISTER]];
        
         if([[Manager sharedManager] isNormalState]==YES)
             [menu addObject:[NSNumber numberWithInteger:FREEZONE_FREESMS]];
        FreeZoneViewController *catePage= [[FreeZoneViewController alloc] init];
        
        catePage.nameMenu = menu;
        catePage.indexPage = 0;
        catePage.pageType = FREEZONE;
        
        catePage.subeType = FREEZONE_MUSIC;
        navigation.viewControllers = @[catePage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    
    else if([menu_HOME[button.tag] intValue] == HOME_ENTERTAINMENT){
        EntertainmentViewController *catePage= [[EntertainmentViewController alloc] init];
        catePage.nameMenu = [NSArray arrayWithObjects:[NSNumber numberWithInteger:ENTERTAINMENT_NEWS] , [NSNumber numberWithInteger:ENTERTAINMENT_MOVIE_TRAILER], [NSNumber numberWithInteger:ENTERTAINMENT_VIDEO]/*,[NSNumber numberWithInteger:ENTERTAINMENT_TV]*/, nil];
        catePage.indexPage = 0;
        catePage.pageType = ENTERTAINMENT;
        
        catePage.subeType = ENTERTAINMENT_NEWS;
        navigation.viewControllers = @[catePage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([menu_HOME[button.tag] intValue] == HOME_SPORT){
        SportViewController *catePage= [[SportViewController alloc] init];
        catePage.nameMenu = [NSArray arrayWithObjects:[NSNumber numberWithInteger:SPORT_NEWS]/*,[NSNumber numberWithInteger:SPORT_INTER_FOOTBALL],[NSNumber numberWithInteger:SPORT_THAI_FOOTBALL]*/, nil];
        catePage.indexPage = 0;
        catePage.pageType = SPORT;
        
        navigation.viewControllers = @[catePage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if( [menu_HOME[button.tag] intValue] == HOME_SHOPPING){
        ShoppingViewController*   shopping= [[ShoppingViewController alloc] init];
        navigation.viewControllers = @[shopping];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else{
        
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return menu_HOME.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
        switch ([menu_HOME[section] intValue] ) {
            case HOME_NEWS:
                return news_array.count>3 ? 3 : news_array.count;
                break;
            case HOME_ENTERTAINMENT:
                return ent_array.count>3 ? 3 : ent_array.count;
                break;
            case HOME_PRIVILAGE:
                return 1;//DOB
                break;
            case HOME_PROMOTION:
                return 1;//promotion
                break;
            case HOME_LIFESTYLE:
                return life_array.count>3 ? 3 : life_array.count;
                break;
            case HOME_DOWNLOAD:// download
                return download_array.count>4 ? 4 : download_array.count;
                break;
            case HOME_FREEZONE:
                return free_array.count>4 ? 4 : free_array.count;
                break;
            case HOME_SPORT:
                return sport_array.count>3 ? 3 : sport_array.count;
                break;
            case HOME_REGISTERFREEZONE:
                return 1;
                break;
            case HOME_SHOPPING:
                return shop_array.count>4 ? 4 : shop_array.count;
                break;
            default:
                return 0;
                break;
        }

    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if([menu_HOME[section] intValue] == HOME_REGISTERFREEZONE){
        UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
        return inset;
    }
    else{
        UIEdgeInsets inset = UIEdgeInsetsMake(10,10,15,10);
        return inset;
    }
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContentPreview *temp ;
    NSInteger section  = indexPath.section;
    
    if([menu_HOME[section] intValue] == HOME_PRIVILAGE){
        
        BannerCollectionViewCell *cell=(BannerCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"BannerCollectionViewCell" forIndexPath:indexPath];
       
        [cell.imageView sd_setImageWithURL:urlPrivilage
                              placeholderImage:nil
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
        
        
        return cell;
    }
    else if([menu_HOME[section] intValue] == HOME_PROMOTION){
        NSString *identifier = @"BannerSlideCollectionViewCell";
        
        UINib *nib = [UINib nibWithNibName:@"BannerSlideCollectionViewCell" bundle: nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        
        
        BannerSlideCollectionViewCell *cell=(BannerSlideCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"BannerSlideCollectionViewCell" forIndexPath:indexPath];
        cell.parentView = self;
        cell.promotionArray = pro_array;
        [cell.carousel reloadData];
        cell.layer.shouldRasterize = YES;
        
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        return cell;
    }
    else if([menu_HOME[section] intValue] == HOME_DOWNLOAD || [menu_HOME[section] intValue] == HOME_FREEZONE){
        
        ContentPreview* content;
        if([menu_HOME[section] intValue] == HOME_DOWNLOAD ){
            content = download_array[indexPath.row];
        }
        else{
            content = free_array[indexPath.row];
        }
        if(content.subCateID == FREEZONE_MUSIC ||  (content.subCateID == DOWNLOAD_MUSIC_HIT || content.subCateID == DOWNLOAD_MUSIC_INTER|| content.subCateID == DOWNLOAD_MUSIC_LOOKTHOONG ||  content.subCateID == DOWNLOAD_MUSIC_NEW )){
            MusicCell *cell=(MusicCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"BlockMusicCollectionViewCell" forIndexPath:indexPath];
            NSString* imageFromURL;
            
            
            imageFromURL = content.images.imageThumbnailXL;
            cell.nameMusicLabel.text = content.title;
            cell.nameArtistLabel.text = content.descriptionContent;
            
            
            
            
            
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
            [cell.imageView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
            cell.layer.masksToBounds = NO;
            cell.layer.shadowOffset = CGSizeMake(2, 2);
            cell.layer.shadowRadius = 2;
            cell.layer.shadowOpacity = 0.5;
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            return cell;
        }
        else if(content.subCateID == FREEZONE_APPLICATION || (content.subCateID == DOWNLOAD_GAME_GAMECLUB || content.subCateID == DOWNLOAD_GAME_GAMEROOM|| content.subCateID == DOWNLOAD_GAME_HIT ||  content.subCateID == DOWNLOAD_GAME_NEW )){
            AppCell *cell=(AppCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"BlockAppCollectionViewCell" forIndexPath:indexPath];
            NSString* imageFromURL;
            
            
            imageFromURL = content.images.imageThumbnailXL;
            cell.title.text = content.title;
            cell.desc.text = content.descriptionContent;
            
            
            
            
            
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
            [cell.imageView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
            cell.layer.masksToBounds = NO;
            cell.layer.shadowOffset = CGSizeMake(2, 2);
            cell.layer.shadowRadius = 2;
            cell.layer.shadowOpacity = 0.5;
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            return cell;
            
        }
        else{
            CPACell *cell=(CPACell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CPACell" forIndexPath:indexPath];
            NSString* imageFromURL;
            
            
            
            imageFromURL = content.images.imageThumbnailL;
            cell.title.text = [NSString stringWithFormat:@"%@ %@", content.title,content.descriptionContent ];
            
            
            
            
            
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
            [cell.imageView setBackgroundColor:[UIColor clearColor]];
            
            [cell.title setFont:[UIFont fontWithName:FONT_DTAC_BOLD size:IDIOM == IPAD ? 16 : 14] range:(NSRange){0,content.title.length }    ];
            

            
            [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
            cell.layer.masksToBounds = NO;
            cell.layer.shadowOffset = CGSizeMake(2, 2);
            cell.layer.shadowRadius = 2;
            cell.layer.shadowOpacity = 0.5;
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            return cell;
        }
    }
    else if ([menu_HOME[section] intValue] == HOME_REGISTERFREEZONE){
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
        //
        //        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        //        [view setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
        //        [cell addSubview:view];
        //
        //
        //        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.frame.size.width-20, 60)];
        //        [label setText:@"สมัครฟรีเพื่อรับคอนเทนท์อัพเดตโดนใจเเละข่าวสารกิจกรรม\"ฟรี\"ไม่เสียค่าใช้จ่าย"];
        //        label.lineBreakMode = NSLineBreakByTruncatingTail;
        //        label.numberOfLines = 0;
        //        [label setTextAlignment:NSTextAlignmentCenter];
        //        [label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IPAD == IDIOM ? 16 : 14]];
        //        [label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        //        [cell addSubview:label];
        //
        //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [button addTarget:self
        //                   action:@selector(registerFreezone:)
        //         forControlEvents:UIControlEventTouchUpInside];
        //        [button setTitle:@"สมัคร" forState:UIControlStateNormal];
        //        button.frame = CGRectMake(cell.frame.size.width/2-50, 80, 100.0, 40.0);
        //        [button setBackgroundColor:[UIColor colorWithHexString:COLOR_FREEZONE]];
        //        [button.titleLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IPAD == IDIOM ? 16 : 14]];
        //        [button setTintColor:[UIColor whiteColor]];
        //        [cell addSubview:button];
        //
        //        cell.layer.masksToBounds = NO;
        //        cell.layer.shadowOffset = CGSizeMake(2, 2);
        //        cell.layer.shadowRadius = 2;
        //        cell.layer.shadowOpacity = 0.5;
        //        cell.layer.shouldRasterize = YES;
        //        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //
        //        [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
        cell.layer.masksToBounds = NO;
        cell.layer.shadowOffset = CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        return cell;
    }
    else if([menu_HOME[section] intValue] == HOME_SHOPPING){
        ShoppingCell *cell=(ShoppingCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ShoppingCell" forIndexPath:indexPath];
        NSString* imageFromURL;
        
        if(shop_array.count > indexPath.row){
            ShoppingItem* content = shop_array[indexPath.row];
            imageFromURL = content.images.imageThumbnailL;
            cell.title.text = content.titlePreview;
            cell.price.text = [NSString stringWithFormat:@"%.2f",content.price] ;
            cell.date.text = content.dateReadable;
            cell.address.text = content.address;
            
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
            
            [cell.date setText: [NSString stringWithFormat:@"ประจำวันที่ %ld/%ld/%ld เวลา %@:%@ น.", (long)day,(long)month,year+543,hoursString,minutesString]];
            
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
    else{
        
            switch ([menu_HOME[section] intValue]) {
                case HOME_NEWS:
                    if(news_array.count>indexPath.row){
                        temp = news_array[indexPath.row];
                    }
                    else{
                        temp = nil;
                    }
                    break;
                case HOME_ENTERTAINMENT:
                    if(ent_array.count >indexPath.row){
                        temp = ent_array[indexPath.row];
                    }
                    else{
                        temp = nil;
                    }
                    break;
                case HOME_LIFESTYLE:
                    if(life_array.count >indexPath.row){
                        temp = life_array[indexPath.row];
                    }
                    else{
                        temp = nil;
                    }
                    break;
                case HOME_DOWNLOAD:
                    if(download_array.count >indexPath.row){
                        temp = download_array[indexPath.row];
                    }
                    else{
                        temp = nil;
                    }
                    break;
                case HOME_SPORT:
                    if(sport_array.count>indexPath.row){
                        temp = sport_array[indexPath.row];
                    }
                    else{
                        temp = nil;
                    }
                    break;
                default:
                    break;
            }

        if(indexPath.row == 0){
            NSString *identify = @"BigCell";
            DtacPlayBlockCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:temp.images.imageThumbnailL]
                              placeholderImage:[UIImage imageNamed:@"default_image_01_L.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
            
            
            
            [cell.label setText:temp.previewTitle];
            
            cell.layer.masksToBounds = NO;
            cell.layer.shadowOffset = CGSizeMake(2, 2);
            cell.layer.shadowRadius = 2;
            cell.layer.shadowOpacity = 0.5;
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
            [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
            
            return cell;
        }else{
            NSString *identify = @"SmallCell";
            DtacPlayBlockCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            
            [cell.imageView setImage:[UIImage imageNamed:@"default_image_01_L.jpg"]];
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:temp.images.imageThumbnailL]
                              placeholderImage:[UIImage imageNamed:@"default_image_01_L.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                     }];
            
            
            [cell.label setText:temp.previewTitle];
            
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
    float w = screenWidth-20;
    float w_half = w/2-5;
    float labelH = (IPAD == IDIOM )? labelIPAD : labelIPHONE;
    if([menu_HOME[indexPath.section] intValue] == HOME_NEWS || [menu_HOME[indexPath.section] intValue] == HOME_ENTERTAINMENT ||[menu_HOME[indexPath.section] intValue] == HOME_LIFESTYLE ||[menu_HOME[indexPath.section] intValue] == HOME_SPORT){
        switch (indexPath.row) {
            case 0:
                return CGSizeMake(w,cellBigImageHeight +labelH );
                break;
            case 1:
                return CGSizeMake(w_half,cellSmallImageHeight + labelH);
                break;
            case 2:
                return CGSizeMake(w_half,cellSmallImageHeight + labelH);
                break;
            default:
                break;
        }
    }
    else if([menu_HOME[indexPath.section] intValue] == HOME_FREEZONE || [menu_HOME[indexPath.section] intValue] == HOME_DOWNLOAD  ){
        return CGSizeMake(w_half,w_half + labelH);
    }
    else if([menu_HOME[indexPath.section] intValue] == HOME_REGISTERFREEZONE){
        return CGSizeMake(w,(w*500)/750);
    }
    else if ([menu_HOME[indexPath.section] intValue] == HOME_SHOPPING){
        return CGSizeMake(w_half,w_half+142);
    }
    else if ([menu_HOME[indexPath.section] intValue] == HOME_PRIVILAGE){
        return CGSizeMake(screenWidth,(w*100)/320);
    }
    else{
        return CGSizeMake(screenWidth,(w*330)/1000);
    }
    return CGSizeMake(screenWidth,screenWidth+142);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([menu_HOME[indexPath.section] intValue] == HOME_NEWS){
        NewsDetailViewController *articleView= [[NewsDetailViewController alloc]init];
        
        articleView.titlePage =  [Manager getCateName:NEWS withThai:YES];
        articleView.themeColor = [UIColor colorWithHexString:COLOR_NEWS];
        articleView.pageType = NEWS;
        ContentPreview *temp = news_array[indexPath.row];
        
        
        articleView.contentID = temp.contentID;
        articleView.pageType = temp.subCateID;
        
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];
    }
    else if([menu_HOME[indexPath.section] intValue] == HOME_ENTERTAINMENT){
        EntertainmentDetailViewController *articleView= [[EntertainmentDetailViewController alloc]init];
        
        articleView.titlePage =  [Manager getCateName:ENTERTAINMENT withThai:YES];
        articleView.themeColor = [UIColor colorWithHexString:COLOR_ENTERTAINMENT];
        articleView.pageType = NEWS;
        
        ContentPreview *temp = ent_array[indexPath.row];
        articleView.contentID = temp.contentID;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];
    }
    else if([menu_HOME[indexPath.section] intValue] == HOME_LIFESTYLE){
        ContentPreview* temp;
        
        temp= life_array[indexPath.row];

            ArticleViewController *articleView= [[ArticleViewController alloc]init];
            articleView.titlePage = [Manager getCateName:LIFESTYLE withThai:YES];
            articleView.themeColor = [UIColor colorWithHexString:COLOR_LIFESTYLE];
            articleView.pageType = LIFESTYLE;
            articleView.subCateType = temp.subCateID;
            articleView.contentID = temp.contentID;
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];
        
        
    }
    else if ([menu_HOME[indexPath.section] intValue] == HOME_DOWNLOAD){
        ContentPreview* content = download_array[indexPath.row];
        if((content.subCateID == DOWNLOAD_MUSIC_HIT || content.subCateID == DOWNLOAD_MUSIC_INTER|| content.subCateID == DOWNLOAD_MUSIC_LOOKTHOONG ||  content.subCateID == DOWNLOAD_MUSIC_NEW )){// music
            [self getMusicByID:content.contentID];
        }
        if((content.subCateID == DOWNLOAD_GAME_HIT || content.subCateID == DOWNLOAD_GAME_NEW|| content.subCateID == DOWNLOAD_GAME_GAMECLUB ||  content.subCateID == DOWNLOAD_GAME_GAMEROOM )) {
            [self getGameByID:content.contentID];
        }
        else{
            [Manager savePageViewCPA:[content.cpaConId intValue]];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:content.aocLink]];
        }
    }
    else if ([menu_HOME[indexPath.section] intValue] == HOME_FREEZONE){
        ContentPreview* content = free_array[indexPath.row];
        if(content.subCateID == 27){// music
            [self getMusicByID:content.contentID];
            
        }
        else if(content.subCateID == 29){
            [self getAppByID:content.contentID];
        }
        else{
            GameDetailViewController* articleView= [[GameDetailViewController alloc]init];
            articleView.cate = FREEZONE;
            articleView.subcate = FREEZONE_GAME;
            GameContent* app = free_array[indexPath.row];;
            articleView.gameObject = app;
            
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
    else if([menu_HOME[indexPath.section] intValue] == HOME_SPORT){
        SportDetailViewController *articleView= [[SportDetailViewController alloc]init];
        
        articleView.titlePage =  [Manager getCateName:SPORT withThai:YES];;
        articleView.themeColor = [UIColor colorWithHexString:COLOR_SPORT];
        articleView.pageType = SPORT;
        
        ContentPreview *temp = sport_array[indexPath.row];
        articleView.contentID = temp.contentID;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];
    }
    else if([menu_HOME[indexPath.section] intValue] == HOME_PRIVILAGE){
        PrivllageGameViewController *articleView= [[PrivllageGameViewController alloc]init];

        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];
    }
    else if([menu_HOME[indexPath.section] intValue] == HOME_SHOPPING){
        ShoppingItem *item = shop_array[indexPath.row];
        [self getShoppingByID:item.shoppingID];
    }
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

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    isKeyboardShow = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        [views setCenter:CGPointMake(views.center.x, self.view.frame.size.height / 2.0 - 60)];
    }];
    
    
}
-(void)registerFreezone:(id*)button{
    [Manager savePageView:0 orSubCate:FREEZONE_REGISTER];
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
        [self submitRegisterFreezone:number];
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
                            [checkInPopup removeFromSuperview];
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
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getOTP\",\"params\":{ \"otpType\":1, \"msisdn\":66%@ }}",phoneNumber];
    
    
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
