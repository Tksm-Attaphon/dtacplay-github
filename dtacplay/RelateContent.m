//
//  RelateContent.m
//  dtacplay
//
//  Created by attaphon eamsahard on 7/20/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "RelateContent.h"

@implementation RelateContent
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        if([self isNSNull:dictionary]){
            self.link = [self isNSNull:[dictionary objectForKey:@"link"]];
            self.title = [self isNSNull:[dictionary objectForKey:@"title"]];
           
            
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
