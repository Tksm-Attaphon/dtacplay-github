//
//  SearchTableViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchTableViewCell.h"
#import "Constant.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "UIColor+Extensions.h"
#import "DtacPlaySearchViewController.h"
#import "Manager.h"
#import "SearchItem.h"
#import "SearchCategory.h"
@interface SearchTableViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *searchData;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
    NSArray *recipes;
    NSMutableArray *searchResults;
    
}
@end

@implementation SearchTableViewController
-(void)getSearchList:(NSString*)word{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTitleCate\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"limit\":5}}",1,word];
    
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tempList = [[NSMutableArray alloc]init];
        if ([responseObject objectForKey:@"result"]) {
            
            NSDictionary *content =[responseObject objectForKey:@"result"] ;
            if(![content isEqual:[NSNull null]]){
                NSArray *list =[content objectForKey:@"categories"] ;
                
                for (NSDictionary *item in list){
                    SearchCategory *search = [[SearchCategory alloc]initWithDictionary:item];
                    [tempList addObject:search];
                }
                
            }
        }
        searchData = tempList;
        
        [self.tableView reloadData];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //[[Manager sharedManager] showErrorAlert:self];
    }];
    [op start];
    
    
    
}
-(void)getSearchListByTag:(NSString*)word{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTitleCate\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"page\":1,\"limit\":100}}",1,word];
    
    
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tempList = [[NSMutableArray alloc]init];
        if ([responseObject objectForKey:@"result"]) {
            
            NSDictionary *content =[responseObject objectForKey:@"result"] ;
            if(![content isEqual:[NSNull null]]){
                NSArray *list =[content objectForKey:@"categories"] ;
                
                for (NSDictionary *item in list){
                    SearchCategory *search = [[SearchCategory alloc]initWithDictionary:item];
                    [tempList addObject:search];
                }
                
            }
        }
        searchData = tempList;
        
        [self.tableView reloadData];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //[[Manager sharedManager] showErrorAlert:self];
    }];
    [op start];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.title = @"ค้นหา";
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    /*the search bar widht must be > 1, the height must be at least 44
     (the real size of the search bar)*/
    searchBar.delegate = self;
 
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    /*contents controller is the UITableViewController, this let you to reuse
     the same TableViewController Delegate method used for the main table.*/
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    //set the delegate = self. Previously declared in ViewController.h
    
    
    searchDisplayController.searchBar.text = _inputText;
    //on the top of tableView.
    
    self.navigationItem.titleView = searchBar;
    [[self tableView] registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"SearchCell"];
    
    searchData = [[NSMutableArray alloc]init];
    
    if(IDIOM==IPAD)
        searchDisplayController.displaysSearchBarInNavigationBar=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
}
-(void)viewWillAppear:(BOOL)animated{
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)searchBar:(UISearchBar *)searchBars textDidChange:(NSString *)searchText{
    //if(searchText.length%4 == 0)
//    if(_inputText != nil){
//    [self getSearchList:searchText];
//    }else{
//        [self  getSearchListByTag:searchText];
//    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBars {
      [self.view endEditing:YES];
    DtacPlaySearchViewController* searchView= [[DtacPlaySearchViewController alloc]init];
    searchView.word = searchBars.text;
    searchView.cateID = _cateID;
    if(_inputText != nil)
        searchView.isTagSearch = YES;
    searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\"",searchDisplayController.searchBar.text];
    searchView.isShowMoreButton = YES;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:searchView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 0 ;//searchData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    SearchCategory *temp = searchData[section];
    return temp.objectList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchCell";
    SearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    SearchCategory *itemCate = searchData[indexPath.section];
    SearchItem* s = itemCate.objectList[indexPath.row];
    cell.nameLabel.text = s.title;
    //etc.
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    [searchDisplayController.searchBar resignFirstResponder];
    DtacPlaySearchViewController* searchView= [[DtacPlaySearchViewController alloc]init];
    
    SearchCategory *itemCate = searchData[indexPath.section];
    SearchItem* s = itemCate.objectList[indexPath.row];
    
    searchView.cateID = _cateID;
    searchView.word = searchDisplayController.searchBar.text;
    searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\"",searchDisplayController.searchBar.text];
    searchView.isShowMoreButton = YES;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:searchView animated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
