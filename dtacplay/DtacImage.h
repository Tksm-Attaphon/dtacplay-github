//
//  DtacImage.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/9/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtacImage : NSObject
@property(nonatomic,strong)NSString *imageS;
@property(nonatomic,strong)NSString *imageM;
@property(nonatomic,strong)NSString *imageL;
@property(nonatomic,strong)NSString *imageXL;
@property(nonatomic,strong)NSString *imageThumbnailS;
@property(nonatomic,strong)NSString *imageThumbnailM;
@property(nonatomic,strong)NSString *imageThumbnailL;
@property(nonatomic,strong)NSString *imageThumbnailXL;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
