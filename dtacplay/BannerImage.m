//
//  BannerImage.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/24/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "BannerImage.h"

@implementation BannerImage
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        self.image_r1 = [dictionary objectForKey:@"m"];//l
        self.image_w1 = [dictionary objectForKey:@"m"];
        self.image_w3 = [dictionary objectForKey:@"s"];

    }
    return self;
}
@end
