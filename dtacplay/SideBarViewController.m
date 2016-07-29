//
//  SideBarViewController.m
//  googlenewstand
//
//  Created by attaphon eamsahard on 9/21/2558 BE.
//  Copyright (c) 2558 attaphon. All rights reserved.
//

#import "SideBarViewController.h"
#import "Constant.h"
#import "DtacHomeViewController.h"
#import "UIColor+Extensions.h"
#import "REFrostedViewController.h"
#import "MenuBlockView.h"
#import "NimbusKitAttributedLabel.h"
#import "NavigationViewController.h"
#import "IconImageView.h"
#import "PromotionViewController.h"
#import "DtacPlayView.h"
#import "LifeStyleViewController.h"
#import "NewsViewController.h"
#import "Manager.h"
#import "MBProgressHUD.h"
#import "EntertainmentViewController.h"
#import "FreeZoneViewController.h"
#import "ShoppingViewController.h"
#import "DownloadViewController.h"
#import "SportViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "RegisterFreeZone.h"
#import "PopUp.h"
#import "PopUpCheckIn.h"

#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface SideBarViewController ()<UIGestureRecognizerDelegate,RegisterFreeZoneDelegate,PopUpDelegate,PopUpCheckInDelegate,UITextFieldDelegate>
{
    UIImageView *profile ;
    float widthScreen;
    UIScrollView *scrollView;
    UIView *headerView;
    UILabel *titleHeader;
    
    NSMutableArray *mainMenuArray;
    NSMutableArray *headerArray;
    NSMutableArray *arrowArray;
    NavigationViewController *navigation;
    NSMutableArray *subMenuArray;
    NSMutableArray *subMenuTypeArray;
    NSMutableArray *subMenuIconArray;
    NSMutableArray *nameMenu;
    
    NIAttributedLabel* labelLogin;
    UILabel *showPhoneNumber;
    UIView *logout;
    
    RegisterFreeZone *views;
    PopUp* ppp;
    PopUpCheckIn* checkInPopup;
    UIView *black;
    
    NSString* vierfyMsg ;
    NSString *phonNumber_Mssid;
    NSString *phoneNumberForShow;
    
    BOOL isKeyboardShow;
}
@end

@implementation SideBarViewController

-(void)SETUP{
    
    NSArray* subNameMenu = [NSArray arrayWithObjects: [Manager getSubcateName:NEWS_HOT_NEWS withThai:YES],[Manager getSubcateName:NEWS_INTER_NEWS withThai:YES],[Manager getSubcateName:NEWS_WIKI withThai:YES], [Manager getSubcateName:NEWS_FINANCE withThai:YES], [Manager getSubcateName:NEWS_TECHNOLOGY withThai:YES],[Manager getSubcateName:NEWS_LOTTO withThai:YES],[Manager getSubcateName:NEWS_LOTTERRY withThai:YES],[Manager getSubcateName:NEWS_GAS_PRICE withThai:YES], [Manager getSubcateName:NEWS_GOLD_PRICE withThai:YES], nil];
    
    NSArray* subEnumMenu = [NSArray arrayWithObjects:[NSNumber numberWithInteger:NEWS_HOT_NEWS] , [NSNumber numberWithInteger:NEWS_INTER_NEWS],[NSNumber numberWithInteger:NEWS_WIKI] , [NSNumber numberWithInteger:NEWS_FINANCE], [NSNumber numberWithInteger:NEWS_TECHNOLOGY], [NSNumber numberWithInteger:NEWS_LOTTO], [NSNumber numberWithInteger:NEWS_LOTTERRY], [NSNumber numberWithInteger:NEWS_GAS_PRICE], [NSNumber numberWithInteger:NEWS_GOLD_PRICE], nil];
    
    NSArray* subNameMenu2 = [NSArray arrayWithObjects: [Manager getSubcateName:ENTERTAINMENT_NEWS withThai:YES],[Manager getSubcateName:ENTERTAINMENT_MOVIE_TRAILER withThai:YES],[Manager getSubcateName:ENTERTAINMENT_VIDEO withThai:YES], nil];
    NSArray* subEnumMenu2 = [NSArray arrayWithObjects:[NSNumber numberWithInteger:ENTERTAINMENT_NEWS],[NSNumber numberWithInteger:ENTERTAINMENT_MOVIE_TRAILER] ,[NSNumber numberWithInteger:ENTERTAINMENT_VIDEO] , nil];
    //NSArray* subNameMenu2 = [NSArray arrayWithObjects: @"ข่าวบันเทิง", @"ทีวี", @"หนัง", @"จองตั๋วหนัง",@"เพลง", @"แนะนำบริการ", @"วีดีโอ",@"เกมส์",@"ธีม",@"วอลเปเปอร์", nil];
    // NSArray* subNameMenu3x = [NSArray arrayWithObjects: @"ท่องเที่ยว", @"ร้านอาหาร", @"ที่พัก", @"สุขภาพ",@"ดวง", nil];
    NSArray* subNameMenu3 = [NSArray arrayWithObjects: [Manager getSubcateName:LIFESTYLE_TRAVEL withThai:YES],[Manager getSubcateName:LIFESTYLE_RESTAURANT withThai:YES],[Manager getSubcateName:LIFESTYLE_HOROSCOPE withThai:YES], nil];
    NSArray* subEnumMenu3 = [NSArray arrayWithObjects:[NSNumber numberWithInteger:LIFESTYLE_TRAVEL] , [NSNumber numberWithInteger:LIFESTYLE_RESTAURANT], [NSNumber numberWithInteger:LIFESTYLE_HOROSCOPE], nil];
    
    
    NSArray* subNameMenu4 = [NSArray arrayWithObjects: [Manager getSubcateName:DOWNLOAD_MUSIC withThai:YES], [Manager getSubcateName:DOWNLOAD_GAME withThai:YES], [Manager getSubcateName:DOWNLOAD_CPA_NEWS withThai:YES],[Manager getSubcateName:DOWNLOAD_CPA_HORO withThai:YES],[Manager getSubcateName:DOWNLOAD_CPA_LUCKY_NUMBER withThai:YES],[Manager getSubcateName:DOWNLOAD_CPA_LIFESTYLE withThai:YES],[Manager getSubcateName:DOWNLOAD_CPA_SPORT withThai:YES] , [Manager getSubcateName:DOWNLOAD_CPA_CLIP_FREE withThai:YES], nil];
    NSArray* subEnumMenu4 = [NSArray arrayWithObjects:[NSNumber numberWithInteger:DOWNLOAD_MUSIC] , [NSNumber numberWithInteger:DOWNLOAD_GAME],
                             [NSNumber numberWithInteger:DOWNLOAD_CPA_NEWS],[NSNumber numberWithInteger:DOWNLOAD_CPA_HORO ],[NSNumber numberWithInteger:DOWNLOAD_CPA_LUCKY_NUMBER ],[NSNumber numberWithInteger:DOWNLOAD_CPA_LIFESTYLE],[NSNumber numberWithInteger:DOWNLOAD_CPA_SPORT] , [NSNumber numberWithInteger:DOWNLOAD_CPA_CLIP_FREE], nil];
    
    
    NSMutableArray* subNameMenu5 = [[NSMutableArray alloc]init];
    NSMutableArray* subEnumMenu5 = [[NSMutableArray alloc]init];
    
    if([[Manager sharedManager] isNormalState]==YES){
        if([[Manager sharedManager]isFreeMusicAvaliable] == YES)
            [subNameMenu5 addObject:[Manager getSubcateName:FREEZONE_MUSIC withThai:YES]];
        [subNameMenu5 addObject:[Manager getSubcateName:FREEZONE_GAME withThai:YES]];
    }
   
    [subNameMenu5 addObject:[Manager getSubcateName:FREEZONE_APPLICATION withThai:YES]];
    if([[Manager sharedManager] isRecAppAvaliable]==YES)
        [subNameMenu5 addObject:[Manager getSubcateName:FREEZONE_RECOMMENDED_APPLICATION withThai:YES]];
    [subNameMenu5 addObject:[Manager getSubcateName:FREEZONE_REGISTER withThai:YES]];
    
      if([[Manager sharedManager] isNormalState]==YES)
          [subNameMenu5 addObject:[Manager getSubcateName:FREEZONE_FREESMS withThai:YES]];
    
    if([[Manager sharedManager] isNormalState]==YES){
        if([[Manager sharedManager]isFreeMusicAvaliable] == YES)
            [subEnumMenu5 addObject:[NSNumber numberWithInteger:FREEZONE_MUSIC] ];
        [subEnumMenu5 addObject:[NSNumber numberWithInteger:FREEZONE_GAME]];
    }
    
    [subEnumMenu5 addObject:[NSNumber numberWithInteger:FREEZONE_APPLICATION]];
    if([[Manager sharedManager] isRecAppAvaliable]==YES)
        [subEnumMenu5 addObject:[NSNumber numberWithInteger:FREEZONE_RECOMMENDED_APPLICATION]];
    [subEnumMenu5 addObject:[NSNumber numberWithInteger:FREEZONE_REGISTER]];
     if([[Manager sharedManager] isNormalState]==YES)
         [subEnumMenu5 addObject:[NSNumber numberWithInteger:FREEZONE_FREESMS]];
    
    if([[Manager sharedManager] isNormalState]==NO){
        subNameMenu4 = [NSArray arrayWithObjects: [Manager getSubcateName:DOWNLOAD_GAME withThai:YES], nil];
        subEnumMenu4 = [NSArray arrayWithObjects: [NSNumber numberWithInteger:DOWNLOAD_GAME], nil];
    }
     NSArray* subNameMenu6 = [NSArray arrayWithObjects:  [Manager getSubcateName:SPORT_NEWS withThai:YES],/*  [Manager getSubcateName:SPORT_INTER_FOOTBALL withThai:YES], [Manager getSubcateName:SPORT_THAI_FOOTBALL withThai:YES],*/ nil];
    
     NSArray* subEnumMenu6 = [NSArray arrayWithObjects:[NSNumber numberWithInteger:SPORT_NEWS] , /*[NSNumber numberWithInteger:SPORT_INTER_FOOTBALL], [NSNumber numberWithInteger:SPORT_THAI_FOOTBALL],*/ nil];
    
    
    NSArray* icon1 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_news_hotnews",@"dtacplay_sidemenu_news_inter", @"dtacplay_sidemenu_news_wiki",@"dtacplay_sidemenu_econews", @"dtacplay_sidemenu_news_it",@"dtacplay_sidemenu_news_lotto",@"dtacplay_sidemenu_news_lottery",@"dtacplay_sidemenu_news_gas", @"dtacplay_sidemenu_news_gold", nil];//@"Icon_Hot News", @"Icon_InterNews", @"Icon_Finance", @"Icon_Technology",@"Icon_Petrolium", @"Icon_Gold", nil];
    NSArray* icon2 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_entertainment_news",@"dtacplay_sidemenu_entertainment_movie",@"dtacplay_sidemenu_entertainment_vdo", nil];
    // NSArray* icon2 = [NSArray arrayWithObjects: @"Icon_Entertain News", @"Icon_Tv.png", @"Icon_Movie", @"Icon_Ticket",@"Icon_Music", @"",@"Icon_Video",@"Icon_Game",@"Icon_Theme",@"Icon_Wallpaper", nil];
    // NSArray* icon3x = [NSArray arrayWithObjects: @"Hot News", @"Internews2.png", @"finance_icon", @"technology_icon",@"oilrate", nil];
    NSArray* icon3 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_life_travel", @"dtacplay_sidemenu_life_rest",@"dtacplay_sidemenu_life_horo", nil];
    NSArray* icon4 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_download_music",@"dtacplay_sidemenu_download_game" ,@"dtacplay_sidemenu_download_news" ,@"dtacplay_sidemenu_download_horo" ,@"dtacplay_sidemenu_download_lotto" ,@"dtacplay_sidemenu_download_lifestyle" ,@"dtacplay_sidemenu_download_sport" ,@"dtacplay_sidemenu_download_clipded" , nil];
    NSMutableArray* icon5 = [[NSMutableArray alloc]init];
    
    if([[Manager sharedManager] isNormalState]==YES){
        if([[Manager sharedManager]isFreeMusicAvaliable] == YES)
            [icon5 addObject:@"dtacplay_sidemenu_free_song"];
        [icon5 addObject:@"dtacplay_sidemenu_free_game"];
    }
    
    [icon5 addObject:@"dtacplay_sidemenu_free_app"];
    if([[Manager sharedManager] isRecAppAvaliable]==YES)
        [icon5 addObject:@"dtacplay_sidemenu_free_recapp"];
    
    [icon5 addObject:@"dtacplay_sidemenu_free_regis"];
    
    if([[Manager sharedManager] isNormalState]==YES)
        [icon5 addObject:@"dtacplay_sidemenu_free_sms"];// sms
    
    if([[Manager sharedManager] isNormalState]==NO){
        icon4 = [NSArray arrayWithObjects:@"dtacplay_sidemenu_download_game" , nil];
    }
    NSArray* icon6 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_sport_news",/* @"dtacplay_sidemenu_sport_inter", @"dtacplay_sidemenu_sport_thai_football",*/ nil];

    subMenuArray = [[NSMutableArray alloc]init];
    subMenuTypeArray = [[NSMutableArray alloc]init];
     subMenuIconArray = [[NSMutableArray alloc]init];
    nameMenu = [[NSMutableArray alloc]init];
    
    if([[Manager sharedManager] newsCategory].isDisable == NO){
        [subMenuArray addObject:subNameMenu];
         [subMenuTypeArray addObject:subEnumMenu];
         [subMenuIconArray addObject:icon1];
        [nameMenu addObject: [[Manager sharedManager] newsCategory].name];
    }
    if([[Manager sharedManager] entertainmentCategory].isDisable == NO){
        [subMenuArray addObject:subNameMenu2];
         [subMenuTypeArray addObject:subEnumMenu2];
         [subMenuIconArray addObject:icon2];
         [nameMenu addObject:[[Manager sharedManager] entertainmentCategory].name];
    }
    if([[Manager sharedManager] promotionCategory].isDisable == NO){

        [subMenuArray addObject:[NSNull null]];
        [subMenuTypeArray addObject:[NSNull null]];
        [subMenuIconArray addObject:[NSNull null]];
        [nameMenu addObject:[[Manager sharedManager] promotionCategory].name];
    }
    if([[Manager sharedManager] lifestyleCategory].isDisable == NO){
        [subMenuArray addObject:subNameMenu3];
        [subMenuTypeArray addObject:subEnumMenu3];
         [subMenuIconArray addObject:icon3];
         [nameMenu addObject:[[Manager sharedManager] lifestyleCategory].name];
    }
    if([[Manager sharedManager] isNormalState]==YES){
         if([[Manager sharedManager] downloadCategory].isDisable == NO){
             [subMenuArray addObject:subNameMenu4];
             [subMenuTypeArray addObject:subEnumMenu4];
             [subMenuIconArray addObject:icon4];
              [nameMenu addObject:[[Manager sharedManager] downloadCategory].name];
         }
        
    }
    if([[Manager sharedManager] freezoneCategory].isDisable == NO){
        [subMenuArray addObject:subNameMenu5];
        [subMenuTypeArray addObject:subEnumMenu5];
         [subMenuIconArray addObject:icon5];
         [nameMenu addObject:[[Manager sharedManager] freezoneCategory].name];
    }
    if([[Manager sharedManager] sportCategory].isDisable == NO){
        [subMenuArray addObject:subNameMenu6];
         [subMenuTypeArray addObject:subEnumMenu6];
         [subMenuIconArray addObject:icon6];
         [nameMenu addObject: [[Manager sharedManager] sportCategory].name];
    }
    if([[Manager sharedManager] shoppingCategory].isDisable == NO){
        [subMenuArray addObject:[NSNull null]];
        [subMenuTypeArray addObject:[NSNull null]];
        [subMenuIconArray addObject:[NSNull null]];
         [nameMenu addObject:[[Manager sharedManager] shoppingCategory].name];
    }
    [subMenuArray addObject:[NSNull null]];//facebook
    [subMenuArray addObject:[NSNull null]];
    [subMenuTypeArray addObject:[NSNull null]];//facebook
    [subMenuTypeArray addObject:[NSNull null]];

    [subMenuIconArray addObject:[NSNull null]];
    [subMenuIconArray addObject:[NSNull null]];
    
     [nameMenu addObject:@"Facebook"];
     [nameMenu addObject:@"ออกจากระบบ"];
}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    if(isKeyboardShow == NO){
    isKeyboardShow = YES;
    NSDictionary* keyboardInfo = [notif userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float y =views.frame.origin.y-  keyboardFrameBeginRect.size.height/2;
    [UIView animateWithDuration:0.2 animations:^{
        views.frame =  CGRectMake(views.frame.origin.x,y , views.frame.size.width, views.frame.size.height);
    }];
    }
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    if(isKeyboardShow == YES){
    isKeyboardShow = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        [views setCenter:CGPointMake(views.center.x, self.view.frame.size.height / 2.0 - 60)];
    }];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self SETUP];
    // Do any additional setup after loading the view.
    navigation = [[NavigationViewController alloc]init];
    widthScreen = 280;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        
    {
        widthScreen = 360;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    
    //
    
    
    // init scrollview
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [scrollView setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [self.view addSubview:scrollView];
    
    //init header
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 255)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [scrollView addSubview:headerView];
    
    // init image header
    profile = [[UIImageView alloc]initWithFrame:CGRectMake(headerView.frame.size.width/2-75,30, 150, 150)];
    [profile setImage:[UIImage imageNamed:@"dtacplay_sidemenu_profile"]];
    [profile setBackgroundColor:[UIColor whiteColor]];
    profile.layer.cornerRadius = 75;
    profile.layer.masksToBounds = YES;
    [headerView addSubview: profile];
    [profile setContentMode:UIViewContentModeScaleAspectFill];
    
    
    
    titleHeader=[[UILabel alloc] initWithFrame:CGRectMake(0,profile.frame.origin.y+profile.frame.size.height+10, widthScreen, 28)];
    [titleHeader setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:16]];
    [titleHeader setTextAlignment:NSTextAlignmentCenter];
    [titleHeader setTextColor:[UIColor whiteColor]];
     titleHeader.text = [NSString stringWithFormat: @"สวัสดีค่ะ"];
    
   
    labelLogin = [NIAttributedLabel new];
   
    labelLogin.font = [UIFont fontWithName:FONT_DTAC_REGULAR size:16];
    //label.backgroundColor = [UIColor whiteColor];
    NSString *imageName = @"dtacplay_sidemenu_login";
    [labelLogin setTextAlignment:NSTextAlignmentCenter];
    //NSString *phone = [[Manager sharedManager] phoneNumber];
    
    labelLogin.text =  [NSString stringWithFormat:@"   เข้าสู่ระบบ" ];
    UIImage *img_login=[UIImage imageNamed:imageName];
    
    [labelLogin insertImage:img_login atIndex:0
                     margins:UIEdgeInsetsMake(5, 0, 0, 0) verticalTextAlignment:NIVerticalTextAlignmentMiddle];
    
    labelLogin.frame = CGRectMake(headerView.frame.origin.x+headerView.frame.size.width/2-60,titleHeader.frame.origin.y+titleHeader.frame.size.height,widthScreen, 40);
    [labelLogin setUserInteractionEnabled:YES];
    showPhoneNumber=[[UILabel alloc] initWithFrame:CGRectMake(0,titleHeader.frame.origin.y+titleHeader.frame.size.height-5,widthScreen, 40)];
    [showPhoneNumber setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:16]];
    [showPhoneNumber setTextAlignment:NSTextAlignmentCenter];
    [showPhoneNumber setTextColor:[UIColor whiteColor]];
    
    
    showPhoneNumber.text =  [NSString stringWithFormat:@"%@",[[Manager sharedManager] phoneNumber]];
    
    labelLogin.textAlignment = NSTextAlignmentCenter;
    [labelLogin setTextColor:[UIColor whiteColor]];
    
    [showPhoneNumber setHidden:YES];
    [labelLogin setHidden:NO];
    [headerView addSubview:showPhoneNumber];
    [headerView addSubview:labelLogin];
    UITapGestureRecognizer *singleFingerTapLogin =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showLogin:)];
    [labelLogin addGestureRecognizer:singleFingerTapLogin];
    
    //NSLocalizedString(@"Home", nil)te
  
    [headerView addSubview:titleHeader];
    //init body
 
    // init HOME page
    MenuBlockView *view_home = [[MenuBlockView alloc]initWithFrame:CGRectMake(0, 0, widthScreen, 40)];
    
    view_home.isShow = YES;
    
    float y = headerView.frame.size.height+headerView.frame.origin.y;
    
    UIView *headerTemp = [[UIView alloc]initWithFrame:CGRectMake(0,y, widthScreen, 40)];
    [headerTemp setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [scrollView addSubview:headerTemp];
    
    NIAttributedLabel* labelBottom = [NIAttributedLabel new];
    labelBottom.text =  [NSString stringWithFormat:@"  หน้าแรก"];
    labelBottom.font = [UIFont fontWithName:FONT_DTAC_REGULAR size:16];
    //label.backgroundColor = [UIColor whiteColor];
    imageName = @"dtacplay_home";

    UIImage *img=[UIImage imageNamed:imageName];
    
    [labelBottom insertImage:img atIndex:0
                     margins:UIEdgeInsetsZero verticalTextAlignment:NIVerticalTextAlignmentMiddle];
    
    labelBottom.frame = CGRectMake(20,5,widthScreen, 45);
    labelBottom.textAlignment = NSTextAlignmentCenter;
    [labelBottom setTextColor:[UIColor whiteColor]];
    
    [headerTemp addSubview:labelBottom];
    //        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20,0, widthScreen, 40)];
    //        [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:16]];
    //        [title setTextAlignment:NSTextAlignmentLeft];
    //        [title setTextColor:[UIColor whiteColor]];
    //        title.text =nameMenu[i];//NSLocalizedString(@"Home", nil)te
    //        [headerTemp addSubview:title];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,0 , headerTemp.frame.size.width-20, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [headerTemp addSubview:lineView];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapHome:)];
    [headerTemp addGestureRecognizer:singleFingerTap];
    
    [view_home setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [scrollView addSubview:view_home];
    [mainMenuArray addObject:view_home];
    [headerArray addObject:headerTemp];
    
    
    mainMenuArray = [[NSMutableArray alloc]init];
    headerArray = [[NSMutableArray alloc]init];
    arrowArray = [[NSMutableArray alloc]init];
    y = view_home.frame.size.height+y;
    for(int i = 0;i< nameMenu.count ; i++){
        float height = 220;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            height = 280;
        
        MenuBlockView *view_menu = [[MenuBlockView alloc]initWithFrame:CGRectMake(0, y+35, widthScreen, height)];
        
        view_menu.isShow = YES;
        
        UIView *headerTemp = [[UIView alloc]initWithFrame:CGRectMake(0,y, widthScreen, 35)];
        [headerTemp setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
        [scrollView addSubview:headerTemp];
        
        NIAttributedLabel* labelBottom = [NIAttributedLabel new];
        labelBottom.text =  [NSString stringWithFormat:@"   %@", nameMenu[i]];
        labelBottom.font = [UIFont fontWithName:FONT_DTAC_REGULAR size:16];
        //label.backgroundColor = [UIColor whiteColor];
        NSString *imageName;
        if([nameMenu[i] isEqualToString:[[Manager sharedManager]newsCategory].name ]){
            imageName = @"dtacplay_sidemenu_news";
            view_menu.type = NEWS;
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]entertainmentCategory].name ]){
            imageName = @"dtacplay_sidemenu_entertainment";
            view_menu.type = ENTERTAINMENT;
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]promotionCategory].name ]){
            imageName = @"dtacplay_sidemenu_promotion";
            view_menu.type = PROMOTION;
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]lifestyleCategory].name ]){
            imageName = @"dtacplay_sidemenu_lifestyle";
            view_menu.type = LIFESTYLE;
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]downloadCategory].name ]){
            imageName = @"dtacplay_sidemenu_download";
            view_menu.type = DOWNLOAD;
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]freezoneCategory].name ]){
            imageName = @"dtacplay_sidemenu_freezone";
            view_menu.type = FREEZONE;
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]sportCategory].name ]){
            imageName = @"dtacplay_sidemenu_sport";
            view_menu.type = SPORT;
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]shoppingCategory].name ]){
            imageName = @"dtacplay_sidemenu_shopping";
            view_menu.type = SHOPPING;
        }
        else if([nameMenu[i] isEqualToString:@"Facebook"]){
            imageName = @"dtacplay_sidemenu_facebook";
            view_menu.type = -1;
        }
        else if([nameMenu[i] isEqualToString:@"ออกจากระบบ"]){
            imageName = @"dtacplay_sidemenu_logout";
            view_menu.type = LOGOUT;
            logout = headerTemp;
        }
        

        UIImage *img=[UIImage imageNamed:imageName];
        
        [labelBottom insertImage:img atIndex:0
                         margins:UIEdgeInsetsZero verticalTextAlignment:NIVerticalTextAlignmentMiddle];
        
        labelBottom.frame = CGRectMake(20,5,widthScreen, 45);
        labelBottom.textAlignment = NSTextAlignmentCenter;
        [labelBottom setTextColor:[UIColor whiteColor]];
        
        [headerTemp addSubview:labelBottom];
        //        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20,0, widthScreen, 40)];
        //        [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:16]];
        //        [title setTextAlignment:NSTextAlignmentLeft];
        //        [title setTextColor:[UIColor whiteColor]];
        //        title.text =nameMenu[i];//NSLocalizedString(@"Home", nil)te
        //        [headerTemp addSubview:title];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,0 , headerTemp.frame.size.width-20, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [headerTemp addSubview:lineView];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [headerTemp addGestureRecognizer:singleFingerTap];
        headerTemp.tag = i;
        view_menu.tag = i;
        
        float height_temp =  [self sortViewTo:view_menu];
        [view_menu setFrame:CGRectMake(view_menu.frame.origin.x, view_menu.frame.origin.y, view_menu.frame.size.width,height_temp)];
        [view_menu setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
        [scrollView addSubview:view_menu];
        [mainMenuArray addObject:view_menu];
        [headerArray addObject:headerTemp];
        
        
        y = y+height_temp+35;
        
        
        UIImageView *hideBox = [[UIImageView alloc]initWithFrame:CGRectMake(headerTemp.frame.size.width-30, 10, 10, 15)];
        [hideBox setImage:[UIImage imageNamed:@"hideBox"]];
        [hideBox setContentMode:UIViewContentModeScaleToFill];
        
        [headerTemp addSubview:hideBox];
        
        [arrowArray addObject:hideBox];
        if(height_temp ==0){
            [hideBox setHidden:YES];
        }
        
        
    }
    [scrollView bringSubviewToFront:headerView];
    [scrollView setContentSize:CGSizeMake(widthScreen, y+60)];
    for(int i = 0;i< nameMenu.count ; i++){
       
        if([nameMenu[i] isEqualToString:[[Manager sharedManager]newsCategory].name ]){
            [self setMenuHidden:i];
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]entertainmentCategory].name ]){
             [self setMenuHidden:i];
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]promotionCategory].name ]){
           
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]lifestyleCategory].name ]){
            [self setMenuHidden:i];
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]downloadCategory].name ]){
             [self setMenuHidden:i];
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]freezoneCategory].name ]){
           [self setMenuHidden:i];
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]sportCategory].name ]){
           [self setMenuHidden:i];
        }
        else if([nameMenu[i] isEqualToString:[[Manager sharedManager]shoppingCategory].name ]){
            
        }
        else if([nameMenu[i] isEqualToString:@"Facebook"]){
          
        }
        else if([nameMenu[i] isEqualToString:@"ออกจากระบบ"]){
           
        }
    }
   
    
    UIView *viewstatusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, widthScreen, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [viewstatusBar setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR ]];
    [self.view addSubview:viewstatusBar];
    
    NSString *userid = [[Manager sharedManager] userID] ;
    if( userid.length >0 && [[Manager sharedManager] phoneNumber].length >0 ){
            phoneNumberForShow = [[Manager sharedManager] phoneNumber];

            [showPhoneNumber setHidden:NO];
            [labelLogin setHidden:YES];
                
        showPhoneNumber.text = [NSString stringWithFormat: @"%@-%@-%@", [phoneNumberForShow substringWithRange:NSMakeRange(0,3)],[phoneNumberForShow substringWithRange:NSMakeRange(3,3)], [phoneNumberForShow substringWithRange:NSMakeRange(6,4)]];
        [logout setFrame:CGRectMake(0, logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *phoneWeb = URL_GET_PHONE_NUMBER;
            NSURL *phoneUrl = [NSURL URLWithString:phoneWeb];
            NSError *error;
            
            NSString *phoneNumber = [NSString stringWithContentsOfURL:phoneUrl
                                                             encoding:NSASCIIStringEncoding
                                                                error:&error];
            if(phoneNumber.length>0){
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phoneNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *phoneNumber_cut = [phoneNumber substringWithRange:NSMakeRange(1, [phoneNumber length]-1)];
            phonNumber_Mssid =  [NSString stringWithFormat:@"66%@", phoneNumber_cut];
            [[Manager sharedManager] setPhoneNumber:phoneNumber];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self LogIn];
                
            });
            }
        });
        
         [logout setFrame:CGRectMake(-logout.frame.size.width, logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
    }
   
}
-(void)setMenuHidden:(int)row{
    
    MenuBlockView* menu = mainMenuArray[row];
    
    for (int i = row; i < mainMenuArray.count; i++) {
        MenuBlockView *menuview = mainMenuArray[i];
        UIView *headerview = headerArray[i];
        [scrollView sendSubviewToBack:menuview];
        [menuview setFrame:CGRectMake(0, menuview.frame.origin.y-menu.frame.size.height, menuview.frame.size.width, menuview.frame.size.height)];
        if(!(row == i)){
            [headerview setFrame:CGRectMake(0, headerview.frame.origin.y-menu.frame.size.height, headerview.frame.size.width, headerview.frame.size.height)];
            
        }
        else{
            UIImageView *arrow = arrowArray[i];
            arrow.transform = CGAffineTransformIdentity;
            [scrollView bringSubviewToFront:headerview];
        }
        
        
        
        [scrollView setContentSize:CGSizeMake(widthScreen, menuview.frame.origin.y+menuview.frame.size.height+headerview.frame.size.height)];
        
        menu.isShow = NO;
        
        NSLog(@"%@ :  %f",nameMenu[row],menuview.frame.origin.y);
    }
    
    
    
}
-(float)sortViewTo:(MenuBlockView*)view{
    
    NSArray *temp = subMenuArray[view.tag];
    NSArray *tempIcon = subMenuIconArray[view.tag];
    float space = 40;
    NSArray *tempArraySubEnum = subMenuTypeArray[view.tag] ;
    float x = 30;
    float y =  5;
    CGSize size = CGSizeMake(50, 55);
    if(![temp isEqual:[NSNull null]]){
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            size = CGSizeMake(70, 50);
        for (int i = 1; i <= temp.count;i++) {
            
            if(i != 4 &&i != 7 && i != 10){
                UIView *menu = [[UIView alloc]initWithFrame:CGRectMake(x, y, size.width, size.height)];
                // [menu setBackgroundColor:[UIColor blackColor]];
                
                [view addSubview:menu];
                UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0,35, size.width+30, 24)];
                
                [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:12]];
                [title setTextAlignment:NSTextAlignmentCenter];
                [title setTextColor:[UIColor whiteColor]];
                
                [menu addSubview:title];
                IconImageView *imageView = [[IconImageView alloc]initWithFrame:CGRectMake(menu.frame.size.width/2-15, 0, 35, 35
                                                                                          )];
                imageView.indexParent = (int)view.tag;
                [self setImageAndTitle:i image:imageView titleLabel:title nameArray:temp iconArray:(tempIcon)];
                
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                [style setLineBreakMode:NSLineBreakByWordWrapping];
                
                CGSize sizeText = [title.text boundingRectWithSize:CGSizeMake(title.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:12 ], NSParagraphStyleAttributeName : style} context:nil].size;
                
                if(sizeText.height>title.frame.size.height){
                    
                    
                    [title setFrame:CGRectMake(-15, 30, size.width+30, sizeText.height)];
                    
                    title.lineBreakMode = NSLineBreakByWordWrapping;
                    title.numberOfLines = 0;
                    
                }
                [title sizeToFit];
                title.center = CGPointMake(imageView.center.x, title.center.y);
                [title setFrame:CGRectMake(title.frame.origin.x,title.frame.origin.y+5, title.frame.size.width,  title.frame.size.height)];
                [imageView setContentMode:UIViewContentModeScaleToFill];
                [menu addSubview:imageView];
                
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(subMenuTap:)];
                pgr.delegate = self;
                [imageView addGestureRecognizer:pgr];
                imageView.type = view.type;
                imageView.tag = i;
                
                imageView.subType = [tempArraySubEnum[i-1] intValue];
                x += size.width+space;
                NSLog(@"%f %f ,index :%d",x,y,i);
            }else{
                y += size.height+20;
                
                x = 30;
                UIView *menu = [[UIView alloc]initWithFrame:CGRectMake(x, y, size.width, size.height)];
                // [menu setBackgroundColor:[UIColor blackColor]];
                
                [view addSubview:menu];
                UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(-10,35, size.width+45, 24)];
                [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:12]];
                [title setTextAlignment:NSTextAlignmentCenter];
                [title setTextColor:[UIColor whiteColor]];
                
                [menu addSubview:title];
                IconImageView *imageView = [[IconImageView alloc]initWithFrame:CGRectMake(menu.frame.size.width/2-15, 0, 35, 35)];
                imageView.indexParent = (int)view.tag;
                
                [self setImageAndTitle:i image:imageView titleLabel:title nameArray:temp iconArray:(tempIcon)];
                if(view.type == FREEZONE){
                    [imageView setFrame:CGRectMake(menu.frame.size.width/2-15, 5, 30, 30)];
                }
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                [style setLineBreakMode:NSLineBreakByWordWrapping];
                
                CGSize sizeText = [title.text boundingRectWithSize:CGSizeMake(title.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:12 ], NSParagraphStyleAttributeName : style} context:nil].size;
                
                if(sizeText.height>title.frame.size.height){
                    
                    
                    [title setFrame:CGRectMake(-15, 30, size.width, sizeText.height)];
                    
                    title.lineBreakMode = NSLineBreakByWordWrapping;
                    title.numberOfLines = 0;
                    
                }
                [title sizeToFit];
                title.center = CGPointMake(imageView.center.x, title.center.y);
                [title setFrame:CGRectMake(title.frame.origin.x,title.frame.origin.y+5, title.frame.size.width,  title.frame.size.height)];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                [menu addSubview:imageView];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(subMenuTap:)];
                pgr.delegate = self;
                imageView.type = view.type;
                imageView.tag = i;
                imageView.subType = [tempArraySubEnum[i-1] intValue];
                [imageView addGestureRecognizer:pgr];
                NSLog(@"%f %f ,index :%d",x,y,i);
                space = 40;
                x += size.width+space;
            }
        }
        return y+size.height+20;
    }
    
    return 0;
}

-(void)setImageAndTitle:(int)index image:(UIImageView*)imageView titleLabel:(UILabel*)title nameArray:(NSArray*)name iconArray:(NSArray*)icon{
    title.text = [NSString stringWithFormat:@"%@",name[index-1]];
    NSString *imageName =  [NSString stringWithFormat:@"%@",icon[index-1]];
    [imageView setImage:[UIImage imageNamed:imageName]];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
 
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
-(void)setTheme:(UIColor *)color{
    
    
    [profile.layer setBorderColor: [color CGColor]];
    [profile.layer setBorderWidth: 5.0];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    UIView * view = recognizer.view;
    MenuBlockView* menu = mainMenuArray[view.tag];
    
    if(menu.frame.size.height >0){
        if(menu.isShow == YES){
            for (int i = (int)view.tag; i < mainMenuArray.count; i++) {
                MenuBlockView *menuview = mainMenuArray[i];
                UIView *headerview = headerArray[i];
                
                [scrollView sendSubviewToBack:menuview];
                [UIView transitionWithView:self.view
                                  duration:0.25
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    [menuview setFrame:CGRectMake(0, menuview.frame.origin.y-menu.frame.size.height, menuview.frame.size.width, menuview.frame.size.height)];
                                    if(!(view.tag == i)){
                                        [headerview setFrame:CGRectMake(0, headerview.frame.origin.y-menu.frame.size.height, headerview.frame.size.width, headerview.frame.size.height)];
                                        
                                    }
                                    else{
                                        UIImageView *arrow = arrowArray[i];
                                        arrow.transform = CGAffineTransformIdentity;
                                        [scrollView bringSubviewToFront:headerview];
                                    }
                                    
                                    
                                }
                                completion:^(BOOL finsihed){
                                    [UIView transitionWithView:self.view
                                                      duration:0.25
                                                       options:UIViewAnimationOptionCurveLinear
                                                    animations:^{
                                                        
                                                        [scrollView setContentSize:CGSizeMake(widthScreen, menuview.frame.origin.y+menuview.frame.size.height)];
                                                    }
                                                    completion:^(BOOL finsihed){
                                                        
                                                        
                                                    }];
                                }];
                    
                
            }
            menu.isShow = NO;
        }
        else{
            for (int i = (int)view.tag; i < mainMenuArray.count; i++) {
                MenuBlockView *menuview = mainMenuArray[i];
                UIView *headerview = headerArray[i];
                
                [scrollView sendSubviewToBack:menuview];
                [UIView transitionWithView:self.view
                                  duration:0.25
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    [menuview setFrame:CGRectMake(0, menuview.frame.origin.y+menu.frame.size.height, menuview.frame.size.width, menuview.frame.size.height)];
                                    if(!(view.tag == i)){
                                        [headerview setFrame:CGRectMake(0, headerview.frame.origin.y+menu.frame.size.height, headerview.frame.size.width, headerview.frame.size.height)];
                                        
                                    }
                                    else{
                                        UIImageView *arrow = arrowArray[i];
                                        arrow.transform = CGAffineTransformMakeRotation(90.0*M_PI/180.0);
                                        [scrollView bringSubviewToFront:headerview];
                                    }
                                    
                                }
                                completion:^(BOOL finsihed){
                                    [UIView transitionWithView:self.view
                                                      duration:0.25
                                                       options:UIViewAnimationOptionCurveLinear
                                                    animations:^{
                                                        [scrollView setContentSize:CGSizeMake(widthScreen, menuview.frame.origin.y+menuview.frame.size.height)];
                                                    }
                                                    completion:^(BOOL finsihed){
                                                        
                                                        
                                                    }];
                                    
                                    
                                    if(i == view.tag){
                                        CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
                                        if(bottomOffset.y >0)
                                            [scrollView setContentOffset:bottomOffset animated:YES];
                                    }
                                    
                                    
                                }];
                }
            
            menu.isShow = YES;
        }
    }
    else{
        
        if([nameMenu[view.tag] isEqualToString:[[Manager sharedManager] promotionCategory].name ]){
            PromotionViewController*   promotionPage= [[PromotionViewController alloc] init];
            navigation.viewControllers = @[promotionPage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
        }
        else if([nameMenu[view.tag] isEqualToString:[[Manager sharedManager] shoppingCategory].name ]){
            ShoppingViewController*   shopping= [[ShoppingViewController alloc] init];
            navigation.viewControllers = @[shopping];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
            
        }
        else if([nameMenu[view.tag] isEqualToString:@"Facebook" ]){
            NSURL *webURL = [NSURL URLWithString:@"https://www.facebook.com/DtacPlay-1536201406616365/?fref=ts"];
            [[UIApplication sharedApplication] openURL: webURL];
            
        }
        else if([nameMenu[view.tag] isEqualToString:@"ออกจากระบบ"]){
            [self logOut];
        }
        
    }
}
- (void)handleSingleTapHome:(UITapGestureRecognizer *)recognizer {
    
    DtacHomeViewController* home = [[DtacHomeViewController alloc] init];
    
    navigation.viewControllers = @[home];
    
    
    self.frostedViewController.contentViewController = navigation;
    [self.frostedViewController hideMenuViewController];
}

//subMenuTap
- (void)subMenuTap:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    
    IconImageView *image = (IconImageView*)pinchGestureRecognizer.view;

    NSArray *menu ;
    
    if([[Manager getCateName:image.type withThai:YES] isEqualToString:[[Manager sharedManager] newsCategory].name ]){
     
        _newsPage= [[NewsViewController alloc] init];
        
        _newsPage.nameMenu = subMenuTypeArray[image.indexParent];
        _newsPage.indexPage = (int)image.tag-1;
        _newsPage.pageType = image.type;
        _newsPage.subeType = image.subType;
        navigation.viewControllers = @[_newsPage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([[Manager getCateName:image.type withThai:YES] isEqualToString:[[Manager sharedManager] entertainmentCategory].name ]){
       
        self.entPage= [[EntertainmentViewController alloc] init];
        
        self.entPage.nameMenu = subMenuTypeArray[image.indexParent];
        self.entPage.indexPage = (int)image.tag-1;
        self.entPage.pageType = image.type;
        self.entPage.subeType = image.subType;
        navigation.viewControllers = @[self.entPage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([[Manager getCateName:image.type withThai:YES] isEqualToString:[[Manager sharedManager] lifestyleCategory].name ]){
       
        self.lifeStylePage= [[LifeStyleViewController alloc] init];
        
        self.lifeStylePage.nameMenu = subMenuTypeArray[image.indexParent];
        self.lifeStylePage.indexPage = (int)image.tag-1;
        self.lifeStylePage.pageType = image.type;
        self.lifeStylePage.subeType = image.subType;
        navigation.viewControllers = @[self.lifeStylePage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([[Manager getCateName:image.type withThai:YES] isEqualToString:[[Manager sharedManager] freezoneCategory].name ]){
        
        
        self.freePage= [[FreeZoneViewController alloc] init];
        
        self.freePage.nameMenu = subMenuTypeArray[image.indexParent];
        self.freePage.indexPage = (int)image.tag-1;
        self.freePage.pageType = image.type;
        self.freePage.subeType = image.subType;
        navigation.viewControllers = @[self.freePage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([[Manager getCateName:image.type withThai:YES] isEqualToString:[[Manager sharedManager] downloadCategory].name ]){
        
        self.downloadPage= [[DownloadViewController alloc] init];
        
        self.downloadPage.nameMenu = subMenuTypeArray[image.indexParent];
        self.downloadPage.indexPage = (int)image.tag-1;
        self.downloadPage.pageType = image.type;
        self.downloadPage.subeType = image.subType;
        navigation.viewControllers = @[self.downloadPage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    else if([[Manager getCateName:image.type withThai:YES] isEqualToString:[[Manager sharedManager] sportCategory].name ]){
        
        self.sportPage= [[SportViewController alloc] init];
        
        self.sportPage.nameMenu = subMenuTypeArray[image.indexParent];
        self.sportPage.indexPage = (int)image.tag-1;
        self.sportPage.pageType = image.type;
        self.sportPage.subeType = image.subType;
        navigation.viewControllers = @[self.sportPage];
        
        
        self.frostedViewController.contentViewController = navigation;
        [self.frostedViewController hideMenuViewController];
    }
    
    
    
    
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)showLogin:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *phoneWeb = URL_GET_PHONE_NUMBER;
        NSURL *phoneUrl = [NSURL URLWithString:phoneWeb];
        NSError *error;
        
        NSString *phoneNumber = [NSString stringWithContentsOfURL:phoneUrl
                                                         encoding:NSASCIIStringEncoding
                                                            error:&error];
        if(phoneNumber.length>0){
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phoneNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString* phoneNumber_cut = [phoneNumber substringWithRange:NSMakeRange(1, [phoneNumber length]-1)];
            phonNumber_Mssid =  [NSString stringWithFormat:@"66%@", phoneNumber_cut];
            [[Manager sharedManager] setPhoneNumber:phoneNumber];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self LogIn];
            
        });

        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [Manager savePageView:0 orSubCate:FREEZONE_REGISTER];
                NSString *phoneNumber;
                if([[Manager sharedManager] phoneNumber].length > 0){
                    phoneNumber = [[[Manager sharedManager] phoneNumber]
                                   stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                }
                black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIApplication sharedApplication] delegate].window.frame.size.width, [[UIApplication sharedApplication] delegate].window.frame.size.height)];
                [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
                [[[UIApplication sharedApplication] delegate].window addSubview:black];
                
                UITapGestureRecognizer *singleFingerTap =
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(hidePopup:)];
                [black addGestureRecognizer:singleFingerTap];
                
                views = [[[NSBundle mainBundle] loadNibNamed:@"RegisterFreeZone" owner:self options:nil] objectAtIndex:0];
                [views setFrame:CGRectMake(10,100, [[UIApplication sharedApplication] delegate].window.frame.size.width-20, 329)];
                views.tag = 1;
                views.phoneNumberTextField.text = phoneNumber.length >0 ? phoneNumber : [[NSUserDefaults standardUserDefaults]
                                                                                                              objectForKey:@"phoneNumber"];
       
                NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
                
                views.delegate = self;
                [views setBackgroundColor:[UIColor whiteColor]];
                views.alpha = 0.8;
                [views setCenter:CGPointMake([[UIApplication sharedApplication] delegate].window.frame.size.width / 2.0, [[UIApplication sharedApplication] delegate].window.frame.size.height / 2.0 -60)];
                [ppp setCenter:CGPointMake([[UIApplication sharedApplication] delegate].window.frame.size.width / 2.0, [[UIApplication sharedApplication] delegate].window.frame.size.height / 2.0 -60)];
                [[[UIApplication sharedApplication] delegate].window addSubview:views];
                
                [UIView transitionWithView:self.view
                                  duration:0.5
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    views.alpha = 1;
                                    [black setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
                                }
                                completion:nil];

                
            });
        }
    });
}

-(void)buttonPupUpPress:(PopUp*)type{
    if(type.type != 1){
        
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
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
        [ppp setCenter:CGPointMake([[UIApplication sharedApplication] delegate].window.frame.size.width / 2.0, [[UIApplication sharedApplication] delegate].window.frame.size.height / 2.0)];
        [[[UIApplication sharedApplication] delegate].window addSubview:ppp];
        [ppp setFrame:CGRectMake(ppp.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
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
        [ppp setCenter:CGPointMake([[UIApplication sharedApplication] delegate].window.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        [[[UIApplication sharedApplication] delegate].window addSubview:ppp];
        [ppp setFrame:CGRectMake(ppp.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
                        }
                        completion:^(BOOL finished){
                            
                        }];
        
        
        
    }
    else{
        [self submitRegisterFreezone:number];
    }
}
-(void)hidePopup:(id)sender{
    
    if(!isKeyboardShow){
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
    
    }else{
        [views.phoneNumberTextField resignFirstResponder];
        [views.OTPTextField resignFirstResponder];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)sendRegisterFreezone:(NSString*)number{
    
    NSString *phoneNumber = [number substringWithRange:NSMakeRange(1, [number length]-1)];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getOTP\",\"params\":{ \"otpType\":4, \"msisdn\":66%@ }}",phoneNumber];
    
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]] && [responseObject objectForKey:@"result"]) {
            
            NSDictionary* dic = [responseObject objectForKey:@"result"];
            
            vierfyMsg = [dic objectForKey:@"verifyMsg"];//verifyMsg;
            phonNumber_Mssid =  [NSString stringWithFormat:@"66%@", phoneNumber];
            phoneNumberForShow = number;
            [views.submitPhoneButton setUserInteractionEnabled:NO];
            [views.submitPhoneButton setAlpha:0.5];
            views.codeReference.text = [NSString stringWithFormat:@"กรอกรหัสผ่านเพื่อเข้าใช้งาน (%@)",vierfyMsg];
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
            [ppp setCenter:CGPointMake([[UIApplication sharedApplication] delegate].window.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
            [[[UIApplication sharedApplication] delegate].window addSubview:ppp];
            [ppp setFrame:CGRectMake(ppp.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
            [UIView transitionWithView:self.view
                              duration:0.2
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                views.alpha = 1;
                                [views setFrame:CGRectMake(views.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                [ppp setFrame:CGRectMake(ppp.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
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
        [ppp setCenter:CGPointMake([[UIApplication sharedApplication] delegate].window.frame.size.width/ 2.0, self.view.frame.size.height / 2.0)];
        [self.view addSubview:ppp];
        [ppp setFrame:CGRectMake(ppp.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
        [UIView transitionWithView:self.view
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            views.alpha = 1;
                            [views setFrame:CGRectMake(views.frame.origin.x-self.view.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                            [ppp setFrame:CGRectMake(ppp.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
                        }
                        completion:^(BOOL finished){
                            
                        }];
    }];
    [op start];
    
}
-(void)submitRegisterFreezone:(NSString*)number{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"msisdnLogin\",\"params\":{ \"msisdn\":%@, \"channel\":2, \"verifyMsg\":\"%@\", \"verifyCode\":\"%@\"}}",phonNumber_Mssid,vierfyMsg,[self calculateSHA:number] ];//vierfyCode,[self calculateSHA:number],phonNumber_Mssid
    
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if([responseObject objectForKey:@"result"]){
            
                NSDictionary *result = [responseObject objectForKey:@"result"];
                
                if(![[result objectForKey:@"userId"] isEqual:[NSNull null]]){
                    [[NSUserDefaults standardUserDefaults] setObject:phoneNumberForShow forKey:@"phoneNumber"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[Manager sharedManager] setPhoneNumber:phoneNumberForShow];
                    
                    NSString * temp = [[NSUserDefaults standardUserDefaults]
                                       objectForKey:@"phoneNumber"];
                    
                    [self whenClosePopUp:0];
                    phoneNumberForShow = [[Manager sharedManager] phoneNumber];
                    if(phoneNumberForShow.length > 0){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // showPhoneNumber.text =  [NSString stringWithFormat:@"%@",[[Manager sharedManager] phoneNumber]];
                            [showPhoneNumber setHidden:NO];
                            [labelLogin setHidden:YES];
                            
                            showPhoneNumber.text =  [NSString stringWithFormat: @"%@-%@-%@", [phoneNumberForShow substringWithRange:NSMakeRange(0,3)],[phoneNumberForShow substringWithRange:NSMakeRange(3,3)], [phoneNumberForShow substringWithRange:NSMakeRange(6,4)]];
                            [[Manager sharedManager] setUserID:[[result objectForKey:@"userId"] stringValue]];
                            [UIView transitionWithView:self.view
                                              duration:0.25
                                               options:UIViewAnimationOptionCurveLinear
                                            animations:^{
                                                [logout setFrame:CGRectMake(0, logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
                                                
                                            }
                                            completion:^(BOOL finsihed){
                                                
                                            }];
                        });
                    }
                }
                else{
                    ppp = [[[NSBundle mainBundle] loadNibNamed:@"PopUp" owner:self options:nil] objectAtIndex:0];
                    ppp.titleLabel.text = @"คุณกรอกรหัสผ่านไม่ถูกต้อง";
                    ppp.delegate = self;
                    [ppp setBackgroundColor:[UIColor whiteColor]];
                    [ppp setCenter:CGPointMake([[UIApplication sharedApplication] delegate].window.frame.size.width / 2.0, [[UIApplication sharedApplication] delegate].window.frame.size.height / 2.0)];
                    [[[UIApplication sharedApplication] delegate].window addSubview:ppp];
                    [ppp setFrame:CGRectMake(ppp.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
                    [UIView transitionWithView:self.view
                                      duration:0.2
                                       options:UIViewAnimationOptionCurveLinear
                                    animations:^{
                                        views.alpha = 1;
                                        [views setFrame:CGRectMake(views.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                        [ppp setFrame:CGRectMake(ppp.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
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
            [[[UIApplication sharedApplication] delegate].window addSubview:ppp];
            [ppp setFrame:CGRectMake(ppp.frame.origin.x+[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
            [UIView transitionWithView:self.view
                              duration:0.2
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                views.alpha = 1;
                                [views setFrame:CGRectMake(views.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width, views.frame.origin.y, views.frame.size.width, views.frame.size.height)];
                                [ppp setFrame:CGRectMake(ppp.frame.origin.x-[[UIApplication sharedApplication] delegate].window.frame.size.width,ppp.frame.origin.y, 257, 132)];
                            }
                            completion:^(BOOL finished){
                                
                            }];
        }

        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]] && [responseObject objectForKey:@"result"]) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            
            if(![[result objectForKey:@"userId"] isEqual:[NSNull null]]){
                phoneNumberForShow = [[Manager sharedManager] phoneNumber];
                if(phoneNumberForShow.length > 0){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // showPhoneNumber.text =  [NSString stringWithFormat:@"%@",[[Manager sharedManager] phoneNumber]];
                        [showPhoneNumber setHidden:NO];
                        [labelLogin setHidden:YES];
                        
                        showPhoneNumber.text =  [NSString stringWithFormat: @"%@-%@-%@", [phoneNumberForShow substringWithRange:NSMakeRange(0,3)],[phoneNumberForShow substringWithRange:NSMakeRange(3,3)], [phoneNumberForShow substringWithRange:NSMakeRange(6,4)]];
                        [[Manager sharedManager] setUserID:[[result objectForKey:@"userId"] stringValue]];
                        [UIView transitionWithView:self.view
                                          duration:0.25
                                           options:UIViewAnimationOptionCurveLinear
                                        animations:^{
                                            [logout setFrame:CGRectMake(0, logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
                                            
                                        }
                                        completion:^(BOOL finsihed){
                                            
                                        }];
                    });
                }
            }
        }
        else{
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];
    [op start];

    
}
-(void)whenClosePopUp:(int)type{
    [ppp removeFromSuperview];
    [black removeFromSuperview];
    [views removeFromSuperview];
}
-(void)LogIn{
    
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"msisdnLogin\",\"params\":{ \"msisdn\":%@, \"channel\":1, \"verifyMsg\":null, \"verifyCode\":null}}",phonNumber_Mssid ];
    
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]] && [responseObject objectForKey:@"result"]) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            
            if(![[result objectForKey:@"userId"] isEqual:[NSNull null]]){
                phoneNumberForShow = [[Manager sharedManager] phoneNumber];
                if(phoneNumberForShow.length > 0){
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    // showPhoneNumber.text =  [NSString stringWithFormat:@"%@",[[Manager sharedManager] phoneNumber]];
                    [showPhoneNumber setHidden:NO];
                    [labelLogin setHidden:YES];
                    
                    showPhoneNumber.text =  [NSString stringWithFormat: @"%@-%@-%@", [phoneNumberForShow substringWithRange:NSMakeRange(0,3)],[phoneNumberForShow substringWithRange:NSMakeRange(3,3)], [phoneNumberForShow substringWithRange:NSMakeRange(6,4)]];
                    [[Manager sharedManager] setUserID:[[result objectForKey:@"userId"] stringValue]];
                    [UIView transitionWithView:self.view
                                      duration:0.25
                                       options:UIViewAnimationOptionCurveLinear
                                    animations:^{
                                        [logout setFrame:CGRectMake(0, logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
                                        
                                    }
                                    completion:^(BOOL finsihed){
                                        
                                    }];
                });
            }
            }
        }
        else{
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];
    [op start];
    
}

-(void)logOut{
    

    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"logout\",\"params\":{ \"userId\":%@}}",[[Manager sharedManager] userID] ];
    
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            [showPhoneNumber setHidden:YES];
            [labelLogin setHidden:NO];
            
           // showPhoneNumber.text = [NSString stringWithFormat: @"%@",phoneNumberForShow];
            
            [UIView transitionWithView:self.view
                              duration:0.25
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                [logout setFrame:CGRectMake(-logout.frame.size.width,logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
                                
                            }
                            completion:^(BOOL finsihed){
                                
                            }];
            
            
        }
        else{
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
  
    }];
    [op start];

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
