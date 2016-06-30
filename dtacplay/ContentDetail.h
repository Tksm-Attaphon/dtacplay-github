//
//  ContentDetail.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/9/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacImage.h"
@interface ContentDetail : NSObject
@property(nonatomic,strong)NSString *contentID;
@property(nonatomic,strong)NSString *feedID;
@property(nonatomic,strong)NSString *smrtAdsRefId;
@property(nonatomic,strong)NSString *cateID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)DtacImage *images;

@property(nonatomic,strong)NSArray *media;
@property(nonatomic,strong)NSArray *tags;
@property(nonatomic,strong)NSMutableArray *subContent;
@property(nonatomic,strong)NSMutableArray *gallary;
@property(nonatomic,strong)NSDate *publishDate;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,assign)BOOL isDisplayIntro;
@property(nonatomic,assign)int subCateID;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
