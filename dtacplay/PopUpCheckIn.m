//
//  PopUpCheckIn.m
//  dtacplay
//
//  Created by attaphon eamsahard on 4/11/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "PopUpCheckIn.h"
#import "DtacWebViewViewController.h"
@implementation PopUpCheckIn


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.image setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
    [self.image addGestureRecognizer:singleFingerTap];
}

-(void)tap:(UITapGestureRecognizer*)gesutre{

    
    id<PopUpCheckInDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(submitPopUpCheckInWithLinkURL:)]) {
        [strongDelegate submitPopUpCheckInWithLinkURL:self.url];
    }
}
- (IBAction)closePopUp:(id)sender {
    [[self superview] removeFromSuperview];
}

- (IBAction)submitPupup:(id)sender {

    
    id<PopUpCheckInDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(submitPopUpCheckInWithLinkURL:)]) {
        [strongDelegate submitPopUpCheckInWithLinkURL:self.url];
    }
}
@end
