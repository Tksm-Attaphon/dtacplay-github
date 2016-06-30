//
//  PromotionDetail.m
//  dtacplay
//
//  Created by attaphon on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "PromotionDetail.h"
#import "DtacImagePromotion.h"
#import "ParagraphPromotion.h"
@implementation PromotionDetail
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        if([self isNSNull:dictionary]){
      
        
        self.contentID = [self isNSNull: [dictionary objectForKey:@"conId"]];
        self.title = [self isNSNull:  [dictionary objectForKey:@"title"]];
        self.descriptionContent = [self isNSNull: [dictionary objectForKey:@"description"]];
        self.link =[self isNSNull: [dictionary objectForKey:@"link"]] ;
        
        NSDictionary *imageDic = [self isNSNull: [dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImagePreview alloc]initWithDictionary:imageDic];
        
        NSArray *subContentArray = [self isNSNull:[dictionary objectForKey:@"subContent"]];
        self.subContent = [[NSMutableArray alloc]init];
        for (NSDictionary* sc in subContentArray){
            ParagraphPromotion *temp = [[ParagraphPromotion alloc]initWithDictionary:sc];
            [self.subContent addObject:temp];
        }
        self.publishDate = [self isNSNull: [dictionary objectForKey:@"pubDate"]];
          self.isDisplayIntro = [[dictionary objectForKey:@"displayIntro"] boolValue];
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
