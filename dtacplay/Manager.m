//
//  Manager.m
//  dtacplay
//
//  Created by attaphon eamsahard on 9/23/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "Manager.h"
#import "Constant.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
@implementation Manager

static Manager *shareInstance = nil;

+ (id)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
+ (CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width font:(NSString *)fontName fontSize:(float)fontSize {
    CGSize constraintSize;
    constraintSize.height = MAXFLOAT;
    constraintSize.width = width;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:fontName size:fontSize], NSFontAttributeName,
                                          nil];
    
    CGRect frame = [text boundingRectWithSize:constraintSize
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributesDictionary
                                      context:nil];
    
    CGSize stringSize = frame.size;
    return stringSize;
}

+ (NSMutableURLRequest *)createRequestHTTP:(NSString *)jsonString cookieValue:(NSString *)cookie {
    NSMutableURLRequest *requestHTTP = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[Manager sharedManager] server]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [requestHTTP setHTTPMethod:@"POST"];
    
    NSData *plainData = [[NSString stringWithFormat:@"%@:%@", @"dtacplay_api", @"6F5Rpb2Se6cxP"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedUsernameAndPassword = [plainData base64EncodedStringWithOptions:0];
    
    //set auth header
    [requestHTTP addValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [requestHTTP setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //[requestHTTP setValue:AUTHORIZATION_VALUE forHTTPHeaderField:@"Authorization"];
    NSDictionary *cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                      SERVICE, NSHTTPCookieDomain,
                                      @"\\", NSHTTPCookiePath,
                                      @"myCookie", NSHTTPCookieName,
                                      [NSString stringWithFormat:@"%@",[[Manager sharedManager] accessID]], NSHTTPCookieValue,
                                      nil];
    NSHTTPCookie *cookies = [NSHTTPCookie cookieWithProperties:cookieProperties];
    NSArray* cookieArray = [NSArray arrayWithObject:cookies];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    [requestHTTP setAllHTTPHeaderFields:headers];

    [requestHTTP setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", [[Manager sharedManager] accessID]);
    if([[Manager sharedManager] accessID])
        [requestHTTP setValue:[NSString stringWithFormat:@"%@",[[Manager sharedManager] accessID]] forHTTPHeaderField:@"x-tksm-accessId"];
    if([[Manager sharedManager] language])
        [requestHTTP setValue:[NSString stringWithFormat:@"%d",[[Manager sharedManager] language]] forHTTPHeaderField:@"x-tksm-lang"];
    else{
        [requestHTTP setValue:@"1" forHTTPHeaderField:@"x-tksm-lang"];
    }
    if([[Manager sharedManager] deviceType])
        [requestHTTP setValue:[NSString stringWithFormat:@"%d",[[Manager sharedManager] deviceType] ] forHTTPHeaderField:@"x-tksm-device"];
    
    
    NSLog(@"%@", [requestHTTP allHTTPHeaderFields]);
    return requestHTTP;
}

+ (NSMutableURLRequest *)TestcreateRequestHTTP:(NSString *)jsonString cookieValue:(NSString *)cookie {
    NSMutableURLRequest *requestHTTP = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dtplay-api.dev5.thinksmart.co.th/cookie.php"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [requestHTTP setHTTPMethod:@"POST"];
    [requestHTTP setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                      SERVICE, NSHTTPCookieDomain,
                                      @"\\", NSHTTPCookiePath,
                                      @"myCookie", NSHTTPCookieName,
                                      [NSString stringWithFormat:@"%@",[[Manager sharedManager] accessID]], NSHTTPCookieValue,
                                      nil];
    NSHTTPCookie *cookies = [NSHTTPCookie cookieWithProperties:cookieProperties];
    NSArray* cookieArray = [NSArray arrayWithObject:cookies];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    
 
    [requestHTTP setAllHTTPHeaderFields:headers];  
    NSLog(@"%@", [requestHTTP allHTTPHeaderFields]);
    // {
    //    "Accept-Language" = "en;q=1";
    //    "Content-Length" = 190706;
    //    "Content-Type" = "multipart/form-data; boundary=Boundary+D90A259975186725";
    //    "User-Agent" = "...";
    // }
    return requestHTTP;
}

+(NSString*)dateTimeToReadableString:(NSString*)date{
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    
    NSArray *ary = [date componentsSeparatedByString:@" "];
    NSArray *hour = [ary[1] componentsSeparatedByString:@":"];
    
    dateFromString = [dateFormatter dateFromString:date];
   
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateFromString];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    

    
    NSString *textMouth;
    switch (month) {
        case 1:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"January" :*/@"ม.ค.";
            break;
        case 2:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"February" :*/@"ก.พ.";
            break;
        case 3:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"March" :*/@"มี.ค.";
            break;
        case 4:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"April" :*/@"เม.ย.";
            break;
        case 5:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"May" :*/@"พ.ค.";
            break;
        case 6:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"June" :*/@"มิ.ย.";
            break;
        case 7:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"July" :*/@"ก.ค.";
            break;
        case 8:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"August" :*/@"ส.ค.";
            break;
        case 9:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"September":*/@"ก.ย.";
            break;
        case 10:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"October" :*/@"ต.ค.";
            break;
        case 11:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"November":*/@"พ.ย.";
            break;
        case 12:
            textMouth = /*[[CasetitudeManager sharedManager]language]!= thai  ? @"December" :*/@"ธ.ค.";
            break;
        default:
            break;
    }
    
    
    return [NSString stringWithFormat:@"%ld %@ %ld %@:%@ น.",(long)day,textMouth,(long)(year+543)-2500,hour[0],hour[1]];

}


+(void)serverDown{
    if([[[Manager sharedManager] server] isEqualToString:SERVICE_2])
        [[Manager sharedManager] setServer:SERVICE];
    else
        [[Manager sharedManager] setServer:SERVICE_2];
    
}
+(NSString*)returnSupporter:(int)feeID :(NSString*)detail :(NSString*)link{
 
   return [NSString stringWithFormat: @"<p align=right><a style=\"color:%@; text-decoration: none;\" href=\"%@\">%@</a></p>",DEFAULT_TEXT_COLOR,link,detail];

}
+(NSString*)returnStringForGoogleTag:(CategorryType)cate withSubCate:(SubCategorry)subCat :(NSString*)title{
    
    NSString *stringCatName = [Manager getCateName:cate withThai:NO];
    NSString *stringSubCatName = subCat != 0 ?[ NSString stringWithFormat:@" - %@", [Manager getSubcateName:subCat withThai:NO] ] : @"" ;
    NSString *stringTitleName = title != nil ?[ NSString stringWithFormat:@" - %@", title] : @"";
    
    return [NSString stringWithFormat:@"%@%@%@",stringCatName,stringSubCatName,stringTitleName];

    
}
+(NSString*)getSubcateName:(int)subcate withThai:(BOOL)thai{
    switch (subcate) {
        case NEWS_WIKI:
            return thai ? [[[Manager sharedManager] newsCategory]wikipedia_news].name : [[[Manager sharedManager] newsCategory]wikipedia_news].engName;
            break;
        case NEWS_HOT_NEWS:
            return thai ? [[[Manager sharedManager] newsCategory]hot_news].name : [[[Manager sharedManager] newsCategory]hot_news].engName;
            break;
        case NEWS_INTER_NEWS:
            return thai ?  [[[Manager sharedManager] newsCategory]inter_news].name : [[[Manager sharedManager] newsCategory]inter_news].engName;
            break;
        case NEWS_FINANCE:
            return thai ?  [[[Manager sharedManager] newsCategory]finance_news].name :[[[Manager sharedManager] newsCategory]finance_news].engName;
            break;
        case NEWS_TECHNOLOGY:
            return thai ?  [[[Manager sharedManager] newsCategory]it_news].name : [[[Manager sharedManager] newsCategory]it_news].engName;
            break;
        case NEWS_LOTTO:
            return thai ?  [[[Manager sharedManager] newsCategory]luckynumber_news].name :[[[Manager sharedManager] newsCategory]luckynumber_news].engName;
            break;
        case NEWS_LOTTERRY:
            return thai ?  @"ผลสลาก" : @"Lottery";
            break;
        case NEWS_GAS_PRICE:
            return thai ?  @"ราคาน้ำมัน" : @"Oil Price" ;
            break;
        case NEWS_GOLD_PRICE:
            return thai ?  @"ราคาทอง" : @"Gold Price" ;
            break;
            
        case ENTERTAINMENT_MUSIC:
            return thai ?  @"ข่าวเพลง" : @"Music News";
            break;
        case ENTERTAINMENT_VARIETY:
            return thai ?  @"วาไรตี้บันเทิง" : @"Variety";
            break;
        case ENTERTAINMENT_TV:
            return thai ?  @"ทีวี" : @"TV" ;
            break;
 
        case ENTERTAINMENT_NEWS:
            return thai ?  [[[Manager sharedManager] entertainmentCategory]news].name :[[[Manager sharedManager] entertainmentCategory]news].engName;
            break;
        case ENTERTAINMENT_VIDEO:
            return thai ?  [[[Manager sharedManager] entertainmentCategory]video].name : [[[Manager sharedManager] entertainmentCategory]video].engName ;
            break;
        case ENTERTAINMENT_MOVIE_TRAILER:
            return thai ?  @"ตัวอย่างหนัง" :@"Movie Trailer";
            break;
        case ENTERTAINMENT_MOVIE_NEWS:
            return thai ?  @"ข่าวหนัง" : @"Movie News" ;
            break;
        case ENTERTAINMENT_MOVIE:
            return thai ?  @"หนัง" : @"Movie";
            break;
            
        case LIFESTYLE_TRAVEL:
            return thai ? [[[Manager sharedManager] lifestyleCategory]travel].name : [[[Manager sharedManager] lifestyleCategory]travel].engName ;
            break;
        case LIFESTYLE_RESTAURANT:
            return thai ?  [[[Manager sharedManager] lifestyleCategory]resteraunt].name :[[[Manager sharedManager] lifestyleCategory]resteraunt].engName;
            break;
        case LIFESTYLE_HOROSCOPE:
            return thai ?  [[[Manager sharedManager] lifestyleCategory]horo].name : [[[Manager sharedManager] lifestyleCategory]horo].engName ;
            break;
            
        case FREEZONE_MUSIC:
            return thai ?  [[[Manager sharedManager] freezoneCategory]freemusic].name : [[[Manager sharedManager] freezoneCategory]freemusic].engName;
            break;
        case FREEZONE_GAME:
            return thai ?  [[[Manager sharedManager] freezoneCategory]gamefree].name  :[[[Manager sharedManager] freezoneCategory]gamefree].engName  ;
            break;
        case FREEZONE_APPLICATION:
            return thai ?  [[[Manager sharedManager] freezoneCategory]dtacapp].name  : [[[Manager sharedManager] freezoneCategory]dtacapp].engName;
            break;
        case FREEZONE_RECOMMENDED_APPLICATION:
            return thai ?  [[[Manager sharedManager] freezoneCategory]suggesapp].name  : [[[Manager sharedManager] freezoneCategory]suggesapp].engName ;
            break;
        case FREEZONE_REGISTER:
            return thai ?  @"สมัครฟรีโซน" :@"Register Freezone";
            break;
        case FREEZONE_FREESMS:
            return thai ?  @"ส่งฟรี SMS" :@"Free SMS";
            break;
            
            
        case DOWNLOAD_GAME:
            return thai ?  @"เกม" :@"Game";
            break;
        case DOWNLOAD_GAME_NEW:
            return thai ?  [[[Manager sharedManager] downloadCategory]game_new].name  :[[[Manager sharedManager] downloadCategory]game_new].engName;
            break;
        case DOWNLOAD_GAME_HIT:
            return thai ?  [[[Manager sharedManager] downloadCategory]game_hit].name  : [[[Manager sharedManager] downloadCategory]game_hit].engName;
            break;
        case DOWNLOAD_GAME_GAMEROOM:
            return thai ?  [[[Manager sharedManager] downloadCategory]game_room].name  :[[[Manager sharedManager] downloadCategory]game_room].engName;
            break;
        case DOWNLOAD_GAME_GAMECLUB:
            return thai ?  [[[Manager sharedManager] downloadCategory]game_new].name  :[[[Manager sharedManager] downloadCategory]game_new].engName;
            break;
            
        case DOWNLOAD_MUSIC:
            return thai ?  @"เพลง" :@"Music";
            break;
        case DOWNLOAD_MUSIC_NEW:
            return thai ?  [[[Manager sharedManager] downloadCategory]music_new].name  :[[[Manager sharedManager] downloadCategory]music_new].engName ;
            break;
        case DOWNLOAD_MUSIC_HIT:
            return thai ?   [[[Manager sharedManager] downloadCategory]music_hit].name:[[[Manager sharedManager] downloadCategory]music_hit].engName;
            break;
        case DOWNLOAD_MUSIC_LOOKTHOONG:
            return thai ?   [[[Manager sharedManager] downloadCategory]music_lookthoong].name : [[[Manager sharedManager] downloadCategory]music_lookthoong].engName ;
            break;
        case DOWNLOAD_MUSIC_INTER:
            return thai ?   [[[Manager sharedManager] downloadCategory]music_inter].name : [[[Manager sharedManager] downloadCategory]music_inter].engName;
            break;
            
        case DOWNLOAD_CPA_NEWS:
            return thai ? [[Manager sharedManager] newsCPA].name :[[Manager sharedManager] newsCPA].engName;
            break;
        case DOWNLOAD_CPA_NEWS_HIT:
            return thai ?  [[[Manager sharedManager] newsCPA]hot_news_cpa].name :[[[Manager sharedManager] newsCPA]hot_news_cpa].engName;
            break;
        case DOWNLOAD_CPA_NEWS_GOSSIP:
            return thai ?   [[[Manager sharedManager] newsCPA]gossip_news_cpa].name  :[[[Manager sharedManager] newsCPA]gossip_news_cpa].engName;
            break;
        case DOWNLOAD_CPA_NEWS_ECO:
            return thai ?   [[[Manager sharedManager] newsCPA]eco_news_cpa].name  :[[[Manager sharedManager] newsCPA]eco_news_cpa].engName;
            break;
        case DOWNLOAD_CPA_HORO:
            return thai ?   [[Manager sharedManager] horoCPA].name  : [[Manager sharedManager] horoCPA].engName;
            break;
        case DOWNLOAD_CPA_LUCKY_NUMBER:
            return thai ?   [[Manager sharedManager] numberCPA].name :[[Manager sharedManager] numberCPA].engName;
            break;
        case DOWNLOAD_CPA_LIFESTYLE:
            return thai ?  [[Manager sharedManager] lifeCPA].name  :[[Manager sharedManager] lifeCPA].engName;
            break;
        case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
            return thai ?   [[[Manager sharedManager] lifeCPA]quize_cpa].name  :[[[Manager sharedManager] lifeCPA]quize_cpa].engName ;
            break;
        case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
            return thai ?   [[[Manager sharedManager] lifeCPA]movie_cpa].name  :[[[Manager sharedManager] lifeCPA]movie_cpa].engName;
            break;
        case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
            return thai ?   [[[Manager sharedManager] lifeCPA]buety_cpa].name  :[[[Manager sharedManager] lifeCPA]buety_cpa].engName;
            break;
            
            
        case DOWNLOAD_CPA_SPORT:
            return thai ?   [[Manager sharedManager] sportCPA].name  :[[Manager sharedManager] sportCPA].engName ;
            break;
        case DOWNLOAD_CPA_SPORT_FOOTBALL:
            return thai ?  [[[Manager sharedManager] sportCPA]football_sport_cpa].name :[[[Manager sharedManager] sportCPA]football_sport_cpa].engName;
            break;
        case DOWNLOAD_CPA_SPORT_OTHER:
            return thai ?   [[[Manager sharedManager] sportCPA]other_sport_cpa].name :[[[Manager sharedManager] sportCPA]other_sport_cpa].engName;
            break;
            
            
        case DOWNLOAD_CPA_CLIP_FREE:
            return thai ?  [[Manager sharedManager] clipCPA].name  : [[Manager sharedManager] clipCPA].engName ;
            break;
        case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
            return thai ?   [[[Manager sharedManager] clipCPA]clip_free_cpa].name  :[[[Manager sharedManager] clipCPA]clip_free_cpa].engName;
            break;
        case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
            return thai ?   [[[Manager sharedManager] clipCPA]clip_premium_cpa].name :[[[Manager sharedManager] clipCPA]clip_premium_cpa].engName ;
            break;
            
            
        case SPORT_NEWS:
            return thai ?  [[[Manager sharedManager] sportCategory]world].name :[[[Manager sharedManager] sportCategory]world].engName;
            break;
        case SPORT_INTER_FOOTBALL:
            return thai ?  [[[Manager sharedManager] sportCategory]football].name :[[[Manager sharedManager] sportCategory]football].engName;
            break;
        case SPORT_THAI_FOOTBALL:
            return thai ?  [[[Manager sharedManager] sportCategory]thai_football].name :[[[Manager sharedManager] sportCategory]thai_football].engName ;
            break;
        default:
            return thai ?  @"เมนู" : @"Menu";
            break;
    }
}
+(NSString*)getCateName:(int)cate withThai:(BOOL)thai {
    switch (cate) {
        case NEWS:
            return thai ?  [[Manager sharedManager] newsCategory].name :[[Manager sharedManager] newsCategory].engName;
            break;
        case ENTERTAINMENT:
            return thai ? [[Manager sharedManager] entertainmentCategory].name : [[Manager sharedManager] entertainmentCategory].engName;
            break;
        case LIFESTYLE:
            return thai ?  [[Manager sharedManager] lifestyleCategory].name : [[Manager sharedManager] lifestyleCategory].engName;
            break;
        case SHOPPING:
            return thai ?  [[Manager sharedManager] shoppingCategory].name :[[Manager sharedManager] shoppingCategory].engName;
            break;
        case PROMOTION:
            return thai ?  [[Manager sharedManager] promotionCategory].name:  [[Manager sharedManager] promotionCategory].engName;
            break;
        case FREEZONE:
            return thai ?  [[Manager sharedManager] freezoneCategory].name :[[Manager sharedManager] freezoneCategory].engName;
            break;
        case DOWNLOAD:
            return thai ?  [[Manager sharedManager] downloadCategory].name :[[Manager sharedManager] downloadCategory].engName;
            break;
        case SPORT:
            return thai ?  [[Manager sharedManager] sportCategory].name:[[Manager sharedManager] sportCategory].engName;
            break;
        default:
            return thai ?  @"เมนู" : @"Menu";
            break;
    }
}
+(NSString*)getColorName:(CategorryType)cate{
    switch (cate) {
        case NEWS:
            return COLOR_NEWS;
            break;
        case ENTERTAINMENT:
            return COLOR_ENTERTAINMENT;
            break;
        case LIFESTYLE:
            return COLOR_LIFESTYLE;
            break;
        case SHOPPING:
            return COLOR_SHOPPING;
            break;
        case PROMOTION:
            return COLOR_PROMOTION;
            break;
        case FREEZONE:
            return COLOR_FREEZONE;
            break;
        case DOWNLOAD:
            return COLOR_DOWNLOAD;
            break;
        default:
            return SIDE_BAR_COLOR;
            break;
    }
}
+(void)savePageView:(CategorryType)cate orSubCate:(SubCategorry)subcate{
    int page = 0;
    if(cate >0){
        switch (cate) {
            case NEWS:
                page = 1;
                break;
            case ENTERTAINMENT:
                page = 2;
                break;
            case PROMOTION:
                page = 7;
                break;
            case LIFESTYLE:
                page = 3;
                break;
            case FREEZONE:
                page = 4;
                break;
            case SPORT:
                page = 5;
                break;
            case SHOPPING:
                page = 6;
                break;
            case DOWNLOAD:
                page = 8;
                break;

            default:
                break;
        }
    }
    else{
        switch (subcate) {
            case NEWS_WIKI:
                page = 19;
                break;
            case NEWS_HOT_NEWS:
                page = 11;
                break;
            case NEWS_INTER_NEWS:
                page = 12;
                break;
            case NEWS_FINANCE:
                page = 13;
                break;
            case NEWS_TECHNOLOGY:
                page = 14;
                break;
            case NEWS_GAS_PRICE:
                page = 17;
                break;
            case NEWS_GOLD_PRICE:
                page = 18;
                break;
                
            case NEWS_LOTTO:
                page = 15;
                break;
            case NEWS_LOTTERRY:
                page = 16;
                break;
                
            case ENTERTAINMENT_NEWS:
                page = 211;
                break;
            case ENTERTAINMENT_VIDEO:
                page = 213;
                break;
            case ENTERTAINMENT_MOVIE:
                page = 22;
                break;
                
            case LIFESTYLE_TRAVEL:
                page = 31;
                break;
            case LIFESTYLE_RESTAURANT:
                page = 32;
                break;
            case LIFESTYLE_HOROSCOPE:
                page = 35;
                break;
            case LIFESTYLE_ACCOMMODATION:
                page = 33;
                break;
            case LIFESTYLE_HEALTH:
                page = 34;
                break;
                
            case FREEZONE_MUSIC:
                page = 41;
                break;
            case FREEZONE_GAME:
                page = 42;
                break;
            case FREEZONE_RECOMMENDED_APPLICATION:
                page = 44;
                break;
            case FREEZONE_APPLICATION:
                page = 43;
                break;
            case FREEZONE_REGISTER:
                page = 45;
                break;
            case FREEZONE_FREESMS:
                page = 46;
                break;
            case SPORT_NEWS:
                page = 51;
                break;
            case SPORT_INTER_FOOTBALL:
                page = 52;
                break;
            case SPORT_THAI_FOOTBALL:
                page = 53;
                break;
                
//            case DOWNLOAD_CPA_NEWS:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_HORO:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_LUCKY_NUMBER:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_LIFESTYLE:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_SPORT:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_CLIP_FREE:
//                page = 0;
//                break;
            case DOWNLOAD_MUSIC_NEW:
                page = 811;
                break;
            case DOWNLOAD_MUSIC_HIT:
                page = 812;
                break;
            case DOWNLOAD_MUSIC_INTER:
                page = 813;
                break;
            case DOWNLOAD_MUSIC_LOOKTHOONG:
                page = 814;
                break;
            case DOWNLOAD_GAME_NEW:
                page = 821;
                break;
            case DOWNLOAD_GAME_HIT:
                page = 822;
                break;
            case DOWNLOAD_GAME_GAMECLUB:
                page = 823;
                break;
            case DOWNLOAD_GAME_GAMEROOM:
                page = 824;
                break;
//            case DOWNLOAD_CPA_NEWS_HIT:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_NEWS_GOSSIP:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_NEWS_ECO:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_LIFESTYLE_QUIZE:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_LIFESTYLE_MOVIE:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_LIFESTYLE_BEUTY:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_SPORT_OTHER:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_CLIP_FREE_INTERNET:
//                page = 0;
//                break;
//            case DOWNLOAD_CPA_CLIP_FREE_PREMIUM:
//                page = 0;
//                break;
//                
//                
            default:
                break;
        }
    }
    NSLog(@"save page : %d",page);
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"savePageView\", \"params\":{\"pageId\":%d}}",page];

    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:[NSString stringWithFormat:@"%@",[[Manager sharedManager] accessID]] ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject objectForKey:@"result"]) {
            NSLog(@"complete save page: %d",page) ;
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //[[Manager sharedManager] showErrorAlert:self];
    }];
    [op start];

}
+(void)savePageViewCPA:(int)cateID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"saveCpaContentReg\", \"params\":{\"cpaConId\":%d}}",cateID];
    
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:[NSString stringWithFormat:@"%@",[[Manager sharedManager] accessID]] ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject objectForKey:@"result"]) {
            NSLog(@"complete save page: %d",cateID) ;
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //[[Manager sharedManager] showErrorAlert:self];
    }];
    [op start];
    
}
-(void)showErrorAlert:(id)view title:(NSString*)title message:(NSString*)message{
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
        [view presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"กรุณาเชื่อมต่ออินเทอร์เน็ทเพื่อเริ่มใช้งานค่ะ" message:@"" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }

}
-(void)showServerError:(id)view{
    if ([UIAlertController class])
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"ขออภัย ไม่สามารถใช้งานได้ในขณะนี้"
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
                                      
                                   }];
        
       // [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [view presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ขออภัย ไม่สามารถใช้งานได้ในขณะนี้" message:@"" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}
#define IsIOS8 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
+(CGRect)currentScreenBoundsDependOnOrientation
{
    
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    if(IsIOS8){
        return screenBounds ;
    }
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
    }else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(height, width);
    }
    return screenBounds ;
}
+(NSString*)readableHTMLEntity:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    string = [string stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    string = [string stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"‘"];
    string = [string stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"’"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];
    string = [string stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
    return string;
}
@end
