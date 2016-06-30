//
//  DtacPlayBlockCollectionViewCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/27/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacPlayBigBlockCollectionViewCell.h"
#import "Constant.h"
#import "DtacLabel.h"
#import "UIColor+Extensions.h"
@implementation DtacPlayBigBlockCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0,0, w,(w*312)/650);
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
//        [_imageView setBackgroundColor:[UIColor blackColor]];
//        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_01_L.jpg"]];
        _label= [[DtacLabel alloc]initWithFrame:CGRectMake(5, h*0.6, w-10, h*0.3)];
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.numberOfLines = 2;
        [_label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
        [self addSubview:_imageView];
        [self addSubview:_label];
    }
    return self;
}

@end
