//
//  ContentDetail.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/9/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ContentDetail.h"
#import "Constant.h"
#import "ParagraphContent.h"
#import "GallaryObject.h"
@implementation ContentDetail
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        if([self isNSNull:dictionary]){
        self.contentID = [self isNSNull:[dictionary objectForKey:@"conId"]];
        self.cateID = [self isNSNull:[dictionary objectForKey:@"cateId"]];
        self.title = [self isNSNull:[dictionary objectForKey:@"title"]];
        self.descriptionContent = [self isNSNull:[dictionary objectForKey:@"description"]];
        self.descriptionContent = [self clearEntityHtml:self.descriptionContent];
            
        self.link =[self isNSNull:[dictionary objectForKey:@"link"]] ;
        self.feedID =[self isNSNull:[dictionary objectForKey:@"feedId"]] ;
        self.smrtAdsRefId =[self isNSNull:[dictionary objectForKey:@"smrtAdsRefId"]] ;
            
            
        self.subCateID = [[self isNSNull: [dictionary objectForKey:@"subCateId"]] intValue];
        NSDictionary *imageDic = [dictionary objectForKey:@"images"] ;
        self.images = [[DtacImage alloc]initWithDictionary:imageDic];
        
        self.publishDate = [dictionary objectForKey:@"pubDate"];
        self.startDate = [dictionary objectForKey:@"startDate"];
            
        self.media =[self isNSNull: [dictionary objectForKey:@"media"]];
        self.tags = [self isNSNull: [dictionary objectForKey:@"tags"]];
        
        NSArray *subContentArray = [self isNSNull:[dictionary objectForKey:@"subContent"]];
        self.subContent = [[NSMutableArray alloc]init];
        for (NSDictionary* sc in subContentArray){
            ParagraphContent *temp = [[ParagraphContent alloc]initWithDictionary:sc];
            [self.subContent addObject:temp];
        }
 self.isDisplayIntro = [[dictionary objectForKey:@"displayIntro"] boolValue];
        
        NSArray *gallArray = [self isNSNull:[dictionary objectForKey:@"gallery"]];
        self.gallary = [[NSMutableArray alloc]init];
        for (NSDictionary* gall in gallArray){
            GallaryObject *temp = [[GallaryObject alloc]initWithDictionary:gall];
            [self.gallary addObject:temp];
        }
        }
    }
    
    
    return self;
}
-(NSString*)clearEntityHtml:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@"&ndash;"
                                                                                 withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;"
                                                                                 withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&idquo;"
                                                                                 withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&rdquo;"
                                                                                 withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&ldquo;"
                                                                                 withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;"
                                                                                 withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;"
                                                                                 withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&hellip;"
                                                                                 withString:@"..."];
    return string;
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
