//
//  GallaryObject.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/14/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GallaryObject : NSObject
@property(strong)NSString *caption;
@property(strong)NSString *image;
@property(strong)NSString *thumb;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
