//
//  SideBarViewController.h
//  googlenewstand
//
//  Created by attaphon eamsahard on 9/21/2558 BE.
//  Copyright (c) 2558 attaphon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LifeStyleViewController;
@class NewsViewController;
@class EntertainmentViewController;
@class FreeZoneViewController;
@class DownloadViewController;
@class SportViewController;
@interface SideBarViewController : UIViewController

@property(nonatomic,strong)LifeStyleViewController* lifeStylePage;
@property(nonatomic,strong)NewsViewController* newsPage;
@property(nonatomic,strong)EntertainmentViewController* entPage;

@property(nonatomic,strong)FreeZoneViewController* freePage;
@property(nonatomic,strong)SportViewController* sportPage;
@property(nonatomic,strong)DownloadViewController* downloadPage;
-(void)setTheme:(UIColor*)color;
@end
