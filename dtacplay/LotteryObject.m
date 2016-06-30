//
//  LotteryObject.m
//  dtacplay
//
//  Created by attaphon eamsahard on 1/21/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "LotteryObject.h"

@implementation LotteryObject
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        
        NSString *date =[self isNSNull: [dictionary objectForKey:@"resultDate"]];
        self.resultDate = [self convertJsonDate:date];
        self.title = [self isNSNull:[dictionary objectForKey:@"title" ]];
        
        self.number1 = [self isNSNull:[dictionary objectForKey:@"number1" ]];
        self.reward1 = [[self isNSNull:[dictionary objectForKey:@"reward1" ]] floatValue];
        
        self.numberLast2 = [self isNSNull:[dictionary objectForKey:@"numberLast2" ]];
        self.rewardLast2 = [[self isNSNull:[dictionary objectForKey:@"rewardLast2" ]] floatValue];
        
        self.numberFirst3 = [self isNSNull:[dictionary objectForKey:@"numberFirst3" ]];
        self.rewardFirst3 = [[self isNSNull:[dictionary objectForKey:@"rewardFirst3" ]] floatValue];
        
        self.numberLast3 = [self isNSNull:[dictionary objectForKey:@"numberLast3" ]];
        self.rewardLast3 = [[self isNSNull:[dictionary objectForKey:@"rewardLast3" ]] floatValue];
    
    }
    return self;
}
-(NSDate*)convertJsonDate:(NSString*)jsonDate{

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setDateFormat:@"yyyy-MM-dd"]; // Change here for your formated output
    NSDate *date = [df dateFromString:jsonDate];
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
