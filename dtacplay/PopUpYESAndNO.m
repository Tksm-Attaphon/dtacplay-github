//
//  PopUpYESAndNO.m
//  dtacplay
//
//  Created by attaphon eamsahard on 3/17/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "PopUpYESAndNO.h"

@implementation PopUpYESAndNO

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)yesAction:(id)sender {
    id<PopUpYESAndNODelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(buttonPupUpYesAndNOPress:)]) {
        [strongDelegate buttonPupUpYesAndNOPress:YES];
    }
}

- (IBAction)noAction:(id)sender {
    id<PopUpYESAndNODelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(buttonPupUpYesAndNOPress:)]) {
        [strongDelegate buttonPupUpYesAndNOPress:NO];
    }
}
@end
