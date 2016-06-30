//
//  CPASubCategory.m
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "CPASubCategory.h"

@implementation CPASubCategory
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        if([self isNSNull:dictionary]){
            self.cpaSubCateID = [[self isNSNull:[dictionary objectForKey:@"cpaSubCateId"]] intValue];
            
            self.name = [self isNSNull:[dictionary objectForKey:@"name"]];
             self.engName = [self isNSNull:[dictionary objectForKey:@"nameEn"]];
            
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
