//
//  DtacWebViewViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/19/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacWebViewViewController.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DtacWebViewViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
    MBProgressHUD *hud;
}
@end

@implementation DtacWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];
    //    self.navigationItem.titleView = image;
    //
    self.navigationItem.title = self.titlePage;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:_themeColor,
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-15)];
webView.scalesPageToFit = YES;
    webView.delegate = self;
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:self.url];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
     hud= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:self.themeColor];
    // Do any additional setup after loading the view.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // Do whatever you want here
    [hud hide:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hide:YES];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
