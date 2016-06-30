//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "GameDetailViewController.h"
#import "MyFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "UIColor+Extensions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GameCellLevel2.h"
#import "FreeZoneGameDetailCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "AppCell.h"
#import "GameContent.h"
#import "RTLabel.h"
#import "DtacImage.h"
#import "Manager.h"
#import "DtacWebViewViewController.h"
#import "Banner.h"
#import "BannerImage.h"
@interface GameDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate>
{
    UIPageControl *pageControl;
    UILabel *title;
    float textHeight;
    NSMutableArray *recommendArray;
    NSTimer *timer;
    UIView *gameDetailView;
    
}

@end

@implementation GameDetailViewController

-(void)RecommendLoad{
    recommendArray = [[NSMutableArray alloc]init];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getGame\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":6 ,\"suggest\":true,\"opera\":null}}",(long)self.subcate,1];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            
            for(NSDictionary* temp in content){
                
                GameContent *preview = [[GameContent alloc]initWithDictionary:temp];
                [recommendArray addObject:preview];
                
            }
            
            
        }
        
        
        [self.collectionView reloadData];
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        
    }];
    [op start];
    
}
-(void)getBanner{
    
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdFreezone]];
    
    if(self.cate == DOWNLOAD){
        jsonString =
        [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getSmrtAdsBanner\", \"params\":{\"smrtAdsRefId\":%d}}",[[Manager sharedManager] smrtAdsRefIdDownload]];
        
    }


    NSString *valueHeader;
    
    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSMutableArray *bannerArray = [[NSMutableArray alloc]init];
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            NSArray *temp = [dic objectForKey:@"banners"];
            for (NSDictionary *obj in temp){
                Banner *banner = [[Banner alloc]initWithDictionary:obj];
                [bannerArray addObject:banner];
            }
            
           
            
            if(self.cate == DOWNLOAD){
                
                
                    [[Manager sharedManager] setBannerArrayDownload:bannerArray];
                     pageControl.numberOfPages = [[Manager sharedManager] bannerArrayDownload].count;
                
            }
            else{
                
               
                    [[Manager sharedManager] setBannerArrayFreezone:bannerArray];
                     pageControl.numberOfPages = [[Manager sharedManager] bannerArrayFreezone].count;
                
            }

            
           
            [_carousel reloadData];
            // [self.collectionView reloadData];
        }
        
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self change_server];
    }];
    [op start];
    
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
     [self setCateID:FREEZONE];
    [self RecommendLoad];
    
    
    if(self.cate == DOWNLOAD){
        
        if(![[Manager sharedManager]bannerArrayDownload])
            [self getBanner];
        
    }
    else{
        if(![[Manager sharedManager]bannerArrayFreezone])
            [self getBanner];
        
    }
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:FREEZONE withSubCate:self.subcate :self.gameObject.title]}];
    
    
    self.navigationItem.title = [Manager getSubcateName:self.subcate withThai:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:[Manager getColorName:self.cate]],
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"BannerHeader"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"RecommendedHeader"];
    [_collectionView registerClass:[AppCell class] forCellWithReuseIdentifier:@"GameCell"];
    [_collectionView registerClass:[FreeZoneGameDetailCell class] forCellWithReuseIdentifier:@"DetailGameCell"];
    //            UINib *cellNib = [UINib nibWithNibName:@"BlockCollectionViewCell" bundle:nil];
    //            [fooCollection registerNib:cellNib forCellWithReuseIdentifier:@"BlockCollectionViewCell"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)runLoop:(NSTimer*)NSTimer{
    if(_carousel)
        [_carousel scrollToItemAtIndex:_carousel.currentItemIndex+1 animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0){
        if ( IDIOM == IPAD ) {
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size = [[NSString stringWithFormat:@"%@",_gameObject.title ] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight] +size.height+20);
        }
        else{
            
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size = [[NSString stringWithFormat:@"%@",_gameObject.title ] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight] +size.height);
        }
    }
    else{
        if ( IDIOM == IPAD ) {
            return CGSizeMake( self.view.frame.size.width, 44 );
        }
        else{
            
            
            return CGSizeMake( self.view.frame.size.width, 44);
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                   withReuseIdentifier:@"BannerHeader" forIndexPath:indexPath];
        
        [headerView setBackgroundColor:[UIColor whiteColor]];
        
        _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
        
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeLinear;
        _carousel.backgroundColor = [UIColor clearColor];
        //_carousel.
        [headerView addSubview:_carousel];
        
        
        
        
        // Page Control
        if(!pageControl)
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (self.carousel.frame.size.height-20), self.carousel.frame.size.width, 20.0f)];
        
        if(self.cate == DOWNLOAD){
            
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayDownload].count >0  ? [[Manager sharedManager] bannerArrayDownload].count : [[Manager sharedManager] bannerArray].count;
            
        }
        else{
            
            pageControl.numberOfPages = [[Manager sharedManager] bannerArrayFreezone].count >0  ? [[Manager sharedManager] bannerArrayFreezone].count : [[Manager sharedManager] bannerArray].count;
            
        }
        
        
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
        pageControl.userInteractionEnabled = NO;
        [_carousel addSubview:pageControl];
        [timer invalidate];
        timer = nil;
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
        title=[[UILabel alloc] initWithFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y, self.view.frame.size.width-20, 30)];
        if ( IDIOM == IPAD ) {
            title=[[UILabel alloc] initWithFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y, self.view.frame.size.width-20, 50)];
            
        }
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 0;
        [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20]];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setTextColor:[UIColor colorWithHexString:[Manager getColorName:self.cate]]];
        [title setText:[NSString stringWithFormat:@"%@",_gameObject.title ]];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [title.text boundingRectWithSize:CGSizeMake(title.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
        
        if (size.height > title.bounds.size.height) {
            
            [title setFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y, self.view.frame.size.width-20, size.height)];
            if ( IDIOM == IPAD ) {
                [title setFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y, self.view.frame.size.width-20, size.height)];
                
            }
            
        }
        
        [headerView addSubview:title];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, title.frame.size.height+title.frame.origin.y, self.view.frame.size.width-20, 1 )];
        [line setBackgroundColor:[UIColor colorWithHexString:@"9f064f"]];
        [headerView addSubview:line];
        
        
        return headerView;
        
    }
    else  if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1) {
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                   withReuseIdentifier:@"RecommendedHeader" forIndexPath:indexPath];
        
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,0, self.view.frame.size.width-20, 1)];
        [line setBackgroundColor:[UIColor colorWithHexString:[Manager getColorName:self.cate]]];
        [headerView addSubview:line];
        UILabel *titleReccommend=[[UILabel alloc] initWithFrame:CGRectMake(10,0, self.view.frame.size.width-20, 44)];
        if ( IDIOM == IPAD ) {
            titleReccommend=[[UILabel alloc] initWithFrame:CGRectMake(10,0, self.view.frame.size.width-20, 44)];
            
        }
        titleReccommend.lineBreakMode = NSLineBreakByWordWrapping;
        titleReccommend.numberOfLines = 0;
        [titleReccommend setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20]];
        [titleReccommend setBackgroundColor:[UIColor clearColor]];
        [titleReccommend setTextColor:[UIColor colorWithHexString:[Manager getColorName:self.cate]]];
          [titleReccommend setText:[NSString stringWithFormat:@"%@เเนะนำ",[Manager getSubcateName:self.subcate withThai:YES]]];
        
        
        
        [headerView addSubview:titleReccommend];
        
        return headerView;
        
    }
    return reusableview;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    return recommendArray.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,10,10);
    return inset;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        //DetailMusicCell
        NSString *identify = @"DetailGameCell";
        FreeZoneGameDetailCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:_gameObject.images.imageThumbnailXL]
             
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        cell.imageView.image = image;
                                    }
                                }];
        }
        else{
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:_gameObject.images.imageThumbnailXL]
             
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        cell.imageView.image = image;
                                    }
                                }];
        }
        cell.parentView = self;
        cell.game = _gameObject;
        [cell setSocialItem];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [_gameObject.title boundingRectWithSize:CGSizeMake(cell.titleLabel.frame.size.width, NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
        
        [cell.titleLabel setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y,  cell.titleLabel.frame.size.width, size.height)];
        
        [cell.titleLabel setText:_gameObject.title];
        [cell.imageView setBackgroundColor:[UIColor blackColor]];
        [cell.detailLabel setText:_gameObject.descriptionContent];
        // NSLog(@"width  ; %f cell ; %f",cell.detailLabel.frame.size.width ,cell.detailLabel.optimumSize.height);
        [cell.detailLabel setFrame:CGRectMake(cell.detailLabel.frame.origin.x, cell.titleLabel.frame.origin.y+cell.titleLabel.frame.size.height+10, cell.detailLabel.frame.size.width, cell.detailLabel.optimumSize.height)];
        [cell.downloadLabel setFrame:CGRectMake(cell.downloadLabel.frame.origin.x,cell.detailLabel.frame.origin.y+ cell.detailLabel.frame.size.height+20, cell.downloadLabel.frame.size.width, cell.downloadLabel.frame.size.height)];
        //_link	__NSCFString *	@"https://itunes.apple.com/th/app/smash-hit/id603527166?mt=8&uo=2"	0x000000012dec74e0
        
        if ([_gameObject.link rangeOfString:@"itunes.apple.com"].location == NSNotFound) {
            [cell.downloadLabel setImage:[UIImage imageNamed:@"dtacplay_download"] forState:UIControlStateNormal];
        } else {
            [cell.downloadLabel setImage:[UIImage imageNamed:@"dtacplay_appstore"] forState:UIControlStateNormal];
        }
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(clickDownload:)];
        [cell.downloadLabel addGestureRecognizer:singleFingerTap];
        [cell.downloadLabel setUserInteractionEnabled:YES];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        return cell;
    }
    
    GameContent *temp = recommendArray[indexPath.row];
    NSString *identify = @"GameCell";
    AppCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:temp.images.imageThumbnailXL]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    cell.imageView.image = image;
                                }
                            }];
  
    
    [cell.title setText:temp.title];
    [cell.imageView setBackgroundColor:[UIColor blackColor]];
    
    [cell.desc setText:temp.descriptionContent];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.layer.shadowRadius = 2;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [cell setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        
        return CGSizeMake(self.view.frame.size.width/2-15,self.view.frame.size.width/2-15+ 45);
    }
    else{
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [_gameObject.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width*0.8, NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
        float titleHeight = size.height;
        
        
        RTLabel *textView = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, 1000)];
        
        textView.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = YES;
        // UIFont *test = textView.font;//time news roman 12 pixel
        [textView setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 14: 12]];
        textView.tag =80;
        [textView setText:_gameObject.descriptionContent];
        //textView.text = para.descriptionContent;
        [textView setNeedsDisplay];
        
        [textView setFrame:CGRectMake(0, 0, textView.frame.size.width, textView.optimumSize.height)];
        
        textHeight = titleHeight+textView.frame.size.height;
        
        //  NSLog(@"width : %f size ; %f",self.view.frame.size.width*0.8,textView.optimumSize.height);
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*0.8 + textHeight+20+40+60+20);
        
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //...
    if(indexPath.section==1){
        
        GameContent*temp =  recommendArray[indexPath.row];
        [self getGameByID:temp.gameID];
    }
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
            
            articleView.subcate = self.subcate;
            articleView.cate = self.cate;
            
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

-(void)clickDownload:(id)gesture{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_gameObject.link]];
    
    //        DtacWebViewViewController *webViewDtac = [[DtacWebViewViewController alloc]init];
    //        webViewDtac.url = [NSURL URLWithString:_gameObject.link ];
    //        webViewDtac.themeColor = [UIColor colorWithHexString:[Manager getColorName:self.cate]];
    //        webViewDtac.titlePage = _gameObject.title;
    //        UIBarButtonItem *newBackButton =
    //        [[UIBarButtonItem alloc] initWithTitle:@" "
    //                                         style:UIBarButtonItemStyleBordered
    //                                        target:nil
    //                                        action:nil];
    //        [self.navigationItem setBackBarButtonItem:newBackButton];
    //        [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    //        [self.navigationController pushViewController:webViewDtac animated:YES];
    //
    
}
#pragma mark - Height Calculation Method
- (CGFloat)findHeightForText:(NSString *)text havingMaximumWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        NSDictionary *attributes = @{NSFontAttributeName: font};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        
        
        size = CGSizeMake(rect.size.width, rect.size.height + 1);
    }
    return size.height;
}



#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if(self.cate == DOWNLOAD){
        if([[Manager sharedManager] bannerArrayDownload]){
            return [[Manager sharedManager]bannerArrayDownload].count;
        }
        else{
            return [[Manager sharedManager]bannerArray].count;
        }
    }
    else{
        if([[Manager sharedManager] bannerArrayFreezone]){
            return [[Manager sharedManager]bannerArrayFreezone].count;
        }
        else{
            return [[Manager sharedManager]bannerArray].count;
        }
    }
   
}
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return 4;
}
- (void)scrollToItemAtIndex:(NSInteger)index
                   duration:(NSTimeInterval)scrollDuration{
    
    
}
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    //NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
    pageControl.currentPage = self.carousel.currentItemIndex;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *viewsImage = [[UIImageView alloc] initWithFrame:_carousel.frame];
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    
    
    if(self.cate == DOWNLOAD){
        
        if([[Manager sharedManager] bannerArrayDownload]){
            temp  = [[Manager sharedManager] bannerArrayDownload ][index];
        }
    }
    else{
        
        if([[Manager sharedManager] bannerArrayFreezone]){
            temp  = [[Manager sharedManager] bannerArrayFreezone ][index];
        }
    }
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:temp.images.image_r1]
                       
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                viewsImage.image = image;
                            }
                            
                            
                            
                        }];
    
    [viewsImage setContentMode:UIViewContentModeScaleToFill];
    return viewsImage;
    
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    
    if(self.cate == DOWNLOAD){
        
        if([[Manager sharedManager] bannerArrayDownload]){
            temp  = [[Manager sharedManager] bannerArrayDownload ][index];
        }
    }
    else{
        
        if([[Manager sharedManager] bannerArrayFreezone]){
            temp  = [[Manager sharedManager] bannerArrayFreezone ][index];
        }
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return NO;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}


@end
