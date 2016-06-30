//
//  PromotionViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"
#import "REFrostedViewController.h"
@interface PromotionViewController : DtacPlayViewController<iCarouselDataSource,iCarouselDelegate>
@property(nonatomic,strong) UICollectionView *collectionView;
@property (strong, nonatomic) iCarousel *carousel;
@end
