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
#import "ShoppingItem.h"
@interface ShoppingDetailViewController : DtacPlayViewController

@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) iCarousel *shoppingCarousel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (strong, nonatomic) ShoppingItem *shoppingItem;
@end
