//
//  ShoppingCell.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/18/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DtacLabel.h"

@interface ShoppingCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet DtacLabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *date;
@end
