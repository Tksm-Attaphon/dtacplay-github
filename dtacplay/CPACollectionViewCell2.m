//
//  CPACollectionViewCell2.m
//  dtacplay
//
//  Created by attaphon eamsahard on 4/25/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "CPACollectionViewCell2.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "NimbusKitAttributedLabel.h"
@implementation CPACollectionViewCell2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        //float h = frame.size.height;
        float h = self.frame.size.width*0.25;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(5,5, h,h);
          [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        
        _descriptionLabel= [[NIAttributedLabel alloc]initWithFrame:CGRectMake(h+10,5, self.frame.size.width-h-20, frame.size.height-10)];
      
        _descriptionLabel.numberOfLines = 0;
        [_descriptionLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_descriptionLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];

        [self addSubview:_imageView];
        [self addSubview:_descriptionLabel];
        
    }
    return self;
}

@end
