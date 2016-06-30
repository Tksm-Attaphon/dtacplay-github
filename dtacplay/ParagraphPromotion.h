//
//  ParagraphPromotion.h
//  dtacplay
//
//  Created by attaphon on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacImagePromotion.h"
@interface ParagraphPromotion : NSObject
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)DtacImagePromotion *images;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
