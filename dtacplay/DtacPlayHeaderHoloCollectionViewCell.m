//
//  DtacPlayHeaderHoloCollectionViewCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/29/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacPlayHeaderHoloCollectionViewCell.h"
#import "Constant.h"
#import "DtacLabel.h"
#import "UIColor+Extensions.h"
@implementation DtacPlayHeaderHoloCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
       // float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 )];
        [_line setBackgroundColor:[UIColor colorWithHexString:COLOR_LIFESTYLE]];
        [self addSubview:_line];
        
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0,5, 30, 30);
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setImage:[UIImage imageNamed:@"default_image_01_L.jpg"]];
        _label= [[DtacLabel alloc]initWithFrame:CGRectMake(_imageView.frame.size.width+5,-5, w-_imageView.frame.size.width+5, self.frame.size.height+10)];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.numberOfLines = 0;
       
        [_label setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_label setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 18 : 14]];
        
        
        _moreButton= [[UIButton alloc]initWithFrame:CGRectMake(w-30,_imageView.frame.origin.y, 30, 30)];
        
        [_moreButton setImage:[UIImage imageNamed:@"dtacplay_home_more_lifestyle"] forState:UIControlStateNormal];
        
        [self addSubview:_moreButton];
        
        
        [self addSubview:_imageView];
        [self addSubview:_label];
    }
    return self;
}
@end
