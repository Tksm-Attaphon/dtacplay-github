//
//  ContentPreviewPromotion.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/13/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtacImagePromotion.h"
@interface ContentPreviewPromotion : NSObject
@property(nonatomic,strong)NSString *contentID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *descriptionContent;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *previewTitle;
@property(nonatomic,strong)DtacImagePromotion *images;
@property(nonatomic,strong)NSDate *publishDate;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
