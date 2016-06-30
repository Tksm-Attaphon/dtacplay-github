//
//  BlockCollectionViewCell.h
//  layout
//
//  Created by attaphon on 9/26/2558 BE.
//  Copyright (c) 2558 attaphon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentPreview.h"
@interface BlockCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) id content;
@property (weak, nonatomic) IBOutlet UILabel *label;
-(void)setImageViewFromURL;
@end
