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
#import "AppContent.h"
#import "Constant.h"

@interface ApplicationFreeViewController : DtacPlayViewController
@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) AppContent *appObject;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,assign)CategorryType cate;
@property(nonatomic,assign)SubCategorry subcate;

@end
