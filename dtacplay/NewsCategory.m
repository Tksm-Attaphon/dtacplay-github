//
//  NewsCategory.m
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "NewsCategory.h"

@implementation NewsCategory
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
                    case 1:
                        self.hot_news = temp;
                        break;
                    case 2:
                        self.inter_news = temp;
                        break;
                    case 3:
                        self.finance_news = temp;
                        break;
                    case 4:
                        self.it_news = temp;
                        break;
                    case 5:
                        self.oilprice_news = temp;
                        break;
                    case 6:
                        self.goldprice_news = temp;
                        break;
                    case 33:
                        self.luckynumber_news = temp;
                        break;
                    case 36:
                        self.lotto_news = temp;
                        break;
                    case 40:
                        self.wikipedia_news = temp;
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
