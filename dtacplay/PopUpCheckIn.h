//
//  PopUpCheckIn.h
//  dtacplay
//
//  Created by attaphon eamsahard on 4/11/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpCheckInDelegate<NSObject>
-(void)submitPopUpCheckInWithLinkURL:(NSString*)url;
@end

@interface PopUpCheckIn : UIView
@property(nonatomic,strong)id <PopUpCheckInDelegate> delegate;
@property(nonatomic,strong)NSString *url;
@property (weak, nonatomic) IBOutlet UIImageView *image;
- (IBAction)closePopUp:(id)sender;
- (IBAction)submitPupup:(id)sender;
@end
