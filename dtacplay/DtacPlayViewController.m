//
//  DtacPlayViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacPlayViewController.h"
#import "Constant.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "SearchTableViewController.h"
#import "UIColor+Extensions.h"
#import "SearchTableViewCell.h"
#import "Manager.h"
#import "SVPullToRefresh.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import "DtacPlaySearchViewController.h"
@interface DtacPlayViewController ()
<UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *searchData;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
    UITableView *tableViewSearch;
}
@end

@implementation DtacPlayViewController
- (BOOL)shouldAutorotate {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage* image3 = [UIImage imageNamed:@"dtacplay_search"];
    CGRect frameimg = CGRectMake(0, 0, 30, 30);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frameimg];
    
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(searchAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIView *searchBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchBtn.bounds = CGRectOffset(searchBtn.bounds, -5, 0);
    [searchBtn addSubview:someButton];

    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    
    self.navigationItem.rightBarButtonItem=menuButton;
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
}
-(void)googleTagUpdate:(NSDictionary*)dic{
    NSLog(@"google tag : %@", [dic objectForKey:@"screenName"]);
    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
    
    [dataLayer push:dic];
    
}
-(void)change_server{
    if([[[Manager sharedManager] server] isEqualToString:SERVICE]){
        [[Manager sharedManager] setServer:SERVICE_2];
    }
    else{
        [[Manager sharedManager] setServer:SERVICE];
    }
}
//- (NSMutableURLRequest *)createRequestHTTP:(NSString *)jsonString cookieValue:(NSString *)cookie {
//    NSMutableURLRequest *requestHTTP = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[Manager sharedManager] server]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
//    
//    [requestHTTP setHTTPMethod:@"POST"];
//    
//    NSData *plainData = [[NSString stringWithFormat:@"%@:%@", @"dtacplay_api", @"6F5Rpb2Se6cxP"] dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *encodedUsernameAndPassword = [plainData base64EncodedStringWithOptions:0];
//    
//    //set auth header
//    [requestHTTP addValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
//    
//    //[requestHTTP setValue:AUTHORIZATION_VALUE forHTTPHeaderField:@"Authorization"];
//    //[requestHTTP setValue:cookie forHTTPHeaderField:@"Cookie"];
//    
//    [requestHTTP setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    [requestHTTP setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"%@", [[Manager sharedManager] accessID]);
//    if([[Manager sharedManager] accessID])
//        [requestHTTP setValue:[NSString stringWithFormat:@"%@",[[Manager sharedManager] accessID]] forHTTPHeaderField:@"x-tksm-accessId"];
//    if([[Manager sharedManager] language])
//        [requestHTTP setValue:[NSString stringWithFormat:@"%d",[[Manager sharedManager] language]] forHTTPHeaderField:@"x-tksm-lang"];
//    else{
//          [requestHTTP setValue:@"1" forHTTPHeaderField:@"x-tksm-lang"];
//    }
//    if([[Manager sharedManager] deviceType])
//        [requestHTTP setValue:[NSString stringWithFormat:@"%d",[[Manager sharedManager] deviceType] ] forHTTPHeaderField:@"x-tksm-device"];
//    NSLog(@"%@", [requestHTTP allHTTPHeaderFields]);
//    return requestHTTP;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)alertError{
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Fail" message:@"cannot connect" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Connection Fail" message:@"cannot connect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView  {
    
   // tableView.frame = self.view.frame;
    
}
-(void)searchByTag:(NSString *)tag cateID:(NSString*)cateID{
    DtacPlaySearchViewController* searchView= [[DtacPlaySearchViewController alloc]init];
    searchView.word = tag;
    searchView.isShowMoreButton = YES;
    searchView.isTagSearch = YES;
    searchView.cateID = [cateID intValue];
    searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\"",tag];

    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:searchView animated:YES];
}
-(void)searchAction:(id)sender{
    SearchTableViewController* searchView= [[SearchTableViewController alloc]init];
    searchView.cateID = _cateID;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:searchView animated:YES];
//    self.title = @"ค้นหา";
//    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    /*the search bar widht must be > 1, the height must be at least 44
//     (the real size of the search bar)*/
//    searchBar.delegate = self;
//    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    /*contents controller is the UITableViewController, this let you to reuse
//     the same TableViewController Delegate method used for the main table.*/
//    
//    searchDisplayController.delegate = self;
//    searchDisplayController.searchResultsDataSource = self;
//    //set the delegate = self. Previously declared in ViewController.h
//    
//    
//    
//    //on the top of tableView.
//    tableViewSearch = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain] ;
//    tableViewSearch.dataSource = self;
//    tableViewSearch.delegate = self;
//    
//    [self.view addSubview:tableViewSearch];
//    
//    self.navigationItem.titleView = searchBar;
//    [tableViewSearch registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"SearchCell"];

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    searchData = [[NSMutableArray alloc]init];
    [searchData addObject:@"This"];
    [searchData addObject:@"is"];
    [searchData addObject:@"Test"];
    [searchData addObject:@"Data"];
    [tableViewSearch reloadData];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2){ // called when search results button pressed

    NSLog(@"hello search");
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [searchData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchCell";
    SearchTableViewCell *cell = [tableViewSearch dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(![searchData[indexPath.row] isEqual:[NSNull null]])
        cell.nameLabel.text = searchData[indexPath.row];
    NSLog(@"%@",cell.nameLabel.text);
    //etc.
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    
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
