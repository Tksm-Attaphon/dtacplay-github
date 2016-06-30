//
//  RegisterFreeZone.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/23/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RegisterFreeZoneDelegate<NSObject>
-(void)submitPhoneNumber:(int)type phone:(NSString*)number;
-(void)submitOTPNumber:(int)type code:(NSString*)number;
-(void)whenClosePopUp:(int)type;
@end

@interface RegisterFreeZone : UIView
- (IBAction)closeAction:(id)sender;
- (IBAction)submitNumber:(id)sender;
- (IBAction)submitOTP:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitPhoneButton;
@property (weak, nonatomic) IBOutlet UITextField *OTPTextField;
@property (weak, nonatomic) id <RegisterFreeZoneDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *submitOTP;
@property (weak, nonatomic) IBOutlet UILabel *codeReference;
@end
