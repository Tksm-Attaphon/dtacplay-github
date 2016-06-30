//
//  SearchTableViewCell.m
//  Casetitude
//
//  Created by attaphon eamsahard on 9/8/2558 BE.
//  Copyright (c) 2558 ThinkSmart iMac1. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //reuseID = @"Cella";
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width-60, 45)];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [self.nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
