//
//  DtacPlayViewController.h
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DtacPlayViewController : UIViewController
-(void)searchAction:(id)sender;
-(void)searchByTag:(NSString*)tag cateID:(NSString*)cateID;
-(void)change_server;
-(void)googleTagUpdate:(NSDictionary*)dic;

@property(assign,nonatomic)int cateID;
//- (NSMutableURLRequest *)createRequestHTTP:(NSDictionary *)jsonString cookieValue:(NSString *)cookie ;
@end
