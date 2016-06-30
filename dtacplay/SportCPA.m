//
//  SportCPA.m
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "SportCPA.h"

@implementation SportCPA
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
                    case 9:
                        self.football_sport_cpa = temp;
                        break;
                        
                    case 10:
                        self.other_sport_cpa = temp;
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
