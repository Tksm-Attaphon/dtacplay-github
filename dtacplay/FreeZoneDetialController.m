//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "FreeZoneDetialController.h"
#import "MyFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "UIColor+Extensions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MusicCell.h"
#import "FreeZoneMusicDetailCell.h"
#import "MusicContent.h"
#import "DtacImage.h"
#import "DtacWebViewViewController.h"
#import "Manager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "Manager.h"
#import "Banner.h"
#import "BannerImage.h"
#import "BannerView.h"
@interface FreeZoneDetialController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate,FreeMusicDelegate>
{
    UIPageControl *pageControl;
    UILabel *title;
    NSMutableArray *recommendArray;
    NSTimer *timer;
    
    UIImageView *imageComming;
    BannerView *bannerView;
}

@end

@implementation FreeZoneDetialController

-(void)viewWillAppear:(BOOL)animated{
    if(!timer)
        timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"alert"
                                                  object:nil];
}


-(void)RecommendLoad{
    recommendArray = [[NSMutableArray alloc]init];
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getMusic\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":6 ,\"suggest\":true}}",(long)self.subcate,1];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            
            for(NSDictionary* temp in content){
                
                MusicContent *preview = [[MusicContent alloc]initWithDictionary:temp];
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
               bannerView.bannerArray = [[Manager sharedManager] bannerArrayDownload];
                
            }
            else{
                
                
                [[Manager sharedManager] setBannerArrayFreezone:bannerArray];
                bannerView.bannerArray = [[Manager sharedManager] bannerArrayFreezone];
                
            }
            [bannerView.carousel reloadData];
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
    
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:FREEZONE withSubCate:self.subcate :self.musicObject.title]}];
    self.navigationItem.title = [Manager getSubcateName:self.subcate withThai:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:[Manager getColorName:self.cate]],
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    
    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"BannerHeader"];
    [_collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:@"RecommendedHeader"];
    [_collectionView registerClass:[MusicCell class] forCellWithReuseIdentifier:@"MusicCell"];
    [_collectionView registerClass:[FreeZoneMusicDetailCell class] forCellWithReuseIdentifier:@"DetailMusicCell"];
    
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
}

-(void)runLoop:(NSTimer*)NSTimer{
    if(bannerView.carousel)
        [bannerView.carousel scrollToItemAtIndex:bannerView.carousel.currentItemIndex+1 animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0){
        if ( IDIOM == IPAD ) {
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size = [[NSString stringWithFormat:@"%@",_musicObject.title] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]  +size.height+20);
        }
        else{
            
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size = [[NSString stringWithFormat:@"%@",_musicObject.title ] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]  +size.height);
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
        
        
        if(!bannerView)
            bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
        bannerView.backgroundColor = [UIColor clearColor];
        //_carousel.
        [headerView addSubview:bannerView];
        
        if(self.cate == DOWNLOAD){
            if([[Manager sharedManager] bannerArrayDownload]){
                bannerView.bannerArray =  [[Manager sharedManager]bannerArrayDownload];
            }
            else{
                bannerView.bannerArray =  [[Manager sharedManager]bannerArray];
            }
        }
        else{
            if([[Manager sharedManager] bannerArrayFreezone]){
                bannerView.bannerArray =  [[Manager sharedManager]bannerArrayFreezone];
            }
            else{
                bannerView.bannerArray =  [[Manager sharedManager]bannerArray];
            }
        }
        
        [bannerView.carousel reloadData];
        
        title=[[UILabel alloc] initWithFrame:CGRectMake(10,bannerView.frame.size.height+bannerView.frame.origin.y, self.view.frame.size.width-20, 30)];
        if ( IDIOM == IPAD ) {
            title=[[UILabel alloc] initWithFrame:CGRectMake(10,bannerView.frame.size.height+bannerView.frame.origin.y, self.view.frame.size.width-20, 50)];
            
        }
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 0;
        [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20]];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [title setText:[NSString stringWithFormat:@"%@",_musicObject.title ]];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [title.text boundingRectWithSize:CGSizeMake(title.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
        
        if (size.height > title.bounds.size.height) {
            
            [title setFrame:CGRectMake(10,bannerView.frame.size.height+bannerView.frame.origin.y, self.view.frame.size.width-20, size.height)];
            if ( IDIOM == IPAD ) {
                [title setFrame:CGRectMake(10,bannerView.frame.size.height+bannerView.frame.origin.y, self.view.frame.size.width-20, size.height)];
                
            }
            
        }
        
        [headerView addSubview:title];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, title.frame.size.height+title.frame.origin.y, self.view.frame.size.width-20, 1 )];
        [line setBackgroundColor:[UIColor colorWithHexString:[Manager getColorName:self.cate]]];
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
        NSString *identify = @"DetailMusicCell";
        FreeZoneMusicDetailCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.parentView = self;
        cell.music = self.musicObject;
        [cell setSocialItem];
        cell.delegate = self;
        [cell setUserInteractionEnabled:YES];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:_musicObject.images.imageThumbnailXL]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    cell.imageView.image = image;
                                }
                            }];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [_musicObject.title boundingRectWithSize:CGSizeMake(cell.nameMusicLabel.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
        
        
        [cell.nameMusicLabel setFrame:CGRectMake(cell.nameMusicLabel.frame.origin.x,cell.nameMusicLabel.frame.origin.y, cell.nameMusicLabel.frame.size.width, size.height)];
        
        
        
        [cell.nameMusicLabel setText:_musicObject.title];
        
        // _musicObject.artist = [NSString stringWithFormat:@"ศิลปิน: %@",_musicObject.artist];
        size = [[NSString stringWithFormat:@"ศิลปิน: %@",_musicObject.artist] boundingRectWithSize:CGSizeMake(cell.nameArtistLabel.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12], NSParagraphStyleAttributeName : style} context:nil].size;
        
        
        
        [cell.nameArtistLabel setFrame:CGRectMake(cell.nameArtistLabel.frame.origin.x,cell.nameMusicLabel.frame.origin.y+cell.nameMusicLabel.frame.size.height+5, cell.nameArtistLabel.frame.size.width, size.height)];
        
        
        
        [cell.imageView setBackgroundColor:[UIColor clearColor]];
        [cell.nameArtistLabel setText:[NSString stringWithFormat:@"ศิลปิน: %@",_musicObject.artist]];
        
        //  _musicObject.album = [NSString stringWithFormat:@"อัลบั้ม: %@", _musicObject.album];
        size = [[NSString stringWithFormat:@"อัลบั้ม: %@", _musicObject.album] boundingRectWithSize:CGSizeMake(cell.nameAlbumLabel.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12], NSParagraphStyleAttributeName : style} context:nil].size;
        
        
        [cell.nameAlbumLabel setFrame:CGRectMake(cell.nameAlbumLabel.frame.origin.x,cell.nameArtistLabel.frame.origin.y+cell.nameArtistLabel.frame.size.height, cell.nameAlbumLabel.frame.size.width, size.height)];
        
        
        
        [cell.nameAlbumLabel setText: [NSString stringWithFormat:@"อัลบั้ม: %@", _musicObject.album]];
        
        [cell.downloadLabel setFrame:CGRectMake(cell.downloadLabel.frame.origin.x, cell.nameAlbumLabel.frame.origin.y+cell.nameAlbumLabel.frame.size.height+20, cell.downloadLabel.frame.size.width, cell.downloadLabel.frame.size.height)];
        if(self.cate != FREEZONE)
            [cell.downloadLabel setTextColor:[UIColor colorWithHexString:COLOR_DOWNLOAD]];
        
        [cell.ringbackLabel setFrame:CGRectMake(cell.ringbackLabel.frame.origin.x+10, cell.downloadLabel.frame.origin.y+cell.downloadLabel.frame.size.height+5, cell.ringbackLabel.frame.size.width, cell.ringbackLabel.frame.size.height)];
        [cell.icon setCenter:CGPointMake(cell.icon.center.x, cell.ringbackLabel.center.y)];
        
        if(!imageComming && (_musicObject.rbt == nil || [_musicObject.rbt isEqualToString:@""])){
            imageComming = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comingsoon"]];
            [imageComming setFrame:CGRectMake(cell.ringbackLabel.frame.size.width+cell.ringbackLabel.frame.origin.x+10, cell.ringbackLabel.frame.origin.y, 50, 32 )];
            [cell addSubview:imageComming];
            
            [cell.ringbackLabel setUserInteractionEnabled:NO];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        return cell;
    }
    MusicContent *temp = recommendArray[indexPath.row];
    NSString *identify = @"MusicCell";
    MusicCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
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
    
    
    [cell.nameMusicLabel setText:temp.title];
    [cell.imageView setBackgroundColor:[UIColor clearColor]];
    [cell.nameArtistLabel setText:temp.artist];
    [cell.nameAlbumLabel setText:temp.album];
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
    float w_1 = (self.view.frame.size.width/2 -15);
    float w_1_ipad = (self.view.frame.size.width/2 -30);
    if(indexPath.section == 1){
        if ( IDIOM == IPAD ) {
            
            return CGSizeMake(w_1_ipad,w_1_ipad+45);
        }
        
        return CGSizeMake(w_1,w_1+45);
    }
    else{
        
        float height_1,height_2,height_3;
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [_musicObject.title boundingRectWithSize:CGSizeMake( (self.view.frame.size.width-20)*0.8, NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
        
        height_1 = size.height;
        size = [[NSString stringWithFormat:@"ศิลปิน: %@",_musicObject.artist] boundingRectWithSize:CGSizeMake( (self.view.frame.size.width-20)*0.8, NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12], NSParagraphStyleAttributeName : style} context:nil].size;
        
        height_2 = size.height;
        
        size = [[NSString stringWithFormat:@"อัลบั้ม: %@", _musicObject.album]  boundingRectWithSize:CGSizeMake( (self.view.frame.size.width-20)*0.8, NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 14 : 12], NSParagraphStyleAttributeName : style} context:nil].size;
        
        height_3 = size.height;
        
        
        return CGSizeMake(self.view.frame.size.width-20, (self.view.frame.size.width-20)*0.8+height_1+height_2+height_3+140);
        
    }
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1){
        MusicContent *preview = recommendArray[indexPath.row];
        
        
        [self getMusicByID:preview.musicID];
    }
}

-(void)onTouchRingBack:(MusicContent *)music{
    NSString *phoneWeb = URL_GET_PHONE_NUMBER;
    NSURL *phoneUrl = [NSURL URLWithString:phoneWeb];
    NSError *error;
    NSString *phoneNumber = [NSString stringWithContentsOfURL:phoneUrl
                                                     encoding:NSASCIIStringEncoding
                                                        error:&error];
    
    [[Manager sharedManager] setPhoneNumber:phoneNumber];
    if(phoneNumber.length > 0){
        
        DtacWebViewViewController *webViewDtac = [[DtacWebViewViewController alloc]init];
        webViewDtac.url = [NSURL URLWithString:music.rbt ];
        webViewDtac.themeColor = [UIColor colorWithHexString:[Manager getColorName:self.cate]];
        webViewDtac.titlePage = music.title;
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@" "
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:newBackButton];
        [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
        [self.navigationController pushViewController:webViewDtac animated:YES];
    }
    else{
        switch (self.subcate) {
            case FREEZONE_MUSIC:
                [self showAlertFreezone];
                break;
                
            default:
                [self showAlertDownload];
                break;
        }
    }
    
}
-(void)showAlertFreezone{
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ท่านสามารถดาวน์โหลดคอนเทนต์ฟรีผ่านโทรศัพท์มือถือบนเครือข่าย dtac (4G/3G/EDGE)" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ท่านสามารถดาวน์โหลดคอนเทนต์ฟรีผ่านโทรศัพท์มือถือบนเครือข่าย dtac (4G/3G/EDGE)" message:@"" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}
-(void)showAlertDownload{
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ท่านสามารถดาวน์โหลดคอนเทนต์ผ่านโทรศัพท์มือถือบนเครือข่าย dtac (4G/3G/EDGE)" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ท่านสามารถดาวน์โหลดคอนเทนต์ผ่านโทรศัพท์มือถือบนเครือข่าย dtac (4G/3G/EDGE)" message:@"" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}

@end
