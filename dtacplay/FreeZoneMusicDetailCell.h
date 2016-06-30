//
//  FreeZoneMusicDetailCell.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicContent.h"
#import "SocialView.h"
@protocol FreeMusicDelegate<NSObject>
-(void)onTouchRingBack:(MusicContent*)music;
@end


@interface FreeZoneMusicDetailCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *nameMusicLabel;
@property(nonatomic,strong)UILabel *nameArtistLabel;
@property(nonatomic,strong)UILabel *nameAlbumLabel;

@property(nonatomic,strong)UILabel *downloadLabel;
@property(nonatomic,strong)UIButton *ringbackLabel;

@property (weak, nonatomic) id <FreeMusicDelegate> delegate;

@property(nonatomic,strong)MusicContent *music;
@property(nonatomic,strong)SocialView *socialView;
@property(nonatomic,strong)id parentView;
-(void)setSocialItem;
@end
