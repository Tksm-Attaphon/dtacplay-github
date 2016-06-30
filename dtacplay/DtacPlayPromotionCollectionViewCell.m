//
//  DtacPlayBlockCollectionViewCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/27/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacPlayPromotionCollectionViewCell.h"
#import "Constant.h"
#import "DtacLabel.h"
#import "UIColor+Extensions.h"
@implementation DtacPlayPromotionCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0,0, w,(w*165)/500);
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setImage:[UIImage imageNamed:@"default_image_01_L.jpg"]];
        _label= [[DtacLabel alloc]initWithFrame:CGRectMake(5, (w*165)/500, w-10,h- (w*165)/500)];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.numberOfLines = 0;
        [_label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
        [self addSubview:_imageView];
        [self addSubview:_label];
        
    }
    return self;
}

@end
