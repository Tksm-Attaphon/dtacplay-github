//
//  PromotionDetail.h
//  dtacplay
//
//  Created by attaphon on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacImagePreview.h"
@interface PromotionDetail : NSObject
@property(nonatomic,strong)NSString *contentID;
@property(nonatomic,assign)BOOL displayIntro;
@property(nonatomic,strong)NSArray *gallery;
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)DtacImagePreview *images;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSArray *media;
@property(nonatomic,strong)NSString *publishDate;
@property(nonatomic,strong)NSMutableArray *subContent;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)BOOL isDisplayIntro;
@property(nonatomic,strong)NSString *smrtAdsRefId;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
