//
//  ArticleViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "Constant.h"
#import "DtacPlayViewController.h"
#import "ArticleContent.h"
@interface ArticleViewController : DtacPlayViewController<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;
@property(strong, nonatomic) ArticleContent *content;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(nonatomic,assign )NSString *contentID;
@property(nonatomic,assign )NSString *titlePage;
@property(nonatomic,assign)CategorryType pageType;
@property(nonatomic,assign)SubCategorry subCateType;
@property(nonatomic,strong)UIColor *themeColor;
@property(nonatomic,strong) UICollectionView *collectionView;
@end
