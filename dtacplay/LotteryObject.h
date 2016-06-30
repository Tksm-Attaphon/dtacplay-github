//
//  LotteryObject.h
//  dtacplay
//
//  Created by attaphon eamsahard on 1/21/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryObject : NSObject
@property(nonatomic,strong)NSDate *resultDate;
@property(nonatomic,strong)NSString*    title;
@property(nonatomic,strong)NSString*    number1;
@property(nonatomic,assign)float    reward1;
@property(nonatomic,strong)NSString*    numberLast2;
@property(nonatomic,assign)float    rewardLast2;
@property(nonatomic,strong)NSString*    numberFirst3;
@property(nonatomic,assign)float    rewardFirst3;
@property(nonatomic,strong)NSString*    numberLast3;
@property(nonatomic,assign)float   rewardLast3;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
