//
//  AppCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/12/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "AppCell.h"

#import "Constant.h"
#import "UIColor+Extensions.h"
@implementation AppCell
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
        _title= [[UILabel alloc]initWithFrame:CGRectMake(5, w-5, w-10, 20)];
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.numberOfLines = 1;
        [_title setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
        
        _desc= [[UILabel alloc]initWithFrame:CGRectMake(5, w+20, w-10, 15)];
        _desc.lineBreakMode = NSLineBreakByTruncatingTail;
        _desc.numberOfLines = 1;
        [_desc setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_desc setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];

        [self addSubview:_imageView];
        [self addSubview:_title];
        [self addSubview:_desc];
    }
    return self;
}
@end
