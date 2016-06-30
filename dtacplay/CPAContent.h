//
//  CPACotent.h
//  dtacplay
//
//  Created by attaphon eamsahard on 5/16/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacImage.h"
@interface CPAContent : NSObject


@property(nonatomic,strong)NSString *cpaConID;
@property(nonatomic,strong)NSString *cpaCateID;
@property(nonatomic,strong)NSString *cpaSubCateID;
@property(nonatomic,strong)NSString *service;
@property(nonatomic,strong)DtacImage *images;

@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)NSString *aocLink
;
@property(nonatomic,assign)BOOL flgNew;
@property(nonatomic,assign)BOOL flgHot;
@property(nonatomic,assign)BOOL flgRec;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;

@end
