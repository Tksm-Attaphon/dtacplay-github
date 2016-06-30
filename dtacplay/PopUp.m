//
//  PopUp.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/24/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "PopUp.h"

@implementation PopUp

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickButton:(id)sender {
    id<PopUpDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(buttonPupUpPress:)]) {
        [strongDelegate buttonPupUpPress:self];
    }
}
@end
