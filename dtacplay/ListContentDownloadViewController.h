//
//  FreeZoneDetialController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"
#import "Constant.h"
@interface ListContentDownloadViewController : DtacPlayViewController

@property(nonatomic,strong)UICollectionView *collectionView;

@property (assign, nonatomic) CategorryType cate;
@property (assign, nonatomic) SubCategorry subCate;
@property (assign, nonatomic) BOOL isCPA;
@end
