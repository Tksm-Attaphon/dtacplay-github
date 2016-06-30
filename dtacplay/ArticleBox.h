//
//  ArticleBox.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ArticleBox : JSONModel

@property(nonatomic,strong)NSString *imageURL;
@property(nonatomic,strong)NSString *headerContent;
@property(nonatomic,strong)NSString *ID;

@end
