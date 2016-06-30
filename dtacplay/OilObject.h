//
//  OilObject.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OilObject : NSObject
@property(nonatomic,assign)int stationID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSDate *publicDate;
@property(nonatomic,assign)float    pure95;
@property(nonatomic,assign)float    gasohol91;
@property(nonatomic,assign)float    gasohol95;
@property(nonatomic,assign)float    gasoholE20;
@property(nonatomic,assign)float    gasoholE85;
@property(nonatomic,assign)float    diesel;
@property(nonatomic,assign)float    ngv;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
