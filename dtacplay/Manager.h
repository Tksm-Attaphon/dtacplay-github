//
//  Manager.h
//  dtacplay
//
//  Created by attaphon eamsahard on 9/23/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DtacCategory.h"
#import "DtacSubCategory.h"
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

@interface Manager : NSObject

+ (id)sharedManager ;
+(CGRect)currentScreenBoundsDependOnOrientation;
+ (CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width font:(NSString *)fontName fontSize:(float)fontSize ;
+ (NSMutableURLRequest *)createRequestHTTP:(NSString *)jsonString cookieValue:(NSString *)cookie ;
+(NSString*)readableHTMLEntity:(NSString*)string;
-(void)showErrorAlert:(id)view title:(NSString*)title message:(NSString*)message;
+(void)serverDown;
-(void)showServerError:(id)view;
+(NSString*)returnSupporter:(int)feeID :(NSString*)detail :(NSString*)link;
+(NSString*)getSubcateName:(int)subcate withThai:(BOOL)thai;
+(NSString*)getCateName:(int)cate withThai:(BOOL)thai;
+(NSString*)getColorName:(CategorryType)cate;
+(void)savePageView:(CategorryType)cate orSubCate:(SubCategorry)subcate;
+(void)savePageViewCPA:(int)cateID;
+(NSString*)returnStringForGoogleTag:(CategorryType)cate withSubCate:(SubCategorry)subCat :(NSString*)title;
+(NSString*)dateTimeToReadableString:(NSDate*)date;
+ (NSMutableURLRequest *)TestcreateRequestHTTP:(NSString *)jsonString cookieValue:(NSString *)cookie ;

@property(nonatomic,strong)NSString *userPhoneNumber;
@property(nonatomic,assign)BOOL userLive;

@property(nonatomic,strong)NSString *accessID;
@property(nonatomic,strong)NSString *userID;

@property(nonatomic,assign)DTACPLAY_Language language;// thai = 1
@property(nonatomic,assign)DeviceType deviceType;
@property(nonatomic,strong)NSString *server;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,assign)float bannerHeight;

 @property(nonatomic,strong)NSMutableArray* menu_HOME;
@property(nonatomic,strong)NSMutableArray *freezoneMenu;


@property(nonatomic,strong)NSMutableArray *bannerArray;

@property(nonatomic,strong)NSMutableArray *bannerArrayNews;
@property(nonatomic,strong)NSMutableArray *bannerArrayEntertainment;
@property(nonatomic,strong)NSMutableArray *bannerArrayPromotion;
@property(nonatomic,strong)NSMutableArray *bannerArrayLifeStyle;
@property(nonatomic,strong)NSMutableArray *bannerArrayDownload;
@property(nonatomic,strong)NSMutableArray *bannerArrayFreezone;
@property(nonatomic,strong)NSMutableArray *bannerArraySport;
@property(nonatomic,strong)NSMutableArray *bannerArrayShopping;
@property(nonatomic,strong)NSMutableArray *bannerArrayPrivilageGame;

@property(nonatomic,assign)BOOL isNormalState;
@property(nonatomic,assign)BOOL isRecAppAvaliable;
@property(nonatomic,assign)BOOL isFreeMusicAvaliable;
@property(nonatomic,assign)BOOL isServerDown;
@property(nonatomic,assign)BOOL isFirstTimeAccessID;

@property(nonatomic,assign)int smrtAdsRefIdNews;
@property(nonatomic,assign)int smrtAdsRefIdEntertainment;
@property(nonatomic,assign)int smrtAdsRefIdPrivilageGame;
@property(nonatomic,assign)int smrtAdsRefIdPromotion;
@property(nonatomic,assign)int smrtAdsRefIdLifestyle;
@property(nonatomic,assign)int smrtAdsRefIdDownload;
@property(nonatomic,assign)int smrtAdsRefIdFreezone;
@property(nonatomic,assign)int smrtAdsRefIdSport;
@property(nonatomic,assign)int smrtAdsRefIdShopping;

@property(nonatomic,strong)NewsCategory *newsCategory;
@property(nonatomic,strong)EntertainmentCategory *entertainmentCategory;
@property(nonatomic,strong)DtacCategory *promotionCategory;
@property(nonatomic,strong)DtacCategory *privilageGameCategory;
@property(nonatomic,strong)LifestyleCategory *lifestyleCategory;
@property(nonatomic,strong)DownloadCategory *downloadCategory;
@property(nonatomic,strong)FreezoneCategory *freezoneCategory;
@property(nonatomic,strong)SportCategory *sportCategory;
@property(nonatomic,strong)DtacCategory *shoppingCategory;

@property(nonatomic,strong)NewsCPA *newsCPA;
@property(nonatomic,strong)HoroCPA *horoCPA;
@property(nonatomic,strong)LuckyNumberCPA *numberCPA;
@property(nonatomic,strong)LifeStyleCPA *lifeCPA;
@property(nonatomic,strong)SportCPA *sportCPA;
@property(nonatomic,strong)ClipCPA *clipCPA;

@end
