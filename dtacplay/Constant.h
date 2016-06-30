//
//  Constant.h
//  dtacplay
//
//  Created by attaphon eamsahard on 9/23/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

typedef NS_ENUM(NSInteger, DeviceType) {
    DESKTOP = 1,
    MOBILE_WEBSITE = 2,
    TABLET_WEBSITE = 3,
    FEATURE_PHONE = 4,
    IPHONE = 5,
    ANDROID = 6,
    IPAD = 7,
    ANDROID_TABLET = 8
};
typedef NS_ENUM(NSInteger, CategorryType) {
    NEWS = 1,
    ENTERTAINMENT = 2,
    PROMOTION =7,
    LIFESTYLE = 3,
    FREEZONE = 4,
    SPORT = 5,
    SHOPPING = 6,
    DOWNLOAD = 8,
    LOGOUT = 69
};
typedef NS_ENUM(NSInteger, SubCategorry) {
    NEWS_WIKI = 40,
    NEWS_HOT_NEWS = 1,
    NEWS_INTER_NEWS = 2 ,
    NEWS_FINANCE = 3,
    NEWS_TECHNOLOGY = 4,
    NEWS_GAS_PRICE = 5,
    NEWS_GOLD_PRICE = 6,
    NEWS_LOTTO = 33,
    NEWS_LOTTERRY = 60,
    
ENTERTAINMENT_VARIETY = 100,
    ENTERTAINMENT_MOVIE_NEWS = 9,
    ENTERTAINMENT_MOVIE_TRAILER = 10,
    ENTERTAINMENT_NEWS = 7,
    ENTERTAINMENT_TV = 8,
    ENTERTAINMENT_VIDEO = 18,
    ENTERTAINMENT_MOVIE = 101,
    ENTERTAINMENT_TICKET_BOOKING =10,
    ENTERTAINMENT_MUSIC = 11,
    ENTERTAINMENT_SUGGESTION = 12,
    ENTERTAINMENT_THEME = 15,
    ENTERTAINMENT_WALLPAPER = 16,
    
    LIFESTYLE_TRAVEL = 22,
    LIFESTYLE_RESTAURANT = 23,
    LIFESTYLE_ACCOMMODATION = 24,
    LIFESTYLE_HEALTH = 25,
    LIFESTYLE_HOROSCOPE = 26,
    
    FREEZONE_MUSIC = 27,
    FREEZONE_GAME = 28,
    FREEZONE_RECOMMENDED_APPLICATION = 17,
    FREEZONE_APPLICATION = 29,
    FREEZONE_REGISTER = 999,
    FREEZONE_FREESMS = 988,
    
    SPORT_NEWS = 30,
    SPORT_INTER_FOOTBALL = 31,
    SPORT_THAI_FOOTBALL = 32,
    
DOWNLOAD_GAME = 111,
DOWNLOAD_MUSIC = 112,
DOWNLOAD_CPA_NEWS = 113,
DOWNLOAD_CPA_HORO = 114,
DOWNLOAD_CPA_LUCKY_NUMBER = 115,
DOWNLOAD_CPA_LIFESTYLE = 116,
DOWNLOAD_CPA_SPORT = 117,
DOWNLOAD_CPA_CLIP_FREE = 118,
    
    DOWNLOAD_MUSIC_NEW= 13,
    DOWNLOAD_MUSIC_HIT = 14,
    DOWNLOAD_MUSIC_INTER = 15,
    DOWNLOAD_MUSIC_LOOKTHOONG= 16,
    DOWNLOAD_GAME_NEW= 12,
    DOWNLOAD_GAME_HIT = 19,
    DOWNLOAD_GAME_GAMECLUB = 38,
    DOWNLOAD_GAME_GAMEROOM = 39,
    
    DOWNLOAD_CPA_NEWS_HIT = 500,
    DOWNLOAD_CPA_NEWS_GOSSIP = 501,
    DOWNLOAD_CPA_NEWS_ECO = 502,
    
    DOWNLOAD_CPA_LIFESTYLE_QUIZE = 503,
    DOWNLOAD_CPA_LIFESTYLE_MOVIE = 504,
    DOWNLOAD_CPA_LIFESTYLE_BEUTY = 505,
    
    DOWNLOAD_CPA_SPORT_FOOTBALL = 506,
    DOWNLOAD_CPA_SPORT_OTHER = 507,
    
    DOWNLOAD_CPA_CLIP_FREE_INTERNET = 508,
    DOWNLOAD_CPA_CLIP_FREE_PREMIUM = 509,
};
typedef NS_ENUM(NSInteger, DTACPLAY_Language) {
    THAI = 1,
    ENGLISH = 2,

};
// production
//*
#define SERVICE @"https://dtplay-api.thinksmart.co.th/site-api/service"
#define SERVICE_2 @"https://dtplay-api.thinksmart.co.th/site-api/service"
#define DOMAIN_WEBSITE @"http://dtacplay.dtac.co.th/th/"
#define URL_GET_PHONE_NUMBER @"http://dtacplay.dtac.co.th/th/msisdn/info"
//*/

// UAT
/*
#define SERVICE @"http://dtplay-api.dev5.thinksmart.co.th/site-api/service"
#define SERVICE_2 @"http://dtplay-api.dev5.thinksmart.co.th/site-api/service"

#define DOMAIN_WEBSITE @"http://dtacplay-web.dev5.thinksmart.co.th/th/"
#define URL_GET_PHONE_NUMBER @"http://dtplay-web.thinksmart.co.th/th/msisdn/info"
//*/

//security
#define AUTHORIZATION_VALUE @"Basic ZHRhY3BsYXlfYXBpOiA2RjVScGIyU2U2Y3hQ"

//IDIOM
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

//Font
#define FONT_DTAC_BOLD @"DTAC2013-Bold"
#define FONT_DTAC_LIGHT @"DTAC2013-Light"
#define FONT_DTAC_REGULAR @"DTAC2013-Regular"

//Color
#define BLOCK_COLOR @"f5f5f5"
#define DEFAULT_TEXT_COLOR @"424242"
#define SIDE_BAR_COLOR @"00ace7"
#define COLOR_NEWS @"00ace7"
#define COLOR_ENTERTAINMENT @"540b8f"
#define COLOR_PROMOTION @"1a237e"
#define COLOR_SPORT @"66bb6a"
#define COLOR_LIFESTYLE @"9f064f"//#fa1461
#define COLOR_FREEZONE @"fa1461"
#define COLOR_SHOPPING @"f57e16"
#define COLOR_DOWNLOAD @"f70000"

#define LOGO_NAVIGATIONBAR @"dtacplay_icon_navigationbar"

#define BANNER_HEIGHT_IPHONE @"244"
#define BANNER_HEIGHT_IPAD @"444"
#endif /* Constant_h */
