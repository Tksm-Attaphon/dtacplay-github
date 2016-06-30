//
//  LotteryCellCollectionViewCell.h
//  dtacplay
//
//  Created by attaphon eamsahard on 1/21/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotteryCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *number_1;
@property (weak, nonatomic) IBOutlet UILabel *reward_1;
@property (weak, nonatomic) IBOutlet UILabel *number_3_front;
@property (weak, nonatomic) IBOutlet UILabel *reward_3_front;
@property (weak, nonatomic) IBOutlet UILabel *number_3_back;
@property (weak, nonatomic) IBOutlet UILabel *reward_3_back;
@property (weak, nonatomic) IBOutlet UILabel *number_2;
@property (weak, nonatomic) IBOutlet UILabel *reward_2;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@end
