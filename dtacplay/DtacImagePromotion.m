//
//  DtacImagePromotion.m
//  dtacplay
//
//  Created by attaphon on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacImagePromotion.h"

@implementation DtacImagePromotion
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        self.imageS = [dictionary objectForKey:@"pb_s1"];
        self.imageW1 = [dictionary objectForKey:@"pb_w1"];
        self.imageW2 = [dictionary objectForKey:@"pb_w2"];
        self.imageW3 = [dictionary objectForKey:@"pb_w3"];
        self.imageW4 = [dictionary objectForKey:@"pb_w4"];
        self.imageM1 = [dictionary objectForKey:@"pb_m1"];
    }
    return self;
}
@end
