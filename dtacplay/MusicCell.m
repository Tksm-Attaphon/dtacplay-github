//
//  MusicCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/5/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "MusicCell.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
@implementation MusicCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        //float h = frame.size.height;
        float w = self.bounds.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0,0, w,w);
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
//        [_imageView setContentMode:UIViewContentModeScaleToFill];
//        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        _nameMusicLabel= [[UILabel alloc]initWithFrame:CGRectMake(5, w+5, w-10, 20)];
        _nameMusicLabel.lineBreakMode = NSLineBreakByTruncatingTail;
 
        [_nameMusicLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_nameMusicLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
        
        _nameArtistLabel= [[UILabel alloc]initWithFrame:CGRectMake(5, w+25, w-10, 18)];
        _nameArtistLabel.lineBreakMode = NSLineBreakByTruncatingTail;

        [_nameArtistLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_nameArtistLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        [_nameArtistLabel setBackgroundColor:[UIColor clearColor]];
        _nameAlbumLabel= [[UILabel alloc]initWithFrame:CGRectMake(5, w+42, w-10, 15)];
        _nameAlbumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
     
        [_nameAlbumLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_nameAlbumLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        
        [self addSubview:_imageView];
        [self addSubview:_nameMusicLabel];
        [self addSubview:_nameArtistLabel];
       // [self addSubview:_nameAlbumLabel];
    }
    return self;
}
@end
