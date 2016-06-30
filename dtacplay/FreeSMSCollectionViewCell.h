//
//  FreeSMSCollectionViewCell.h
//  dtacplay
//
//  Created by attaphon eamsahard on 3/16/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeSMSCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *head_1;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *text70word;
- (IBAction)sendSMSAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@end
