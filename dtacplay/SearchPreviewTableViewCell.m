//
//  SearchPreviewTableViewCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 12/2/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "SearchPreviewTableViewCell.h"

#import "Constant.h"
#import "UIColor+Extensions.h"

#import "Manager.h"

@implementation SearchPreviewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
    _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(20, 10,screenWidth-40, 20)];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [_titleLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
    [_titleLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14]];
    
    _detailLabel= [[UILabel alloc]initWithFrame:CGRectMake(20, _titleLabel.frame.size.height+10,screenWidth-40, 20)];
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [_detailLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
    [_detailLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12]];

      [self addSubview:_titleLabel];
      [self addSubview:_detailLabel];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
