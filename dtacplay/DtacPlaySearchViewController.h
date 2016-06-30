//
//  DtacPlaySearchViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 12/2/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DtacPlayViewController.h"
@interface DtacPlaySearchViewController : UIViewController
@property(nonatomic,strong)UITableView *searchTable;
@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSString *descriptionWord;
@property (assign, nonatomic) BOOL isShowMoreButton;
@property (assign, nonatomic) BOOL isTagSearch;
@property (assign, nonatomic) int cateID;
@end
