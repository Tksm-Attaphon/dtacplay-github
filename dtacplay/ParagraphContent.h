//
//  ParagraphContent.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacImage.h"
@interface ParagraphContent : NSObject
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)DtacImage *images;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
