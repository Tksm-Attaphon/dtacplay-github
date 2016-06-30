//
//  BannerImage.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/24/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerImage : NSObject
@property(nonatomic,strong)NSString *image_r1;
@property(nonatomic,strong)NSString *image_w1;
@property(nonatomic,strong)NSString *image_w3;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
