//
//  DtacImage.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/9/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacImage.h"
@implementation DtacImage
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        self.imageS = [dictionary objectForKey:@"con_s"];
        self.imageM = [dictionary objectForKey:@"con_m"];
        self.imageL = [dictionary objectForKey:@"con_l"];
        self.imageXL = [dictionary objectForKey:@"con_xl"];
        
        self.imageThumbnailS = [dictionary objectForKey:@"thumb_con_s"];
        self.imageThumbnailM = [dictionary objectForKey:@"thumb_con_m"];
        self.imageThumbnailL = [dictionary objectForKey:@"thumb_con_l"];
        self.imageThumbnailXL = [dictionary objectForKey:@"thumb_con_xl"];
        if(self.imageThumbnailS == nil){
            self.imageThumbnailS = [dictionary objectForKey:@"thumb_s"];
            self.imageThumbnailM = [dictionary objectForKey:@"thumb_m"];
            self.imageThumbnailL = [dictionary objectForKey:@"thumb_l"];
            self.imageThumbnailXL = [dictionary objectForKey:@"thumb_xl"];
        }
    }
    return self;
}
@end
