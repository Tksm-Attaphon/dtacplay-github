//
//  AppCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/12/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "CPACell.h"
#import "NimbusKitAttributedLabel.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
@implementation CPACell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(10,10, w-20,w-20);
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        //                [_imageView setContentMode:UIViewContentModeScaleToFill];
        //                [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        _title= [[NIAttributedLabel alloc]initWithFrame:CGRectMake(5, w-10, w-10, 50)];
        
        _title.numberOfLines =2;
        [_title setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];

        [self addSubview:_imageView];
        [self addSubview:_title];
    }
    return self;
}
@end
