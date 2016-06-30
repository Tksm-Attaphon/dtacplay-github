//
//  ShowImageViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"
#import "Constant.h"
@interface ShowImageViewController : UIViewController<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) NSMutableArray *allImageArray;
@property (assign, nonatomic) int index;
@property(nonatomic,assign )NSString *titlePage;
@property(nonatomic,strong )UIColor *themeColor;
@property(nonatomic,assign)SubCategorry subCate;
@property(nonatomic,assign)CategorryType cate;
@end
