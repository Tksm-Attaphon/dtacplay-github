//
//  DtacCategory.h
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacSubCategory.h"

@interface DtacCategory : NSObject
@property(nonatomic,assign)int cateID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *engName;
@property(nonatomic,strong)NSMutableArray *subcates;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;

@end
