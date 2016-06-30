//
//  ContentPreviewPromotion.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ContentPreviewPromotion.h"
#import "DtacImagePromotion.h"
#import "Manager.h"
@implementation ContentPreviewPromotion
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        self.contentID = [self isNSNull:[dictionary objectForKey:@"conId"]];
        self.title = [self isNSNull:[dictionary objectForKey:@"title"]];
        self.descriptionContent = [self isNSNull:[dictionary objectForKey:@"description"]];
        self.link =[self isNSNull:[dictionary objectForKey:@"link"] ];
        
        NSDictionary *imageDic = [self isNSNull:[dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImagePromotion alloc]initWithDictionary:imageDic];
        
        self.publishDate = [self isNSNull:[dictionary objectForKey:@"pubDate"]];
        
        NSString *result = [_descriptionContent stringByReplacingOccurrencesOfString:@"<[^>]*>" withString:@"" options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, [_descriptionContent length])];
        if(result)
            self.previewTitle = [NSString stringWithFormat:@"%@ - %@",self.title,result];
        else
            self.previewTitle = [NSString stringWithFormat:@"%@",self.title];
        
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
