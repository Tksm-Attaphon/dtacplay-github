//
//  OilObject.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "OilObject.h"

@implementation OilObject
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        self.name = [self isNSNull: [dictionary objectForKey:@"name"]];
        self.stationID = [[dictionary objectForKey:@"stationId"] intValue];
        
        NSString *date =[self isNSNull: [dictionary objectForKey:@"pubDate"]];
        self.publicDate = [self convertJsonDate:date];
        NSDictionary *array = [self isNSNull: [dictionary objectForKey:@"oilPrices"]];
        _pure95 =[[array objectForKey:@"pure95"]floatValue ];
        _gasohol91 =[[ array objectForKey:@"gasohol91"] floatValue ];
            _gasohol95 = [[array objectForKey:@"gasohol95"] floatValue];
         _gasoholE20 =[[array objectForKey:@"gasoholE20" ] floatValue];
        _gasoholE85 = [[array objectForKey:@"gasoholE85"] floatValue];
          _diesel = [[array objectForKey:@"diesel"]floatValue];
          _ngv = [[array objectForKey:@"ngv"] floatValue];
        
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
   // [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
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
