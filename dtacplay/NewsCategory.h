//
//  NewsCategory.h
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "DtacCategory.h"

@interface NewsCategory : DtacCategory

@property(nonatomic,strong)DtacSubCategory *hot_news;
@property(nonatomic,strong)DtacSubCategory *inter_news;
@property(nonatomic,strong)DtacSubCategory *wikipedia_news;
@property(nonatomic,strong)DtacSubCategory *finance_news;
@property(nonatomic,strong)DtacSubCategory *it_news;
@property(nonatomic,strong)DtacSubCategory *luckynumber_news;
@property(nonatomic,strong)DtacSubCategory *lotto_news;
@property(nonatomic,strong)DtacSubCategory *oilprice_news;
@property(nonatomic,strong)DtacSubCategory *goldprice_news;

@end
