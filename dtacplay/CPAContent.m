//
//  CPACotent.m
//  dtacplay
//
//  Created by attaphon eamsahard on 5/16/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "CPAContent.h"

@implementation CPAContent
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        self.cpaConID = [self isNSNull: [dictionary objectForKey:@"cpaConId"]];
        self.cpaCateID = [self isNSNull: [dictionary objectForKey:@"cpaCateId"]];
        self.cpaSubCateID = [self isNSNull: [dictionary objectForKey:@"cpaSubCateId"]];
        self.service = [self isNSNull: [dictionary objectForKey:@"service"]];
        
        self.aocLink = [self isNSNull:  [dictionary objectForKey:@"aocLink"]];
        self.descriptionContent = [self isNSNull: [dictionary objectForKey:@"description"]];
        
        self.flgNew =[[self isNSNull: [dictionary objectForKey:@"flgNew"]] boolValue] ;
        self.flgHot =[[self isNSNull: [dictionary objectForKey:@"flgHot"]] boolValue] ;
        self.flgRec =[[self isNSNull: [dictionary objectForKey:@"flgRec"]] boolValue] ;
        
        NSDictionary *imageDic = [self isNSNull: [dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImage alloc]initWithDictionary:imageDic];

        _descriptionContent = [self clearEntityHtml:_descriptionContent];
   
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
