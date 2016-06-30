//
//  NewsCPA.h
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "CPACategory.h"
#import "CPASubCategory.h"
@interface NewsCPA : CPACategory

@property(nonatomic,strong)CPASubCategory *hot_news_cpa;
@property(nonatomic,strong)CPASubCategory *gossip_news_cpa;
@property(nonatomic,strong)CPASubCategory *eco_news_cpa;

@end
