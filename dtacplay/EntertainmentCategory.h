//
//  EntertainmentCategory.h
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "DtacCategory.h"

@interface EntertainmentCategory : DtacCategory
@property(nonatomic,strong)DtacSubCategory *news;
@property(nonatomic,strong)DtacSubCategory *tv;
@property(nonatomic,strong)DtacSubCategory *news_movie;
@property(nonatomic,strong)DtacSubCategory *trailer_movie;
@property(nonatomic,strong)DtacSubCategory *news_music;
@property(nonatomic,strong)DtacSubCategory *video;
@property(nonatomic,strong)DtacSubCategory *talkofthetown;

@end
