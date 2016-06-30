//
//  ShoppingItem.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/18/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DtacImage;
@interface ShoppingItem : NSObject
@property(nonatomic,assign)int shoppingID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *detail;
@property(nonatomic,strong)NSString *telephone;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)int pageCount;
@property(nonatomic,assign)float price;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *memberID;
@property(nonatomic,strong)NSString *memberName;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *titlePreview;
@property(nonatomic,strong)NSDate *publishDate;
@property(nonatomic,strong)DtacImage *images;
@property(nonatomic,strong)NSString *dateReadable;
@property(nonatomic,assign)int smrtAdsRefId;
@property(nonatomic,strong)NSMutableArray *imageName;
@property(nonatomic,strong)NSMutableArray *imageThumbName;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary ;
@end
