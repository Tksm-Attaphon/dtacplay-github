//
//  AppContent.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/12/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@class DtacImage;
@interface AppContent : NSObject

@property(nonatomic,strong)NSString *android;
@property(nonatomic,strong)NSString *appID;
@property(nonatomic,strong)NSString *ios;
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)DtacImage *images;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSMutableArray *gallary;
@property(nonatomic,assign)CategorryType cate;
@property(nonatomic,assign)SubCategorry subcate;
@property(nonatomic,strong)NSString *smrtAdsRefId;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
