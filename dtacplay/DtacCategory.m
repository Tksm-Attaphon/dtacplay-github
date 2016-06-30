//
//  DtacCategory.m
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "DtacCategory.h"
#import "DtacSubCategory.h"
@implementation DtacCategory
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
