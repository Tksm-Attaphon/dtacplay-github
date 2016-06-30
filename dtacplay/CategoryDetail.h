//
//  CategoryDetail.h
//  dtacplay
//
//  Created by attaphon eamsahard on 1/26/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface CategoryDetail : NSObject
@property(nonatomic,strong)NSString *categoryName;
@property(nonatomic,assign)CategorryType cate;
@property(nonatomic,assign)int cateID;
@end
