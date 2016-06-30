//
//  Banner.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/24/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  BannerImage;
@interface Banner : NSObject
@property(nonatomic,assign)int bannerId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)BannerImage *images;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
