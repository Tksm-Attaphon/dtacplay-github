//
//  BannerCollectionViewCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 7/12/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "BannerCollectionViewCell.h"

@implementation BannerCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        // float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];

        
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(10,0, w-20, frame.size.height);
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setImage:[UIImage imageNamed:@"default_image_01_L.jpg"]];

        [self addSubview:_imageView];
       
    }
    return self;
}

@end
