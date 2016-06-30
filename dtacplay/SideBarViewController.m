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
#import "EntertainmentViewController.h"
#import "FreeZoneViewController.h"
#import "ShoppingViewController.h"
#import "DownloadViewController.h"
#import "SportViewController.h"
@interface SideBarViewController ()<UIGestureRecognizerDelegate>
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
    
    NIAttributedLabel* labelLogin;
    UILabel *showPhoneNumber;
    UIView *logout;
}
@end

@implementation SideBarViewController
-(void)SETUP{
    
    NSArray* subNameMenu = [NSArray arrayWithObjects: [Manager getSubcateName:NEWS_HOT_NEWS withThai:YES],[Manager getSubcateName:NEWS_INTER_NEWS withThai:YES],[Manager getSubcateName:NEWS_WIKI withThai:YES], [Manager getSubcateName:NEWS_FINANCE withThai:YES], [Manager getSubcateName:NEWS_TECHNOLOGY withThai:YES],[Manager getSubcateName:NEWS_LOTTO withThai:YES],[Manager getSubcateName:NEWS_LOTTERRY withThai:YES],[Manager getSubcateName:NEWS_GAS_PRICE withThai:YES], [Manager getSubcateName:NEWS_GOLD_PRICE withThai:YES], nil];
    
    NSArray* subEnumMenu = [NSArray arrayWithObjects:[NSNumber numberWithInteger:NEWS_HOT_NEWS] , [NSNumber numberWithInteger:NEWS_INTER_NEWS],[NSNumber numberWithInteger:NEWS_WIKI] , [NSNumber numberWithInteger:NEWS_FINANCE], [NSNumber numberWithInteger:NEWS_TECHNOLOGY], [NSNumber numberWithInteger:NEWS_LOTTO], [NSNumber numberWithInteger:NEWS_LOTTERRY], [NSNumber numberWithInteger:NEWS_GAS_PRICE], [NSNumber numberWithInteger:NEWS_GOLD_PRICE], nil];
    
    NSArray* subNameMenu2 = [NSArray arrayWithObjects: [Manager getSubcateName:ENTERTAINMENT_NEWS withThai:YES]/*,[Manager getSubcateName:ENTERTAINMENT_MOVIE withThai:YES]*/,[Manager getSubcateName:ENTERTAINMENT_VIDEO withThai:YES], nil];
    NSArray* subEnumMenu2 = [NSArray arrayWithObjects:[NSNumber numberWithInteger:ENTERTAINMENT_NEWS]/*,[NSNumber numberWithInteger:ENTERTAINMENT_MOVIE] */,[NSNumber numberWithInteger:ENTERTAINMENT_VIDEO] , nil];
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
    
    
    subMenuArray = [[NSMutableArray alloc]init];
    [subMenuArray addObject:subNameMenu];
    [subMenuArray addObject:subNameMenu2];
    [subMenuArray addObject:[NSNull null]];
    [subMenuArray addObject:subNameMenu3];
    if([[Manager sharedManager] isNormalState]==YES)
        [subMenuArray addObject:subNameMenu4];
    [subMenuArray addObject:subNameMenu5];
    [subMenuArray addObject:subNameMenu6];
    [subMenuArray addObject:[NSNull null]];
    [subMenuArray addObject:[NSNull null]];//facebook
    [subMenuArray addObject:[NSNull null]];//twiiter
    
    subMenuTypeArray = [[NSMutableArray alloc]init];
    [subMenuTypeArray addObject:subEnumMenu];
    [subMenuTypeArray addObject:subEnumMenu2];
    [subMenuTypeArray addObject:[NSNull null]];
    [subMenuTypeArray addObject:subEnumMenu3];
     if([[Manager sharedManager] isNormalState]==YES)
    [subMenuTypeArray addObject:subEnumMenu4];
    [subMenuTypeArray addObject:subEnumMenu5];
    [subMenuTypeArray addObject:subEnumMenu6];
    [subMenuTypeArray addObject:[NSNull null]];
    [subMenuTypeArray addObject:[NSNull null]];//facebook
    [subMenuTypeArray addObject:[NSNull null]];//twiiter
    
    NSArray* icon1 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_news_hotnews",@"dtacplay_sidemenu_news_inter", @"dtacplay_sidemenu_news_wiki",@"dtacplay_sidemenu_econews", @"dtacplay_sidemenu_news_it",@"dtacplay_sidemenu_news_lotto",@"dtacplay_sidemenu_news_lottery",@"dtacplay_sidemenu_news_gas", @"dtacplay_sidemenu_news_gold", nil];//@"Icon_Hot News", @"Icon_InterNews", @"Icon_Finance", @"Icon_Technology",@"Icon_Petrolium", @"Icon_Gold", nil];
    NSArray* icon2 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_entertainment_news"/*,@"dtacplay_sidemenu_entertainment_movie"*/,@"dtacplay_sidemenu_entertainment_vdo", nil];
    // NSArray* icon2 = [NSArray arrayWithObjects: @"Icon_Entertain News", @"Icon_Tv.png", @"Icon_Movie", @"Icon_Ticket",@"Icon_Music", @"",@"Icon_Video",@"Icon_Game",@"Icon_Theme",@"Icon_Wallpaper", nil];
    // NSArray* icon3x = [NSArray arrayWithObjects: @"Hot News", @"Internews2.png", @"finance_icon", @"technology_icon",@"oilrate", nil];
    NSArray* icon3 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_life_travel", @"dtacplay_sidemenu_life_rest",@"dtacplay_sidemenu_life_horo", nil];
    NSArray* icon4 = [NSArray arrayWithObjects: @"dtacplay_sidemenu_download_music",@"dtacplay_sidemenu_download_game" ,@"dtacplay_sidemenu_download_news" ,@"dtacplay_sidemenu_download_horo" ,@"dtacplay_sidemenu_download_lotto" ,@"dtacplay_sidemenu_download_lifestyle" ,@"dtacplay_sidemenu_download_sport" ,@"dtacplay_sidemenu_download_clipded" , nil];
    NSMutableArray* icon5 = [[NSMutableArray alloc]init];
    
    if([[Manager sharedManager] isNormalState]==YES){
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
    
    subMenuIconArray = [[NSMutableArray alloc]init];
    
    [subMenuIconArray addObject:icon1];
    [subMenuIconArray addObject:icon2];
    [subMenuIconArray addObject:[NSNull null]];
    [subMenuIconArray addObject:icon3];
     if([[Manager sharedManager] isNormalState]==YES)
    [subMenuIconArray addObject:icon4];
     [subMenuIconArray addObject:icon5];
     [subMenuIconArray addObject:icon6];
    [subMenuIconArray addObject:[NSNull null]];
    [subMenuIconArray addObject:[NSNull null]];
    [subMenuIconArray addObject:[NSNull null]];
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
    
   
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    
    //
    
    
    // init scrollview
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [scrollView setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [self.view addSubview:scrollView];
    
    //init header
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 230)];
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
    
    showPhoneNumber=[[UILabel alloc] initWithFrame:CGRectMake(0,titleHeader.frame.origin.y+titleHeader.frame.size.height,widthScreen, 40)];
    [showPhoneNumber setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:16]];
    [showPhoneNumber setTextAlignment:NSTextAlignmentCenter];
    [showPhoneNumber setTextColor:[UIColor whiteColor]];
    
    
    showPhoneNumber.text =  [NSString stringWithFormat:@"%@",[[Manager sharedManager] phoneNumber]];
    
    labelLogin.textAlignment = NSTextAlignmentCenter;
    [labelLogin setTextColor:[UIColor whiteColor]];
    
    [showPhoneNumber setHidden:YES];
    [labelLogin setHidden:YES];
    [headerView addSubview:showPhoneNumber];
    [headerView addSubview:labelLogin];
    
    //NSLocalizedString(@"Home", nil)te
  
    [headerView addSubview:titleHeader];
    //init body
    NSArray* nameMenu = [NSArray arrayWithObjects: [[Manager sharedManager] newsCategory].name,[[Manager sharedManager] entertainmentCategory].name,[[Manager sharedManager] promotionCategory].name, [[Manager sharedManager] lifestyleCategory].name,[[Manager sharedManager] downloadCategory].name,[[Manager sharedManager] freezoneCategory].name, [[Manager sharedManager] sportCategory].name, [[Manager sharedManager] shoppingCategory].name, @"Facebook", nil];//NSArray arrayWithObjects: @"ข่าว", @"บันเทิง",@"โปรโมชั่น", @"ไลฟ์สไตล์",@"ฟรีโซน",@"กีฬา", @"ช้อปปิ้ง", @"Facebook", @"Twitter", nil];
     if([[Manager sharedManager] isNormalState]==NO)
     {
         nameMenu = [NSArray arrayWithObjects: [[Manager sharedManager] newsCategory].name, [[Manager sharedManager] entertainmentCategory].name,[[Manager sharedManager] promotionCategory].name, [[Manager sharedManager] lifestyleCategory].name,[[Manager sharedManager] freezoneCategory].name, [[Manager sharedManager] sportCategory].name, [[Manager sharedManager] shoppingCategory].name, @"Facebook", nil];
     }
    // init HOME page
    MenuBlockView *view = [[MenuBlockView alloc]initWithFrame:CGRectMake(0, 0, widthScreen, 40)];
    
    view.isShow = YES;
    
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
    
    [view setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [scrollView addSubview:view];
    [mainMenuArray addObject:view];
    [headerArray addObject:headerTemp];
    
    
    mainMenuArray = [[NSMutableArray alloc]init];
    headerArray = [[NSMutableArray alloc]init];
    arrowArray = [[NSMutableArray alloc]init];
    y = view.frame.size.height+y;
    for(int i = 0;i< nameMenu.count ; i++){
        float height = 220;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            height = 280;
        
        MenuBlockView *view = [[MenuBlockView alloc]initWithFrame:CGRectMake(0, y+35, widthScreen, height)];
        
        view.isShow = YES;
        
        UIView *headerTemp = [[UIView alloc]initWithFrame:CGRectMake(0,y, widthScreen, 35)];
        [headerTemp setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
        [scrollView addSubview:headerTemp];
        
        NIAttributedLabel* labelBottom = [NIAttributedLabel new];
        labelBottom.text =  [NSString stringWithFormat:@"   %@", nameMenu[i]];
        labelBottom.font = [UIFont fontWithName:FONT_DTAC_REGULAR size:16];
        //label.backgroundColor = [UIColor whiteColor];
        NSString *imageName;
           if([[Manager sharedManager] isNormalState]==YES)
        switch (i) {
            case 0:
                imageName = @"dtacplay_sidemenu_news";
                view.type = NEWS;
                break;
            case 1:
                imageName = @"dtacplay_sidemenu_entertainment";
                view.type = ENTERTAINMENT;
                break;
            case 2:
                imageName = @"dtacplay_sidemenu_promotion";
                view.type = PROMOTION;
                break;
            case 3:
                imageName = @"dtacplay_sidemenu_lifestyle";
                view.type = LIFESTYLE;
                break;
            case 4:
                imageName = @"dtacplay_sidemenu_download";
                view.type = DOWNLOAD;
                break;
            case 5:
                imageName = @"dtacplay_sidemenu_freezone";
                view.type = FREEZONE;
                break;
                //            case 5:
                //                imageName = @"Icon_Sport";
                //                 view.type = SPORT;
                //                break;
                
            case 6:
                imageName = @"dtacplay_sidemenu_sport";
                view.type = SPORT;
                break;
            case 7:
                imageName = @"dtacplay_sidemenu_shopping";
                view.type = SHOPPING;
                break;
                //Icon_Facebook
            case 8:
                imageName = @"dtacplay_sidemenu_facebook";
                break;
            case 9:
                imageName = @"dtacplay_sidemenu_login";
                view.type = LOGOUT;
                logout = headerTemp;
                // [headerTemp setHidden:YES];
                break;
            default:
                imageName = @"Icon_Classified";
                break;
        }
        else
            switch (i) {
                case 0:
                    imageName = @"dtacplay_sidemenu_news";
                    view.type = NEWS;
                    break;
                case 1:
                    imageName = @"dtacplay_sidemenu_entertainment";
                    view.type = ENTERTAINMENT;
                    break;
                case 2:
                    imageName = @"dtacplay_sidemenu_promotion";
                    view.type = PROMOTION;
                    break;
                case 3:
                    imageName = @"dtacplay_sidemenu_lifestyle";
                    view.type = LIFESTYLE;
                    break;
                case 4:
                    imageName = @"dtacplay_sidemenu_freezone";
                    view.type = FREEZONE;
                    break;
                    //            case 5:
                    //                imageName = @"Icon_Sport";
                    //                 view.type = SPORT;
                    //                break;
                    
                case 5:
                    imageName = @"dtacplay_sidemenu_sport";
                    view.type = SPORT;
                    break;
                case 6:
                    imageName = @"dtacplay_sidemenu_shopping";
                    view.type = SHOPPING;
                    break;
                    //Icon_Facebook
                case 7:
                    imageName = @"dtacplay_sidemenu_facebook";
                    break;
                case 8:
                    imageName = @"dtacplay_sidemenu_login";
                    view.type = LOGOUT;
                      logout = headerTemp;
                    //[headerTemp setHidden:YES];
                default:
                    imageName = @"Icon_Classified";
                    break;
            }
        
        UIImage *img=[UIImage imageNamed:imageName];
        
        if(view.type == LOGOUT){
            img = [self imageRotatedByDegrees:img deg:180];
        }
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
        view.tag = i;
        
        float height_temp =  [self sortViewTo:view];
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,height_temp)];
        [view setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
        [scrollView addSubview:view];
        [mainMenuArray addObject:view];
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
    [self setMenuHidden:0];
    [self setMenuHidden:1];
    [self setMenuHidden:2];
    [self setMenuHidden:3];
    [self setMenuHidden:4];
    [self setMenuHidden:5];
    [self setMenuHidden:6];
    
    UIView *viewstatusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, widthScreen, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [viewstatusBar setBackgroundColor:[UIColor colorWithHexString:SIDE_BAR_COLOR ]];
    [self.view addSubview:viewstatusBar];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *phoneWeb = URL_GET_PHONE_NUMBER;
        NSURL *phoneUrl = [NSURL URLWithString:phoneWeb];
        NSError *error;
        
        NSString *phoneNumber = [NSString stringWithContentsOfURL:phoneUrl
                                                         encoding:NSASCIIStringEncoding
                                                            error:&error];
        
        [[Manager sharedManager] setPhoneNumber:phoneNumber];
        if(phoneNumber.length > 0){
             dispatch_async(dispatch_get_main_queue(), ^{
                // showPhoneNumber.text =  [NSString stringWithFormat:@"%@",[[Manager sharedManager] phoneNumber]];
                 [showPhoneNumber setHidden:YES];
                 [labelLogin setHidden:YES];
                 
                 titleHeader.text = [NSString stringWithFormat: @"สวัสดีค่ะ %@",phoneNumber];
                 
                 [UIView transitionWithView:self.view
                                   duration:0.25
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                    // [logout setFrame:CGRectMake(0, logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
                                     
                                 }
                                 completion:^(BOOL finsihed){
                                     
                                 }];
             });
        }
        
        
    });
    [logout setFrame:CGRectMake(-logout.frame.size.width, logout.frame.origin.y, logout.frame.size.width, logout.frame.size.height)];
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
    }
    
    
    
}
-(float)sortViewTo:(MenuBlockView*)view{
    
    NSArray *temp = subMenuArray[view.tag];
    NSArray *tempIcon = subMenuIconArray[view.tag];
    float space = 40;
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
                switch (view.type) {
                    case NEWS:
                        switch (i) {
                            case 1:
                                imageView.subType = 1;
                                break;
                            case 2:
                                imageView.subType = 2;
                                break;
                            case 3:
                                imageView.subType = 3;
                                break;
                            case 4:
                                imageView.subType = 4;
                                break;
                            case 5:
                                imageView.subType = 5;
                                break;
                            case 6:
                                imageView.subType = 6;
                                break;
                            default:
                                imageView.subType = 1;
                                break;
                        }
                        break;
                    case ENTERTAINMENT:
                        switch (i) {
                            case 1:
                                imageView.subType = 7;
                                break;
                            case 2:
                                imageView.subType = 8;
                                break;
                            case 3:
                                imageView.subType = 9;
                                break;
                            case 4:
                                imageView.subType = 10;
                                break;
                            case 5:
                                imageView.subType = 11;
                                break;
                            case 6:
                                imageView.subType = 12;
                                break;
                            case 7:
                                imageView.subType = 13;
                                break;
                            case 8:
                                imageView.subType = 14;
                                break;
                            case 9:
                                imageView.subType = 15;
                                break;
                            case 10:
                                imageView.subType = 16;
                                break;
                            default:
                                imageView.subType = 7;
                                break;
                        }
                        break;
                    case LIFESTYLE:
                        switch (i) {
                            case 1:
                                imageView.subType = 22;
                                break;
                            case 2:
                                imageView.subType = 23;
                                break;
                            case 3:
                                imageView.subType = 24;
                                break;
                            case 4:
                                imageView.subType = 25;
                                break;
                            case 5:
                                imageView.subType = 26;
                                break;
                                
                            default:
                                imageView.subType = 22;
                                break;
                        }
                        break;
                    case FREEZONE:
                        switch (i) {
                            case 1:
                                imageView.subType = 27;
                                break;
                            case 2:
                                imageView.subType = 28;
                                break;
                            case 3:
                                imageView.subType = 29;
                                break;
                            case 4:
                                imageView.subType = 17;
                                break;
                            case 5:
                                imageView.subType = 999;
                                break;
                            case 6:
                                imageView.subType = 988;
                                break;
                            default:
                                imageView.subType = 27;
                                break;
                        }
                        break;
                    case SPORT:
                        switch (i) {
                            case 1:
                                imageView.subType = 30;
                                break;
                            case 2:
                                imageView.subType = 31;
                                break;
                            case 3:
                                imageView.subType = 32;
                                break;
                                
                            default:
                                imageView.subType = 30;
                                break;
                        }
                        break;
                    default:
                        break;
                }
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
                switch (view.type) {
                    case NEWS:
                        switch (i) {
                            case 1:
                                imageView.subType = 1;
                                break;
                            case 2:
                                imageView.subType = 2;
                                break;
                            case 3:
                                imageView.subType = 3;
                                break;
                            case 4:
                                imageView.subType = 4;
                                break;
                            case 5:
                                imageView.subType = 5;
                                break;
                            case 6:
                                imageView.subType = 6;
                                break;
                            default:
                                imageView.subType = 1;
                                break;
                        }
                        break;
                    case ENTERTAINMENT:
                        switch (i) {
                            case 1:
                                imageView.subType = 7;
                                break;
                            case 2:
                                imageView.subType = 8;
                                break;
                            case 3:
                                imageView.subType = 9;
                                break;
                            case 4:
                                imageView.subType = 10;
                                break;
                            case 5:
                                imageView.subType = 11;
                                break;
                            case 6:
                                imageView.subType = 12;
                                break;
                            case 7:
                                imageView.subType = 13;
                                break;
                            case 8:
                                imageView.subType = 14;
                                break;
                            case 9:
                                imageView.subType = 15;
                                break;
                            case 10:
                                imageView.subType = 16;
                                break;
                            default:
                                imageView.subType = 7;
                                break;
                        }
                        break;
                    case LIFESTYLE:
                        switch (i) {
                            case 1:
                                imageView.subType = 22;
                                break;
                            case 2:
                                imageView.subType = 23;
                                break;
                            case 3:
                                imageView.subType = 24;
                                break;
                            case 4:
                                imageView.subType = 25;
                                break;
                            case 5:
                                imageView.subType = 26;
                                break;
                                
                            default:
                                imageView.subType = 22;
                                break;
                        }
                        break;
                    case FREEZONE:
                        switch (i) {
                            case 1:
                                imageView.subType = 27;
                                break;
                            case 2:
                                imageView.subType = 28;
                                break;
                            case 3:
                                imageView.subType = 29;
                                break;
                                
                            default:
                                imageView.subType = 27;
                                break;
                        }
                        break;
                    case SPORT:
                        switch (i) {
                            case 1:
                                imageView.subType = 30;
                                break;
                            case 2:
                                imageView.subType = 31;
                                break;
                            case 3:
                                imageView.subType = 32;
                                break;
                                
                            default:
                                imageView.subType = 30;
                                break;
                        }
                        break;
                    default:
                        break;
                }
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
        if([[Manager sharedManager] isNormalState]==YES){
        if(view.tag == 2){
            PromotionViewController*   promotionPage= [[PromotionViewController alloc] init];
            navigation.viewControllers = @[promotionPage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
        }
        else if(view.tag == 7){
            ShoppingViewController*   shopping= [[ShoppingViewController alloc] init];
            navigation.viewControllers = @[shopping];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
            
        }
        else if(view.tag == 8){
            NSURL *webURL = [NSURL URLWithString:@"https://www.facebook.com/DtacPlay-1536201406616365/?fref=ts"];
            [[UIApplication sharedApplication] openURL: webURL];
            
        }
        }else{
            if(view.tag == 2){
                PromotionViewController*   promotionPage= [[PromotionViewController alloc] init];
                navigation.viewControllers = @[promotionPage];
                
                
                self.frostedViewController.contentViewController = navigation;
                [self.frostedViewController hideMenuViewController];
            }
            else if(view.tag == 6){
                ShoppingViewController*   shopping= [[ShoppingViewController alloc] init];
                navigation.viewControllers = @[shopping];
                
                
                self.frostedViewController.contentViewController = navigation;
                [self.frostedViewController hideMenuViewController];
                
            }
            else if(view.tag == 7){
                NSURL *webURL = [NSURL URLWithString:@"https://www.facebook.com/DtacPlay-1536201406616365/?fref=ts"];
                [[UIApplication sharedApplication] openURL: webURL];
                
            }
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
    int i = 0,j=0;
    if([[Manager sharedManager] isNormalState]==NO){
        j=1;
    }
    NSArray *menu ;
    switch (image.type) {
        case NEWS:
            menu = subMenuArray[i];
            _newsPage= [[NewsViewController alloc] init];
            
            _newsPage.nameMenu = subMenuTypeArray[0];
            _newsPage.indexPage = (int)image.tag-1;
            _newsPage.pageType = image.type;
            _newsPage.subeType = image.subType;
            navigation.viewControllers = @[_newsPage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
            break;
        case ENTERTAINMENT:
            menu = subMenuArray[i+1];
            self.entPage= [[EntertainmentViewController alloc] init];
            
            self.entPage.nameMenu = subMenuTypeArray[1];
            self.entPage.indexPage = (int)image.tag-1;
            self.entPage.pageType = image.type;
            self.entPage.subeType = image.subType;
            navigation.viewControllers = @[self.entPage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
            break;
        case PROMOTION:
//...
            break;
        case LIFESTYLE:
            menu = subMenuArray[i+3];
            self.lifeStylePage= [[LifeStyleViewController alloc] init];
            
            self.lifeStylePage.nameMenu = subMenuTypeArray[3];
            self.lifeStylePage.indexPage = (int)image.tag-1;
            self.lifeStylePage.pageType = image.type;
            self.lifeStylePage.subeType = image.subType;
            navigation.viewControllers = @[self.lifeStylePage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
            
            break;
        case FREEZONE:
            menu = subMenuArray[i+5-j];
            
            self.freePage= [[FreeZoneViewController alloc] init];
            
            self.freePage.nameMenu = subMenuTypeArray[5-j];
            self.freePage.indexPage = (int)image.tag-1;
            self.freePage.pageType = image.type;
            self.freePage.subeType = image.subType;
            navigation.viewControllers = @[self.freePage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
          
            break;
        case DOWNLOAD:
            menu = subMenuArray[i+4];
            self.downloadPage= [[DownloadViewController alloc] init];
            
            self.downloadPage.nameMenu = subMenuTypeArray[4];
            self.downloadPage.indexPage = (int)image.tag-1;
            self.downloadPage.pageType = image.type;
            self.downloadPage.subeType = image.subType;
            navigation.viewControllers = @[self.downloadPage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
            break;
        case SPORT:
            menu = subMenuArray[i+6-j];
            self.sportPage= [[SportViewController alloc] init];
            
            self.sportPage.nameMenu = subMenuTypeArray[6-j];
            self.sportPage.indexPage = (int)image.tag-1;
            self.sportPage.pageType = image.type;
            self.sportPage.subeType = image.subType;
            navigation.viewControllers = @[self.sportPage];
            
            
            self.frostedViewController.contentViewController = navigation;
            [self.frostedViewController hideMenuViewController];
            break;
        case SHOPPING:
            menu = subMenuArray[7-j];
            //..
            break;
       
        default:
            break;
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
