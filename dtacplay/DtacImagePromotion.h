//
//  DtacImagePromotion.h
//  dtacplay
//
//  Created by attaphon on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtacImagePromotion : NSObject
@property(nonatomic,strong)NSString *imageS;
@property(nonatomic,strong)NSString *imageW1;
@property(nonatomic,strong)NSString *imageW2;
@property(nonatomic,strong)NSString *imageW3;
@property(nonatomic,strong)NSString *imageW4;
@property(nonatomic,strong)NSString *imageM1;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
