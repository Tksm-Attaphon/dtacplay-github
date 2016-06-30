//
//  AlbumViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"
#import "Constant.h"
@interface AlbumViewController : DtacPlayViewController<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;
@property(strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *allImageArray;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,assign )NSString *titlePage;
@property(nonatomic,assign )NSString *titleArticle;
@property(strong, nonatomic) UIColor *themeColor;//titleArticle
@property(assign)SubCategorry subcate;
@end
