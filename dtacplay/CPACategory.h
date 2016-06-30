//
//  CPACategory.h
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPACategory : NSObject
@property(nonatomic,assign)int cpaCateID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *engName;
@property(nonatomic,strong)NSMutableArray *subcates;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
