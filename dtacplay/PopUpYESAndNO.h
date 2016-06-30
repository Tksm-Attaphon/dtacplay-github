//
//  PopUpYESAndNO.h
//  dtacplay
//
//  Created by attaphon eamsahard on 3/17/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpYESAndNODelegate<NSObject>
-(void)buttonPupUpYesAndNOPress:(BOOL)isYes;
@end


@interface PopUpYESAndNO : UIView
@property (weak, nonatomic) id <PopUpYESAndNODelegate> delegate;
- (IBAction)yesAction:(id)sender;
- (IBAction)noAction:(id)sender;
@end
