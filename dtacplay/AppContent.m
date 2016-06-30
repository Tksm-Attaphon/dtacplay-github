//
//  AppContent.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/12/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "AppContent.h"
#import "DtacImage.h"
#import "GallaryObject.h"
@implementation AppContent
-(NSDate*)convertJsonDate:(NSString*)jsonDate{
    NSString * dateStr = jsonDate;
    NSArray *dateStrParts = [dateStr componentsSeparatedByString:@" "];
    NSString *datePart = [dateStrParts objectAtIndex:0];
    NSString *timePart = [dateStrParts objectAtIndex:1];
    
    NSString *t = [[timePart componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *newDateStr = [NSString stringWithFormat:@"%@ %@",datePart,t];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // Change here for your formated output
    NSDate *date = [df dateFromString:newDateStr];
    return date;
} 
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        self.descriptionContent = [self isNSNull: [dictionary objectForKey:@"description"]];
        self.ios = [self isNSNull: [dictionary objectForKey:@"ios"]];
        self.android = [self isNSNull: [dictionary objectForKey:@"android"]];
        self.appID = [self isNSNull: [dictionary objectForKey:@"appId"]];
        self.title = [self isNSNull:  [dictionary objectForKey:@"title"]];
        
        self.subcate = [[self isNSNull: [dictionary objectForKey:@"subCateId"]] intValue];
        self.cate   = [[self isNSNull: [dictionary objectForKey:@"cateId"]] intValue];
        
        NSDictionary *imageDic = [self isNSNull: [dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImage alloc]initWithDictionary:imageDic];
        
        
        NSArray *gallArray = [self isNSNull:[dictionary objectForKey:@"iosScreenshot"]];
        self.gallary = [[NSMutableArray alloc]init];
        for (NSDictionary* gall in gallArray){
            [self.gallary addObject:gall];
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
