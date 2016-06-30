//
//  SearchCategory.h
//  dtacplay
//
//  Created by attaphon eamsahard on 12/14/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCategory : NSObject

@property(nonatomic,assign)int cateID;
@property(nonatomic,strong)NSMutableArray *objectList;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
