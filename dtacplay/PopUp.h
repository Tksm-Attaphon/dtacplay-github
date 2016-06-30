//
//  PopUp.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/24/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopUpDelegate<NSObject>
-(void)buttonPupUpPress:(id)type;
@end

@interface PopUp : UIView
- (IBAction)onClickButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id <PopUpDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (assign, nonatomic) int type;
@end
