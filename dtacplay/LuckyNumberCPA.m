//
//  LuckyNumberCPA.m
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "LuckyNumberCPA.h"

@implementation LuckyNumberCPA
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        if([self isNSNull:dictionary]){
            self.cpaCateID = [[self isNSNull:[dictionary objectForKey:@"cpaSubCateId"]] intValue];
            
            self.name = [self isNSNull:[dictionary objectForKey:@"name"]];
             self.engName = [self isNSNull:[dictionary objectForKey:@"nameEn"]] ==nil ? self.name : [dictionary objectForKey:@"nameEn"];
            NSArray *subCate = [self isNSNull:[dictionary objectForKey:@"subcates"]];
            
            self.subcates = [[NSMutableArray alloc]init];
            for (NSDictionary* subcate in subCate){
                CPASubCategory *temp = [[CPASubCategory alloc]initWithDictionary:subcate];
                [self.subcates addObject:temp];
                switch (temp.cpaSubCateID) {
                    case 4:
                        self.lucky_number_cpa = temp;
                        break;
                        
                        
                    default:
                        break;
                }
                
            }
        }
    }
    
    
    return self;
}

-(id)isNSNull:(id)object{
    if([object isEqual:[NSNull null]]){
        return nil;
    }
    else{
        return object;
    }
}

@end
