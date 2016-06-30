//
//  ShoppingItem.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/18/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ShoppingItem.h"
#import "DtacImage.h"
@implementation ShoppingItem
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        
        _shoppingID = [[self isNSNull: [dictionary objectForKey:@"shoppingId"]] intValue];
        _title= [self isNSNull: [dictionary objectForKey:@"topic"]];
        _detail= [self isNSNull: [dictionary objectForKey:@"detail"]];
        _telephone= [self isNSNull: [dictionary objectForKey:@"telephones"]];
        _province= [self isNSNull: [dictionary objectForKey:@"province"]];
        _district= [self isNSNull: [dictionary objectForKey:@"district"]];
        _latitude= [[self isNSNull: [dictionary objectForKey:@"latitude"]] floatValue];
        _longitude= [[self isNSNull: [dictionary objectForKey:@"longitude"]] floatValue];
        _pageCount= [[self isNSNull: [dictionary objectForKey:@"pageCount"]] intValue];
        _smrtAdsRefId= [[self isNSNull: [dictionary objectForKey:@"smrtAdsRefId"]] intValue];
        _price= [[self isNSNull: [dictionary objectForKey:@"price"]] floatValue];
        _address= [NSString stringWithFormat:@"%@ %@" ,_district,_province];
        _publishDate= [self convertJsonDate:[self isNSNull: [dictionary objectForKey:@"startDate"]]];
        _memberID =[[self isNSNull: [dictionary objectForKey:@"memberId"]] stringValue];
        _memberName =[self isNSNull: [dictionary objectForKey:@"memberName"]];
         _email =[self isNSNull: [dictionary objectForKey:@"email"]];
        NSDictionary *imageDic = [self isNSNull: [dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImage alloc]initWithDictionary:imageDic];
        self.titlePreview = [NSString stringWithFormat:@"%@ - %@",self.title,self.detail];
        _dateReadable= @"date ... ";
        
        NSArray *temp = [self isNSNull: [dictionary objectForKey:@"gallery"]];
        _imageName = [[NSMutableArray alloc]init];
        _imageThumbName = [[NSMutableArray alloc]init];
        for (NSDictionary *image in temp){
            NSString *nameThumb  = [self isNSNull: [image objectForKey:@"thumb"]];
            NSString *name  = [self isNSNull: [image objectForKey:@"image"]];
            [_imageName addObject:name];
            [_imageThumbName addObject:nameThumb];
        }
    }
    return self;
}
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
-(id)isNSNull:(id)object{
    if([object isEqual:[NSNull null]]){
        return nil;
    }
    else{
        return object;
    }
}
@end
