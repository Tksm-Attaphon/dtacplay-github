//
//  FreeZoneGameDetailCell.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "GameContent.h"
#import "SocialView.h"
@interface FreeZoneGameDetailCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)RTLabel *detailLabel;
@property(nonatomic,strong )UIButton *downloadLabel;
@property(nonatomic,strong)GameContent *game;
@property(nonatomic,strong)SocialView *socialView;
@property(nonatomic,strong)id parentView;
-(void)setSocialItem;

@end
