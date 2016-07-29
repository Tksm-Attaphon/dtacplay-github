//
//  RelateContent.h
//  dtacplay
//
//  Created by attaphon eamsahard on 7/20/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelateContent : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *link;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;


@end
