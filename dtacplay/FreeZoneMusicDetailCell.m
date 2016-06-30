//
//  FreeZoneMusicDetailCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "FreeZoneMusicDetailCell.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "DtacImage.h"
@implementation FreeZoneMusicDetailCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(w*0.1,0, w*0.8,w*0.8);
       // [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor whiteColor]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        
        _socialView = [[[NSBundle mainBundle] loadNibNamed:@"SocialView" owner:self options:nil] objectAtIndex:0];
        [_socialView setFrame:CGRectMake(w*0.1,_imageView.frame.size.height+10,w*0.8, 30)];
        [self addSubview:_socialView];
        
        _nameMusicLabel= [[UILabel alloc]initWithFrame:CGRectMake(w*0.1,_socialView.frame.size.height+_socialView.frame.origin.y+20,_imageView.frame.size.width, 20)];
        _nameMusicLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameMusicLabel.numberOfLines = 0;
        [_nameMusicLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_nameMusicLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
        
        _nameArtistLabel= [[UILabel alloc]initWithFrame:CGRectMake(w*0.1,_nameMusicLabel.frame.size.height+_nameAlbumLabel.frame.origin.y+10,_imageView.frame.size.width, 15)];
        _nameArtistLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameArtistLabel.numberOfLines = 0;
        [_nameArtistLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_nameArtistLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        
        _nameAlbumLabel= [[UILabel alloc]initWithFrame:CGRectMake(w*0.1,_nameArtistLabel.frame.size.height+_nameArtistLabel.frame.origin.y, _imageView.frame.size.width, 15)];
        _nameAlbumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameAlbumLabel.numberOfLines = 0;
        [_nameAlbumLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_nameAlbumLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        
        [self addSubview:_imageView];
        [self addSubview:_nameMusicLabel];
        [self addSubview:_nameArtistLabel];
        [self addSubview:_nameAlbumLabel];
        
       
//        UILabel *fullSongLabel= [[UILabel alloc]initWithFrame:CGRectMake(_imageView.frame.size.width+5,_imageView.frame.size.height-30, w-_imageView.frame.size.width, 15)];
//        fullSongLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        fullSongLabel.numberOfLines = 0;
//        [fullSongLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
//        [fullSongLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
//        
//        [fullSongLabel setText:@"FULL SONG"];
//        
//        UILabel *truetoneLabel= [[UILabel alloc]initWithFrame:CGRectMake(_imageView.frame.size.width+5,_imageView.frame.size.height-45, w-_imageView.frame.size.width, 15)];
//        truetoneLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        truetoneLabel.numberOfLines = 0;
//        [truetoneLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
//        [truetoneLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
//        
//        [truetoneLabel setText:@"TRUE TONE"];
        
        
        _downloadLabel= [[UILabel alloc]initWithFrame:CGRectMake(w*0.1,_nameAlbumLabel.frame.size.height+_nameAlbumLabel.frame.origin.y+20,_imageView.frame.size.width, 20)];
        _downloadLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _downloadLabel.numberOfLines = 0;
        [_downloadLabel setTextColor:[UIColor colorWithHexString:COLOR_FREEZONE]];
        [_downloadLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
        [_downloadLabel setText:@"DOWNLOAD"];
        [_downloadLabel setTextAlignment:NSTextAlignmentLeft];
        
        UIImage *image = [UIImage imageNamed:@"dtacplay_freezone_rbt"];
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(w*0.1, _downloadLabel.frame.size.height+_downloadLabel.frame.origin.y+20, 15, 15)];
        [_icon setImage:image];
        
        [self addSubview:_icon];
        _ringbackLabel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_ringbackLabel addTarget:self
                           action:@selector(userTappedOnLink:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_ringbackLabel setTitle:@"RINGBACK TONE" forState:UIControlStateNormal];
        _ringbackLabel.frame = CGRectMake(w*0.1,_imageView.frame.size.height-20, _imageView.frame.size.width, 15);
        
        //[_ringbackLabel setBackgroundColor:[UIColor redColor]];
        [_ringbackLabel.titleLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        [_ringbackLabel setTintColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_ringbackLabel sizeToFit];
        [_ringbackLabel setFrame:CGRectMake(_ringbackLabel.frame.origin.x-10, _ringbackLabel.frame.origin.y+5, _ringbackLabel.frame.size.width+15, _ringbackLabel.frame.size.height)];
          [self addSubview:_downloadLabel];
        [self addSubview:_ringbackLabel];
//        [self addSubview:fullSongLabel];
//        [self addSubview:truetoneLabel];
        
        
        
        
        
    }
    return self;
}
-(void)setSocialItem{
    if(_music != nil){
        
        _socialView.parentView = _parentView;
        NSString *url;
        
        url = [NSString stringWithFormat: @"%@music/%@?m=share",DOMAIN_WEBSITE,_music.musicID];
        
        [_socialView setValueForShareTitle:_music.title Description:_music.album ImageUrl:_music.images.imageL ContentURL:url Category:_music.cate SubCategoryType:_music.subcate contentID:[_music.musicID intValue]];
        
    }
}
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)userTappedOnLink:(id)gestureRecognizer{
    id<FreeMusicDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onTouchRingBack:)]) {
        [strongDelegate onTouchRingBack:_music];
    }
}

@end
