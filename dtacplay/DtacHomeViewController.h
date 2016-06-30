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

@property (strong, nonatomic) iCarousel *carousel;
@property(nonatomic,strong)UICollectionView *collectionView;
@end
