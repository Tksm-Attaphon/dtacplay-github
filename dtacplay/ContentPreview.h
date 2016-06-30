//
//  ContentPreView.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/9/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacImage.h"
@interface ContentPreview : NSObject
@property(nonatomic,strong)NSString *contentID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)DtacImage *images;
@property(nonatomic,strong)NSDate *publishDate;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;
@property(nonatomic,strong)NSString *dateString;
@property(nonatomic,strong)NSString *previewTitle;
@property(nonatomic,assign)int subCateID;
@property(nonatomic,strong)NSString *feedID;
@property(nonatomic,strong)NSString *cateID;
@property(nonatomic,strong)NSString *smrtAdsRefId;

@property(nonatomic,strong)NSString *cpaConId;
@property(nonatomic,strong)NSString *aocLink;
@property(nonatomic,assign)BOOL flgNew;
@property(nonatomic,assign)BOOL flgHot;
@property(nonatomic,assign)BOOL flgRec;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
