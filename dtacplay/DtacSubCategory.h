//
//  DtacSubCategory.h
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtacSubCategory : NSObject
@property(nonatomic,assign)int subCateID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *engName;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;

@end
