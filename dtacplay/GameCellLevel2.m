//
//  GameCellLevel2.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "GameCellLevel2.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
@implementation GameCellLevel2
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0,0, w,h*0.6);
       // [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(5,_imageView.frame.size.height+5,w-10, 25)];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 0;
        [_titleLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_titleLabel setFont:[UIFont fontWithName:FONT_DTAC_BOLD size:IDIOM == IPAD ? 16 : 14]];
        
        _detailLabel= [[UILabel alloc]initWithFrame:CGRectMake(5,_titleLabel.frame.size.height+_titleLabel.frame.origin.y,w-10,50 )];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.numberOfLines = 2;
        [_detailLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_detailLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        
        
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_detailLabel];
    }
    return self;
}
@end
