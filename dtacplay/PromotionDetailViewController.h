//
//  PromotionDetailViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/8/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"
#import "ArticleContent.h"
@interface PromotionDetailViewController : DtacPlayViewController<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;
@property(strong, nonatomic) ArticleContent *content;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(assign,nonatomic) NSString* contentID;
@property(nonatomic,strong) UICollectionView *collectionView;
@end
