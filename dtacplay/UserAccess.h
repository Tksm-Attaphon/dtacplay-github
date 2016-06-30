//
//  UserAccess.h
//  dtacplay
//
//  Created by attaphon eamsahard on 9/22/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

typedef enum Device : NSUInteger {
    Website,
    Smartphone,
    Tablet,
    FeaturePhone
} Device;

@interface UserAccess : JSONModel

@property (strong, nonatomic) NSString *UserAccessID;
@property (assign,nonatomic) Device userDevice;


@end
