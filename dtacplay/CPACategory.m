//
//  CPACategory.m
//  dtacplay
//
//  Created by attaphon eamsahard on 6/1/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "CPACategory.h"

@implementation CPACategory
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        if([self isNSNull:dictionary]){
            self.cpaCateID = [[self isNSNull:[dictionary objectForKey:@"cpaCateId"]] intValue];
            
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
