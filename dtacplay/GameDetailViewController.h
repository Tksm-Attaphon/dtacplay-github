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
#import "GameContent.h"
#import "Constant.h"
@interface GameDetailViewController : DtacPlayViewController

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)GameContent *gameObject;

@property(nonatomic,assign)CategorryType cate;
@property(nonatomic,assign)SubCategorry subcate;
@end
