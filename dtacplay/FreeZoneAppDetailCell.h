//
//  FreeZoneGameDetailCell.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "SocialView.h"
#import "AppContent.h"
@protocol ImageShowCaseDelegate<NSObject>
-(void)onTouchImageShowCase:(int)index;
@end

@interface FreeZoneAppDetailCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)RTLabel *detailLabel;
@property(nonatomic,strong)UILabel *imageShowcaseLabel;
@property(nonatomic,strong)UICollectionView *imageShowCollection;
@property(nonatomic,strong )UIButton *downloadLabel;
@property(nonatomic,strong)NSMutableArray *screenArray;
 @property (nonatomic, retain) SocialView *myViewFromNib;
@property (weak, nonatomic) id <ImageShowCaseDelegate> delegate;
@property(nonatomic,strong)AppContent *app;
@property(nonatomic,strong)SocialView *socialView;
@property(nonatomic,strong)id parentView;

-(void)setSocialItem;

@end
