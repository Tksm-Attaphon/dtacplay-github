//
//  LifestyleCategory.m
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "LifestyleCategory.h"

@implementation LifestyleCategory
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        if([self isNSNull:dictionary]){
            self.cateID = [[self isNSNull:[dictionary objectForKey:@"cateId"]] intValue];
            
            self.name = [self isNSNull:[dictionary objectForKey:@"name"]];
            self.engName = [self isNSNull:[dictionary objectForKey:@"nameEn"]];
            NSArray *subCate = [self isNSNull:[dictionary objectForKey:@"subcates"]];
            
            self.subcates = [[NSMutableArray alloc]init];
            for (NSDictionary* subcate in subCate){
                DtacSubCategory *temp = [[DtacSubCategory alloc]initWithDictionary:subcate];
                [self.subcates addObject:temp];
                switch (temp.subCateID) {
                    case 22:
                        self.travel = temp;
                        break;
                    case 23:
                        self.resteraunt = temp;
                        break;
                    case 24:
                        self.accom = temp;
                        break;
                    case 25:
                        self.health= temp;
                        break;
                    case 26:
                        self.horo = temp;
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
