//
//  GallaryObject.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/14/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "GallaryObject.h"

@implementation GallaryObject
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        self.caption = [self isNSNull: [dictionary objectForKey:@"caption"]];
        self.image = [dictionary objectForKey:@"image"];
        self.thumb = [self isNSNull: [dictionary objectForKey:@"thumb"]];

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
