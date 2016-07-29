//
//  DtacPlaySearchViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 12/2/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "DtacPlaySearchViewController.h"
#import "SearchPreviewTableViewCell.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "Banner.h"
#import "BannerImage.h"
#import "Manager.h"
#import "SearchItem.h"
#import "SearchCategory.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "NewsDetailViewController.h"
#import "EntertainmentDetailViewController.h"
#import "HoroViewController.h"
#import "ArticleViewController.h"
#import "MBProgressHUD.h"
#import "ApplicationFreeViewController.h"
#import "MusicContent.h"
#import "AppContent.h"
#import "FreeZoneDetialController.h"
#import "GameDetailViewController.h"
#import "GameContent.h"
#import "ShoppingItem.h"
#import "ShoppingDetailViewController.h"
#import "PromotionDetailViewController.h"
#import "SVPullToRefresh.h"
#import "SportDetailViewController.h"
#import "BannerView.h"
@interface DtacPlaySearchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIPageControl *pageControl;
    NSTimer *timer;
    NSMutableArray *searchData;
    int page;
    UILabel* showDescLabel;
    
    BannerView *bannerView;
}
@end

@implementation DtacPlaySearchViewController
-(void)viewWillAppear:(BOOL)animated{
    if(!timer)
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
}

-(void)refreshPage{
    page++;
    NSString *     jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTitle\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"page\":%d,\"limit\":12}}",_cateID,_word,page];
    
    if(self.isTagSearch == YES){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTag\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"page\":%d,\"limit\":12}}",_cateID,_word,page];
    }
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            
            NSArray *list =[result objectForKey:@"contents"] ;
            if(searchData.count==1){
                SearchCategory *search = searchData[0];
            
            for(NSDictionary* obj in list){
                SearchItem* item = [[SearchItem alloc]initWithDictionary:obj];
                [search.objectList addObject:item];
            }

            }
            
        }
        else{
            _searchTable.showsInfiniteScrolling = NO;
            page --;
        }
        
        [_searchTable.infiniteScrollingView stopAnimating];
        
        [_searchTable reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        
        [_searchTable.infiniteScrollingView stopAnimating];
        page--;
    }];
    [op start];
    
}

-(void)getSearchList:(NSString*)word{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTitleCate\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"limit\":10}}",_cateID,word];
    
    if(self.isTagSearch == YES){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTagCate\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"limit\":10}}",_cateID,word];
    }
    
    if(_isShowMoreButton==NO){
         jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTitle\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"page\":1,\"limit\":12}}",_cateID,word];
        if(self.isTagSearch == YES){
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"searchTag\", \"params\":{\"cateId\":%d,\"keyword\":\"%@\",\"page\":1,\"limit\":12}}",_cateID,word];
        }
    }
    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSMutableArray *tempList = [[NSMutableArray alloc]init];
        if ([responseObject objectForKey:@"result"]) {
            
            NSDictionary *content =[responseObject objectForKey:@"result"] ;
            if(![content isEqual:[NSNull null]]){
                
                if(_isShowMoreButton==YES){
                NSArray *list =[content objectForKey:@"categories"] ;
                
                for (NSDictionary *item in list){
                    SearchCategory *search = [[SearchCategory alloc]initWithDictionary:item];
                    [tempList addObject:search];
                }
                }
                else{
                    NSArray *list =[content objectForKey:@"contents"] ;
                     SearchCategory *search = [[SearchCategory alloc]init];
                    search.cateID = _cateID;
                    [tempList addObject:search];
                    
                    search.objectList = [[NSMutableArray alloc]init];
                    for(NSDictionary* obj in list){
                        SearchItem* item = [[SearchItem alloc]initWithDictionary:obj];
                        [search.objectList addObject:item];
                    }
                }
            }
            else{
                [showDescLabel setText:[NSString stringWithFormat:@"ไม่พบข้อมูลเกี่ยวกับ \"%@\"",_word ]];
            }
        }
        else{
            [showDescLabel setText:[NSString stringWithFormat:@"ไม่พบข้อมูลเกี่ยวกับ \"%@\"",_word ]];
        }
        searchData = tempList;
        
        [self.searchTable reloadData];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
        //[[Manager sharedManager] showErrorAlert:self];
    }];
    [op start];
    
    
    
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if(_cateID == 0){
        _cateID = 1;
    }
    // Do any additional setup after loading the view.
    [self.searchTable setBackgroundColor:[UIColor whiteColor]];
     self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];

    
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setFrame:CGRectMake(0, 0, 65, 30)];
    self.navigationItem.titleView = image;
    
    page = 1;
    [self getSearchList:_word];
    _searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStylePlain];
    [_searchTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _searchTable.dataSource = self;
    _searchTable.delegate = self;
    [_searchTable registerClass:[SearchPreviewTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_searchTable];
    
    if(_isShowMoreButton==NO){
        __weak DtacPlaySearchViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [_searchTable addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight]+30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    if(!bannerView)
        bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
    bannerView.backgroundColor = [UIColor clearColor];
    //_carousel.
    [headerView addSubview:bannerView];
    
 
    bannerView.bannerArray =  [[Manager sharedManager]bannerArray];
    
    [bannerView.carousel reloadData];
    
    showDescLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, [[Manager sharedManager]bannerHeight]+10,self.view.frame.size.width-20, 25)];
    showDescLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [showDescLabel setText:_descriptionWord];
    [showDescLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
    [showDescLabel setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM == IPAD ? 18 : 16]];
    [headerView addSubview:showDescLabel];
    self.searchTable.tableHeaderView = headerView;
}
- (void)insertRowAtTop {
    
    __weak DtacPlaySearchViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshPage];
        [weakSelf.searchTable.infiniteScrollingView stopAnimating];
        
    });
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIColor *color;
    NSString *titleHeader;
    UIImage *imageIcon;
    UIImage *imageMore;
    //  NSString *header;
    SearchCategory* temp = searchData[section];
  
    switch (temp.cateID) {
        case NEWS:
            titleHeader = [Manager getCateName:NEWS withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_news"];
             imageMore = [UIImage imageNamed:@"dtacplay_home_more_news"];
              color = [UIColor colorWithHexString:COLOR_NEWS];
            break;
        case ENTERTAINMENT:
            titleHeader = [Manager getCateName:ENTERTAINMENT withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_entertainment"];
             imageMore = [UIImage imageNamed:@"dtacplay_home_more_entertainment"];
              color = [UIColor colorWithHexString:COLOR_ENTERTAINMENT];
            break;
        case PROMOTION:
            titleHeader = [Manager getCateName:PROMOTION withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_promotion"];
             imageMore = [UIImage imageNamed:@"dtacplay_home_more_promotion"];
              color = [UIColor colorWithHexString:COLOR_PROMOTION];
            break;
        case LIFESTYLE:
            titleHeader = [Manager getCateName:LIFESTYLE withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_lifestyle"];
             imageMore = [UIImage imageNamed:@"dtacplay_home_more_lifestyle"];
              color = [UIColor colorWithHexString:COLOR_LIFESTYLE];
            break;
        case FREEZONE:
            titleHeader = [Manager getCateName:FREEZONE withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_freezone"];
             imageMore = [UIImage imageNamed:@"dtacplay_home_more_freezone"];
              color = [UIColor colorWithHexString:COLOR_FREEZONE];
            break;
        case SHOPPING:
            titleHeader = [Manager getCateName:SHOPPING withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_shopping"];
             imageMore = [UIImage imageNamed:@"dtacplay_home_more_shopping"];
              color = [UIColor colorWithHexString:COLOR_SHOPPING];
            break;
        case DOWNLOAD:
            titleHeader = [Manager getCateName:DOWNLOAD withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_download"];
            imageMore = [UIImage imageNamed:@"dtacplay_home_more_download"];
            color = [UIColor colorWithHexString:COLOR_DOWNLOAD];
            break;
        case SPORT:
            titleHeader = [Manager getCateName:SPORT withThai:YES];
            imageIcon = [UIImage imageNamed:@"dtacplay_home_sport"];
            imageMore = [UIImage imageNamed:@"dtacplay_home_more_sport"];
            color = [UIColor colorWithHexString:COLOR_SPORT];
            break;
        default:
            titleHeader = @"UNKNOW";
            //imageIcon = [UIImage imageNamed:@"dtacplay_home_shopping"];
            //imageMore = [UIImage imageNamed:@"dtacplay_home_more_shopping"];
            color = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            break;
    }
    
   
    
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    
    
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    //header
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,5, tableView.frame.size.width-20, 1)];
    [line setBackgroundColor:color];
    
    [headerView addSubview:line];
    
    UIImageView* circle = [[UIImageView alloc]initWithFrame:CGRectMake(10, line.frame.origin.y+5, 30, 30)];
    [circle setImage:imageIcon];
    [headerView addSubview:circle];

    if(_isShowMoreButton==YES && temp.objectList.count >=10){
    UIButton* circleMore = [[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-40, line.frame.origin.y+5, 30, 30)];
    [circleMore setImage:imageMore forState:UIControlStateNormal];
    [headerView addSubview:circleMore];
    circleMore.tag = temp.cateID;
    [circleMore addTarget:self action:@selector(goMoreSearch:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(circle.frame.size.width+20, line.frame.origin.y+5,tableView.frame.size.width-50, 35)];
    [label setText:titleHeader];
    [label setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IPAD==IDIOM ? 18 : 16]];
    [label setTextColor:color];
    [headerView addSubview:label];
    
    
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return searchData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchCategory *temp = searchData[section];
    return temp.objectList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    SearchPreviewTableViewCell *cell = (SearchPreviewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[SearchPreviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    SearchCategory *cateSearch = searchData[indexPath.section];
    SearchItem *obj = cateSearch.objectList[indexPath.row];
    // Configure the cell...
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: cell.titleLabel.attributedText];
    
    switch (cateSearch.cateID) {
        case NEWS:
            switch (obj.subCateID) {
                case NEWS_FINANCE:
                     cell.titleLabel.text = [NSString stringWithFormat:@"(การเงิน) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_NEWS]
                                 range:NSMakeRange(0, 9)];
                    break;
                case NEWS_HOT_NEWS:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(ข่าวเด่น) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_NEWS]
                                 range:NSMakeRange(0, 10)];
                    break;
                case NEWS_INTER_NEWS:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(ต่างประเทศ) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_NEWS]
                                 range:NSMakeRange(0, 12)];
                    break;
                case NEWS_TECHNOLOGY:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(ไอที) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_NEWS]
                                 range:NSMakeRange(0, 6)];
                    break;
                case NEWS_LOTTO:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(ข่าวเด็ดเลขดัง) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_NEWS]
                                 range:NSMakeRange(0, 16)];
                    break;
                default:
                    break;
            }
           
            
            [cell.titleLabel setAttributedText: text];
            break;
        case ENTERTAINMENT:
            
            switch (obj.subCateID) {
                case ENTERTAINMENT_NEWS:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(ข่าวบันเทิง) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_ENTERTAINMENT]
                                 range:NSMakeRange(0,13)];
                    break;
                case ENTERTAINMENT_VIDEO:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(วีดีโอ) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_ENTERTAINMENT]
                                 range:NSMakeRange(0, 8)];
                    break;
                default:
                    break;
            }
           
            [cell.titleLabel setAttributedText: text];
            break;
        case PROMOTION:
            cell.titleLabel.text = [NSString stringWithFormat:@"(โปรโมชั่น) %@",obj.title];
           text =
            [[NSMutableAttributedString alloc]
             initWithAttributedString: cell.titleLabel.attributedText];
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:COLOR_PROMOTION]
                         range:NSMakeRange(0, 11)];
            [cell.titleLabel setAttributedText: text];
            break;
        case LIFESTYLE:
            switch (obj.subCateID) {
                case LIFESTYLE_TRAVEL:
                     cell.titleLabel.text = [NSString stringWithFormat:@"(ท่องเที่ยว) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_LIFESTYLE]
                                 range:NSMakeRange(0, 12)];
                    break;
                case LIFESTYLE_RESTAURANT:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(ร้านอาหาร) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_LIFESTYLE]
                                 range:NSMakeRange(0, 11)];
                    break;
                case LIFESTYLE_HOROSCOPE:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(ดวง) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_LIFESTYLE]
                                 range:NSMakeRange(0, 5)];
                    break;
                default:
                    break;
            }
           
           
            [cell.titleLabel setAttributedText: text];
            break;
        case DOWNLOAD:
            switch (obj.subCateID) {
                case DOWNLOAD_GAME_GAMECLUB:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เกมคลับ) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 9)];
                    break;
                case DOWNLOAD_GAME_GAMEROOM:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เกมรูม) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 8)];
                    break;
                case DOWNLOAD_GAME_HIT:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เกมฮิต) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 8)];
                    break;
                case DOWNLOAD_GAME_NEW:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เกมใหม่) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 9)];
                    break;
                case DOWNLOAD_MUSIC_HIT:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เพลงฮิตติดชาร์ท) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 16)];
                    break;
                case DOWNLOAD_MUSIC_INTER:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เพลงอินเตอร์สุดฮอต) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 20)];
                    break;
                case DOWNLOAD_MUSIC_LOOKTHOONG:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เพลงลูกทุ่งโดนใจ) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 18)];
                    break;
                case DOWNLOAD_MUSIC_NEW:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เพลงใหม่) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_DOWNLOAD]
                                 range:NSMakeRange(0, 10)];
                    break;
                default:
                    break;
            }
            
            
            [cell.titleLabel setAttributedText: text];
            break;
        case FREEZONE:
            switch (obj.subCateID) {
                case FREEZONE_APPLICATION:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(DTAC APPLICATION) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_FREEZONE]
                                 range:NSMakeRange(0, 18)];
                    break;
                case FREEZONE_GAME:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เกมฟรี) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_FREEZONE]
                                 range:NSMakeRange(0, 10)];
                    break;
                case FREEZONE_MUSIC:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(เพลงฟรี) %@",obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_FREEZONE]
                                 range:NSMakeRange(0, 9)];
                    break;
                default:
                    break;
            }
            
           
            [cell.titleLabel setAttributedText: text];
            break;
        case SPORT:
            switch (obj.subCateID) {
                case SPORT_NEWS:
                    cell.titleLabel.text = [NSString stringWithFormat:@"(%@) %@",[Manager getSubcateName:SPORT_NEWS withThai:YES],obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_SPORT]
                                 range:NSMakeRange(0, [Manager getSubcateName:SPORT_NEWS withThai:YES].length+2)];
                    break;
                case SPORT_INTER_FOOTBALL:
                   cell.titleLabel.text = [NSString stringWithFormat:@"(%@) %@",[Manager getSubcateName:SPORT_NEWS withThai:YES],obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_SPORT]
                                 range:NSMakeRange(0, [Manager getSubcateName:SPORT_NEWS withThai:YES].length+2)];
                    break;
                case SPORT_THAI_FOOTBALL:
                   cell.titleLabel.text = [NSString stringWithFormat:@"(%@) %@",[Manager getSubcateName:SPORT_NEWS withThai:YES],obj.title];
                    text =
                    [[NSMutableAttributedString alloc]
                     initWithAttributedString: cell.titleLabel.attributedText];
                    [text addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithHexString:COLOR_SPORT]
                                 range:NSMakeRange(0, [Manager getSubcateName:SPORT_NEWS withThai:YES].length+2)];
                    break;
                default:
                    break;
            }
            
            
            [cell.titleLabel setAttributedText: text];
            break;

        case SHOPPING:
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",obj.title];
//             text =
//            [[NSMutableAttributedString alloc]
//             initWithAttributedString: cell.titleLabel.attributedText];
//            [text addAttribute:NSForegroundColorAttributeName
//                         value:[UIColor colorWithHexString:COLOR_SHOPPING]
//                         range:NSMakeRange(0, 10)];
//            [cell.titleLabel setAttributedText: text];
            break;
        default:
            
            break;
    }
 
    if(obj.descriptionContent != nil){
        cell.detailLabel.text = obj.descriptionContent;
    }
    else{
        cell.detailLabel.text = @"ไม่มีคำอธิบาย";
 
    }
    
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCategory *cateSearch = searchData[indexPath.section];
    SearchItem *obj = cateSearch.objectList[indexPath.row];
  
    if(cateSearch.cateID == NEWS){
          NSString *contentID = [NSString stringWithFormat:@"%d",obj.conID];
        NewsDetailViewController *articleView= [[NewsDetailViewController alloc]init];
        
        articleView.titlePage =  @"ข่าว";
        articleView.themeColor = [UIColor colorWithHexString:COLOR_NEWS];
        articleView.pageType = NEWS;

        articleView.contentID = contentID;
        articleView.pageType =obj.cateID;
        
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];

    }
    else if(cateSearch.cateID == ENTERTAINMENT){
          NSString *contentID = [NSString stringWithFormat:@"%d",obj.conID];
        EntertainmentDetailViewController *articleView= [[EntertainmentDetailViewController alloc]init];
        
        articleView.titlePage =  @"บันเทิง";
        articleView.themeColor = [UIColor colorWithHexString:COLOR_ENTERTAINMENT];
        articleView.pageType = NEWS;
        
        articleView.contentID = contentID;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];

    }
    else if(cateSearch.cateID == LIFESTYLE){
  NSString *contentID = [NSString stringWithFormat:@"%d",obj.conID];
       
            ArticleViewController *articleView= [[ArticleViewController alloc]init];
            articleView.titlePage =  @"ไลฟ์สไตล์";
            articleView.themeColor = [UIColor colorWithHexString:COLOR_LIFESTYLE];
            articleView.pageType = LIFESTYLE;
            articleView.subCateType = obj.subCateID;
            articleView.contentID =contentID;
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];

    }
    else if(cateSearch.cateID == SPORT){
         NSString *contentID = [NSString stringWithFormat:@"%d",obj.conID];
        SportDetailViewController* articleView= [[SportDetailViewController alloc]init];

        articleView.contentID = contentID;
        articleView.pageType = SPORT;
        articleView.themeColor = [UIColor colorWithHexString:COLOR_LIFESTYLE];
        
        
        articleView.titlePage = [Manager getCateName:SPORT withThai:YES];
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        [self.navigationController pushViewController:articleView animated:YES];
    }
    else if(cateSearch.cateID == PROMOTION){
//        PromotionDetailViewController* detail= [[PromotionDetailViewController alloc]init];
//        
//        if(prom.link){
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:prom.link]];
//        }
//        else{
//            detail.contentID = prom.contentID;
//            UIBarButtonItem *newBackButton =
//            [[UIBarButtonItem alloc] initWithTitle:@" "
//                                             style:UIBarButtonItemStyleBordered
//                                            target:nil
//                                            action:nil];
//            [self.parentView.navigationItem setBackBarButtonItem:newBackButton];
//            self.parentView.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
//            [self.parentView.navigationController pushViewController:detail animated:YES];
//        }
    }
    else if(cateSearch.cateID == FREEZONE){
         // NSString *contentID = ;
        if(obj.subCateID == FREEZONE_MUSIC){// music
            [self getMusicByID:[NSString stringWithFormat:@"%d",obj.musicID]];
            
        }
        else if(obj.subCateID == FREEZONE_APPLICATION){
            [self getAppByID:[NSString stringWithFormat:@"%d",obj.appID]];
        }
        else{
            [self getGameByID:[NSString stringWithFormat:@"%d",obj.gameID]];
        }
    }
    else if(cateSearch.cateID == SHOPPING){
         // NSString *contentID = [NSString stringWithFormat:@"%d",obj.conID];
        [self getShoppingByID:[NSString stringWithFormat:@"%d",obj.shoppingID]];
    }
}
-(void)goMoreSearch:(UIButton*)button{
    DtacPlaySearchViewController* searchView= [[DtacPlaySearchViewController alloc]init];

    searchView.word = _word;
    switch (button.tag) {
        case NEWS:
            //titleHeader = @"ข่าว";
            searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > ข่าว",_word];
            break;
        case ENTERTAINMENT:
            //titleHeader = @"บันเทิง";
             searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > บันเทิง",_word];
            break;
        case PROMOTION:
            //titleHeader = @"โปรโมชั่น";
             searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > โปรโมชั่น",_word];
            break;
        case LIFESTYLE:
            //titleHeader = @"ไลฟ์สไตล์";
             searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > ไลฟ์สไตล์",_word];
            break;
        case FREEZONE:
            //titleHeader = @"ฟรีโซน";
           searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > ฟรีโซน",_word];
            break;
        case SHOPPING:
            //titleHeader = @"ช้อปปิ้ง";
            searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > ช้อปปิ้ง",_word];
            break;
        case DOWNLOAD:
            //titleHeader = @"ช้อปปิ้ง";
            searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > ดาวน์โหลด",_word];
            break;
        case SPORT:
            //titleHeader = @"ช้อปปิ้ง";
            searchView.descriptionWord = [NSString stringWithFormat:@"ผลการค้นหา \"%@\" > กีฬา",_word];
            break;
        default:
            break;
    }
    
    searchView.isShowMoreButton = NO;
    searchView.isTagSearch = _isTagSearch;
    searchView.cateID = button.tag;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:searchView animated:YES];
}
-(void)getShoppingByID:(NSString*)shoppingID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getShoppingById\",\"params\":{\"shoppingId\":%@}}",shoppingID];
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            
            
            ShoppingItem* temp_shop = [[ShoppingItem alloc]initWithDictionary:result];
            
            
            ShoppingDetailViewController * articleView= [[ShoppingDetailViewController alloc]init];
            articleView.shoppingItem = temp_shop;
            
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];
            
        }
        
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
}

-(void)getGameByID:(NSString*)ID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGameById\",\"params\":{\"gameId\":%@}}",ID];
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            GameDetailViewController* articleView= [[GameDetailViewController alloc]init];
            
            GameContent *obj = [[GameContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.gameObject = obj;
            articleView.cate = obj.cate;
            articleView.subcate = obj.subcate;
            
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
}


-(void)getAppByID:(NSString*)ID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplicationById\",\"params\":{\"appId\":%@}}",ID];
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            ApplicationFreeViewController* articleView= [[ApplicationFreeViewController alloc]init];
            
            AppContent *obj = [[AppContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.appObject = obj;
            articleView.cate = obj.cate;
            articleView.subcate = obj.subcate;
            
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
}
-(void)getMusicByID:(NSString*)ID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusicById\",\"params\":{\"musicId\":%@}}",ID];
    
    NSString *valueHeader;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            FreeZoneDetialController* articleView= [[FreeZoneDetialController alloc]init];
            
            MusicContent *obj = [[MusicContent alloc]initWithDictionary:[responseObject objectForKey:@"result"] ];
            articleView.musicObject = obj;
            articleView.cate = obj.cate;
            articleView.subcate = obj.subcate;
            
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@" "
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [self.navigationItem setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
            [self.navigationController pushViewController:articleView animated:YES];
        }
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [hud hide:YES];
    }];
    [op start];
    
}



-(void)runLoop:(NSTimer*)NSTimer{
    
    if(bannerView.carousel)
        [bannerView.carousel scrollToItemAtIndex:bannerView.carousel.currentItemIndex+1 animated:YES];
    
    
    
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
