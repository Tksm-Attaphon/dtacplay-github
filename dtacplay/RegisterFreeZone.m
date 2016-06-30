//
//  RegisterFreeZone.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/23/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "RegisterFreeZone.h"

@implementation RegisterFreeZone

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeAction:(id)sender {
    id<RegisterFreeZoneDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(whenClosePopUp:)]) {
        [strongDelegate whenClosePopUp:0];
    }
}

- (IBAction)submitNumber:(id)sender {
    NSString* phoneNo = _phoneNumberTextField.text;
    if(phoneNo.length == 0 ){
        id<RegisterFreeZoneDelegate> strongDelegate = self.delegate;
        
        // Our delegate method is optional, so we should
        // check that the delegate implements it
        if ([strongDelegate respondsToSelector:@selector(submitPhoneNumber:phone:)]) {
            [strongDelegate submitPhoneNumber:0 phone:phoneNo];
        }
    }
    else{
        id<RegisterFreeZoneDelegate> strongDelegate = self.delegate;
        
        // Our delegate method is optional, so we should
        // check that the delegate implements it
        if ([strongDelegate respondsToSelector:@selector(submitPhoneNumber:phone:)]) {
            [strongDelegate submitPhoneNumber:1 phone:phoneNo];
        }
    }
}

- (IBAction)submitOTP:(id)sender {
    NSString* otp = _OTPTextField.text;
    if(otp.length == 0 ){
        id<RegisterFreeZoneDelegate> strongDelegate = self.delegate;
        
        // Our delegate method is optional, so we should
        // check that the delegate implements it
        if ([strongDelegate respondsToSelector:@selector(submitOTPNumber:code:)]) {
            [strongDelegate submitOTPNumber:0 code:otp];
        }
    }
    else{
        id<RegisterFreeZoneDelegate> strongDelegate = self.delegate;
        
        // Our delegate method is optional, so we should
        // check that the delegate implements it
        if ([strongDelegate respondsToSelector:@selector(submitOTPNumber:code:)]) {
            [strongDelegate submitOTPNumber:1 code:otp];
        }
    }
}
@end
