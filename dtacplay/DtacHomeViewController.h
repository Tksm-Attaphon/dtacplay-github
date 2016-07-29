//
//  DtacHomeViewController.h
//  dtacplay
//
//  Created by attaphon on 11/21/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"
@interface DtacHomeViewController : DtacPlayViewController
@property(nonatomic,strong)UICollectionView *collectionView;

typedef NS_ENUM(NSInteger, MENU_HOME) {
    HOME_NEWS = 0,
    HOME_ENTERTAINMENT,
    HOME_PRIVILAGE ,
    HOME_PROMOTION ,
    HOME_LIFESTYLE ,
    HOME_DOWNLOAD ,
    HOME_FREEZONE ,
    HOME_SPORT ,
    HOME_REGISTERFREEZONE ,
    HOME_SHOPPING ,
};


@end
