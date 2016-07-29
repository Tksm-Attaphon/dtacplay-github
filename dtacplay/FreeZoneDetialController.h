//
//  FreeZoneDetialController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DtacPlayViewController.h"
#import "MusicContent.h"
#import "Constant.h"
@interface FreeZoneDetialController : DtacPlayViewController

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)MusicContent *musicObject;
@property(nonatomic,assign)CategorryType cate;
@property(nonatomic,assign)SubCategorry subcate;
@end
