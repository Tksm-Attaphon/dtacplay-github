//
//  ClipCPA.m
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "ClipCPA.h"

@implementation ClipCPA
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
                    case 11:
                        self.clip_free_cpa = temp;
                        break;
                        
                    case 12:
                        self.clip_premium_cpa = temp;
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
