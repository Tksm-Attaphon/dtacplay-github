//
//  ParagraphPromotion.m
//  dtacplay
//
//  Created by attaphon on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ParagraphPromotion.h"
#import "DtacImagePromotion.h"
@implementation ParagraphPromotion
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        self.descriptionContent = [self isNSNull:[dictionary objectForKey:@"description"]];
        self.descriptionContent = [self.descriptionContent stringByReplacingOccurrencesOfString:@"&ndash;"
                                                                                     withString:@""];
        self.descriptionContent = [self.descriptionContent stringByReplacingOccurrencesOfString:@"&nbsp;"
                                                                                     withString:@" "];
        self.descriptionContent = [self.descriptionContent stringByReplacingOccurrencesOfString:@"&idquo;"
                                                                                     withString:@""];
        self.descriptionContent = [self.descriptionContent stringByReplacingOccurrencesOfString:@"&rdquo;"
                                                                                     withString:@""];
        self.descriptionContent = [self.descriptionContent stringByReplacingOccurrencesOfString:@"&ldquo;"
                                                                                     withString:@""];
        self.descriptionContent = [self.descriptionContent stringByReplacingOccurrencesOfString:@"&amp;"
                                                                                     withString:@""];
        self.descriptionContent = [self.descriptionContent stringByReplacingOccurrencesOfString:@"&quot;"
                                                                                     withString:@""];
        NSDictionary *imageDic = [self isNSNull:[dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImagePromotion alloc]initWithDictionary:imageDic];
        
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
