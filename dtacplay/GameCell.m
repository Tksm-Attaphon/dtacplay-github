//
//  GameCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "GameCell.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
@implementation GameCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        //float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0,0, w,w);
      //  [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        _nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(5, w+5, w-10, 20)];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.numberOfLines = 0;
        [_nameLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_nameLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
        
    
        
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
 
    }
    return self;
}

@end
