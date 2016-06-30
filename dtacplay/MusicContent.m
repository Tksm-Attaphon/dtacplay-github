//
//  MusicContent.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/12/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "MusicContent.h"
#import "DtacImage.h"
@implementation MusicContent
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
        self.feedID = [self isNSNull:  [dictionary objectForKey:@"feedId"]];
        
        self.album = [self isNSNull: [dictionary objectForKey:@"album"]];
        self.artist = [self isNSNull: [dictionary objectForKey:@"artist"]];
        self.musicID = [self isNSNull: [dictionary objectForKey:@"musicId"]];
        
        self.truetone = [self isNSNull: [dictionary objectForKey:@"truetone"]];
        self.fullsong = [self isNSNull: [dictionary objectForKey:@"fullsong"]];
        self.rbt = [self isNSNull: [dictionary objectForKey:@"rbt"]];
        
        self.title = [self isNSNull:  [dictionary objectForKey:@"title"]];
        self.link = [self isNSNull: [dictionary objectForKey:@"link"]];
        
        self.subcate = [[self isNSNull: [dictionary objectForKey:@"subCateId"]] intValue];
        self.cate   = [[self isNSNull: [dictionary objectForKey:@"cateId"]] intValue];
        
        NSDictionary *imageDic = [self isNSNull: [dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImage alloc]initWithDictionary:imageDic];
       
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
