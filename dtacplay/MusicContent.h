//
//  MusicContent.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/12/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@class DtacImage;
@interface MusicContent : NSObject
@property(nonatomic,strong)NSString *album;
@property(nonatomic,strong)NSString *artist;
@property(nonatomic,strong)NSString *musicID;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)DtacImage *images;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *feedID;

@property(nonatomic,strong)NSString *truetone;
@property(nonatomic,strong)NSString *fullsong;
@property(nonatomic,strong)NSString *rbt;
@property(nonatomic,strong)NSString *smrtAdsRefId;


@property(nonatomic,assign)SubCategorry subcate;
@property(nonatomic,assign)CategorryType cate;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
