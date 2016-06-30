//
//  SearchCategory.m
//  dtacplay
//
//  Created by attaphon eamsahard on 12/14/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "SearchCategory.h"
#import "SearchItem.h"
@implementation SearchCategory
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        self.cateID = [[self isNSNull: [dictionary objectForKey:@"cateId"]] intValue];
  
        NSArray* temp = [self isNSNull: [dictionary objectForKey:@"content"]];
        self.objectList = [[NSMutableArray alloc]init];
        for(NSDictionary* obj in temp){
            SearchItem* item = [[SearchItem alloc]initWithDictionary:obj];
            [self.objectList addObject:item];
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
