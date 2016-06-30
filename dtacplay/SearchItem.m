//
//  SearchItem.m
//  dtacplay
//
//  Created by attaphon eamsahard on 12/14/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "SearchItem.h"

@implementation SearchItem
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        self.appID = [[self isNSNull: [dictionary objectForKey:@"appId"]] intValue];
        self.cateID = [[self isNSNull: [dictionary objectForKey:@"cateId"]] intValue];
        self.conID = [[self isNSNull: [dictionary objectForKey:@"conId"]] intValue];
        self.feedID = [[self isNSNull: [dictionary objectForKey:@"feedId"]] intValue];
        self.gameID = [[self isNSNull: [dictionary objectForKey:@"gameId"]] intValue];
        self.musicID = [[self isNSNull: [dictionary objectForKey:@"musicId"]] intValue];
        self.shoppingID = [[self isNSNull: [dictionary objectForKey:@"shoppingId"]] intValue];
        self.subCateID = [[self isNSNull: [dictionary objectForKey:@"subCateId"]] intValue];
        
        
        self.title = [self isNSNull: [dictionary objectForKey:@"title"]];
        self.cateName = [self isNSNull: [dictionary objectForKey:@"cateName"]];
        self.subCateName = [self isNSNull: [dictionary objectForKey:@"subCateName"]];
        self.descriptionContent = [self isNSNull: [dictionary objectForKey:@"description"]];
        NSString *result = [_descriptionContent stringByReplacingOccurrencesOfString:@"<[^>]*>" withString:@"" options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, [_descriptionContent length])];
        if(result)
            self.descriptionContent = result;
        else
            self.descriptionContent = @"";
        
        self.link = [self isNSNull: [dictionary objectForKey:@"link"]];
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
