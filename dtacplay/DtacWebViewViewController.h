//
//  DtacWebViewViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/19/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DtacPlayViewController.h"
@interface DtacWebViewViewController : DtacPlayViewController
@property(nonatomic,strong)NSURL *url;
@property(nonatomic,strong)UIColor *themeColor;
@property(nonatomic,strong)NSString *titlePage;
@property(nonatomic,strong)NSString *html;
@end
