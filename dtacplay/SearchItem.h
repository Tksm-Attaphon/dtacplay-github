//
//  SearchItem.h
//  dtacplay
//
//  Created by attaphon eamsahard on 12/14/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchItem : NSObject

@property(nonatomic,assign)int appID;
@property(nonatomic,assign)int gameID;
@property(nonatomic,assign)int musicID;
@property(nonatomic,assign)int shoppingID;
@property(nonatomic,assign)int cateID;
@property(nonatomic,assign)int subCateID;
@property(nonatomic,assign)int conID;
@property(nonatomic,assign)int feedID;
@property(nonatomic,strong)NSString *cateName;
@property(nonatomic,strong)NSString *subCateName;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *smrtAdsRefId;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
