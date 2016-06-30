//
//  ClipCPA.h
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "CPACategory.h"
#import "CPASubCategory.h"
@interface ClipCPA : CPACategory
@property(nonatomic,strong)CPASubCategory *clip_free_cpa;
@property(nonatomic,strong)CPASubCategory *clip_premium_cpa;
@end
