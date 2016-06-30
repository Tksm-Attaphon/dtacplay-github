//
//  GoldObject.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "GoldObject.h"

@implementation GoldObject
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){

        NSString *date =[self isNSNull: [dictionary objectForKey:@"pubDate"]];
        self.publicDate = [self convertJsonDate:date];
        _barBuy =[[dictionary objectForKey:@"barBuy"]floatValue ];
        _barSell =[[ dictionary objectForKey:@"barSell"] floatValue ];
        _ornamentBuy = [[dictionary objectForKey:@"ornamentBuy"] floatValue];
        _ornamentSell =[[dictionary objectForKey:@"ornamentSell" ] floatValue];

        
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
    //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
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
