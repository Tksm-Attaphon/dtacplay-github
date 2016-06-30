//
//  FreeZoneGameDetailCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "FreeZoneGameDetailCell.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "SocialView.h"
#import "DtacImage.h"
@implementation FreeZoneGameDetailCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(w*0.1,0, w*0.8,w*0.8);
        //[_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor whiteColor]];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        
        
        _socialView = [[[NSBundle mainBundle] loadNibNamed:@"SocialView" owner:self options:nil] objectAtIndex:0];
        [_socialView setFrame:CGRectMake(w*0.1,_imageView.frame.size.height+10,w*0.8, 30)];
        //[self addSubview:_socialView];
       
        
        
        _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(w*0.1,_imageView.frame.size.height+10, _imageView.frame.size.width, 20)];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 0;
        [_titleLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_titleLabel setFont:[UIFont fontWithName:FONT_DTAC_BOLD size:IDIOM == IPAD ? 16 : 14]];
        
        _detailLabel= [[RTLabel alloc]initWithFrame:CGRectMake(w*0.1,_titleLabel.frame.size.height+_titleLabel.frame.origin.y, w*0.8, _imageView.frame.size.height-50)];

        [_detailLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_detailLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];
        
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_detailLabel];
   
        
        _downloadLabel= [[UIButton alloc]initWithFrame:CGRectMake(w/2-125,_imageView.frame.size.height-30, 250, 90)];

        [_downloadLabel setImage:[UIImage imageNamed:@"dtacplay_appstore"] forState:UIControlStateNormal];
        
        [self addSubview:_downloadLabel];

        
        
        
              
    }
    return self;
}
-(void)setSocialItem{
    if(_game != nil){
        NSString *url;
         _socialView.parentView = _parentView;
        url = [NSString stringWithFormat: @"%@music/%@?m=share",DOMAIN_WEBSITE,_game.gameID];
        
        
        [_socialView setValueForShareTitle:_game.title Description:_game.descriptionContent ImageUrl:_game.images.imageL ContentURL:url Category:_game.cate SubCategoryType:_game.subcate contentID:[_game.gameID intValue]];
        
        
    }
}
- (void)layoutSubviews {
    
    //NSLog(@"Printing heading label bounds width: %f", _headingLabel.bounds.size.width);
    
    _titleLabel.preferredMaxLayoutWidth = _titleLabel.bounds.size.width;
    
    [super layoutSubviews];
}
@end
