//
//  GoldObject.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldObject : NSObject
@property(nonatomic,strong)NSDate *publicDate;
@property(nonatomic,assign)float    barBuy;
@property(nonatomic,assign)float    barSell;
@property(nonatomic,assign)float    ornamentBuy;
@property(nonatomic,assign)float    ornamentSell;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
