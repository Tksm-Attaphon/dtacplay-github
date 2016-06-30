//
//  SocialView.h
//  dtacplay
//
//  Created by attaphon eamsahard on 11/20/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSDKShareKit.h"
#import "Constant.h"
@protocol SocialShare<NSObject>
-(void)shareSocial:(int)type;
@end

@interface SocialView : UIView<FBSDKSharingDelegate>

- (IBAction)shareFBAction:(id)sender;
- (IBAction)shareTweeter:(id)sender;
- (IBAction)shareLine:(id)sender;

-(void)setValueForShareTitle:(NSString*)title Description:(NSString*)description ImageUrl:(NSString*)imageURL ContentURL:(NSString*)contentURL Category:(CategorryType)cate SubCategoryType:(SubCategorry)subcate contentID:(int)contentID;
@property (weak, nonatomic) id <SocialShare> delegate;
@property (strong, nonatomic) id parentView;

@property (strong, nonatomic) NSDictionary* contentDictionary;

@property (assign, nonatomic) int contentID;
@property (assign, nonatomic) CategorryType cate;
@property (assign, nonatomic) SubCategorry subCate;


@property (weak, nonatomic) IBOutlet UIButton *lineButton;
@property (weak, nonatomic) IBOutlet UIButton *tweeterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@end
