//
//  FreeZoneDetialController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ApplicationFreeViewController.h"
#import "MyFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "UIColor+Extensions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GameCellLevel2.h"
#import "FreeZoneAppDetailCell.h"
#import "RTLabel.h"
#import "DtacImage.h"
#import "DtacWebViewViewController.h"
#import "Manager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "AppCell.h"
#import "Manager.h"
#import "ShowImageViewController.h"
#import "Banner.h"
#import "BannerImage.h"
#import "BannerView.h"
@interface ApplicationFreeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate,ImageShowCaseDelegate>
{
    UIPageControl *pageControl;
    UILabel *title;
    float textHeight;
    NSMutableArray *recommendArray;
    float h_collecitonView;
    NSTimer *timer;
     BannerView *bannerView;
}

@end

@implementation ApplicationFreeViewController

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
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getApplication\",\"params\":{\"subCateId\":%ld,\"page\":%d,\"limit\":6 ,\"suggest\":true}}",self.subcate,1];
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            NSArray * content = [result objectForKey:@"contents"] ;
            
            
            for(NSDictionary* temp in content){
                
                AppContent *preview = [[AppContent alloc]initWithDictionary:temp];
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
            
            [[Manager sharedManager] setBannerArrayFreezone:bannerArray];
            bannerView.bannerArray = [[Manager sharedManager] bannerArrayFreezone];
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
     if(![[Manager sharedManager]bannerArrayFreezone])
         [self getBanner];
     [self setCateID:FREEZONE];
    [self RecommendLoad];
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": [Manager returnStringForGoogleTag:FREEZONE withSubCate:self.subcate :self.appObject.title]}];
    
    
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
    [_collectionView registerClass:[AppCell class] forCellWithReuseIdentifier:@"AppCell"];
    [_collectionView registerClass:[FreeZoneAppDetailCell class] forCellWithReuseIdentifier:@"DetailAppCell"];

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
            
            CGSize size = [[NSString stringWithFormat:@"%@",_appObject.title] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
            
            return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight]  +size.height+20);
        }
        else{
            
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size = [[NSString stringWithFormat:@"%@",_appObject.title] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
            
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
        
        if(!bannerView)
            bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
        bannerView.backgroundColor = [UIColor clearColor];
        //_carousel.
        [headerView addSubview:bannerView];
     
            if([[Manager sharedManager] bannerArrayFreezone]){
                bannerView.bannerArray =  [[Manager sharedManager]bannerArrayFreezone];
            }
            else{
                bannerView.bannerArray =  [[Manager sharedManager]bannerArray];
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
        [title setText:[NSString stringWithFormat:@"%@",_appObject.title ]];
        
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
        [titleReccommend setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM == IPAD ? 22 : 20]];
        [titleReccommend setBackgroundColor:[UIColor clearColor]];
        [titleReccommend setTextColor:[UIColor colorWithHexString:[Manager getColorName:self.cate]]];
        [titleReccommend setText:[NSString stringWithFormat:@"แอพเเนะนำ"]];
        //        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:@"แอพพลิเคชั่นเเนะนำ"];
        //        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM == IPAD ? 22 : 20] range:NSMakeRange(0, string.length)];
        //        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR] range:NSMakeRange(0, string.length)];//TextColor
        //        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0, string.length)];//Underline color
        //        [string addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:COLOR_FREEZONE] range:NSMakeRange(0, string.length)];//TextColor
        //        titleReccommend. attributedText = string;
        //
        //
        
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
        NSString *identify = @"DetailAppCell";
        FreeZoneAppDetailCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        cell.parentView = self;
        cell.delegate = self;
        cell.app = _appObject;
        [cell setSocialItem];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:_appObject.images.imageL]
             
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
            [manager downloadImageWithURL:[NSURL URLWithString:_appObject.images.imageL]
             
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
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [_appObject.title boundingRectWithSize:CGSizeMake(cell.titleLabel.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
        [cell.titleLabel setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.titleLabel.frame.size.width, size.height)];
        [cell.titleLabel setText:_appObject.title];
        
        
        
        [cell.detailLabel setText:_appObject.descriptionContent];
        [cell.detailLabel setFrame:CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.detailLabel.frame.size.width, cell.detailLabel.optimumSize.height)];
        if(_appObject.gallary.count >0){
            [cell.downloadLabel setFrame:CGRectMake(cell.downloadLabel.frame.origin.x, cell.detailLabel.frame.origin.y+cell.detailLabel.frame.size.height+20, cell.downloadLabel.frame.size.width,cell.downloadLabel.frame.size.height)];
            
            [cell.imageShowcaseLabel setFrame:CGRectMake(cell.imageShowcaseLabel.frame.origin.x, cell.downloadLabel.frame.origin.y+cell.downloadLabel.frame.size.height+10, cell.imageShowcaseLabel.frame.size.width,20)];
            [cell.imageShowCollection setFrame:CGRectMake(cell.imageShowCollection.frame.origin.x, cell.imageShowcaseLabel.frame.origin.y+cell.imageShowcaseLabel.frame.size.height+10, cell.imageShowCollection.frame.size.width,h_collecitonView-50)];
        }
        else{
            [cell.imageShowcaseLabel removeFromSuperview];
            [cell.imageShowCollection removeFromSuperview];
            [cell.downloadLabel setFrame:CGRectMake(cell.downloadLabel.frame.origin.x, cell.detailLabel.frame.origin.y+cell.detailLabel.frame.size.height+20, cell.downloadLabel.frame.size.width,cell.downloadLabel.frame.size.height)];
        }
        //[cell.detailLabel setBackgroundColor:[UIColor redColor]];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        
        [cell.downloadLabel setUserInteractionEnabled:YES];
        [cell.downloadLabel addGestureRecognizer:tapRecognizer];
        
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        cell.screenArray = _appObject.gallary;
        [cell.imageShowCollection reloadData];
        return cell;
    }
    AppContent *temp = recommendArray[indexPath.row];
    NSString *identify = @"AppCell";
    AppCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:temp.images.imageL]
         
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
    [cell.imageView setBackgroundColor:[UIColor clearColor]];
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
-(void)onTouchImageShowCase:(int)index{
    ShowImageViewController* showImage= [[ShowImageViewController alloc]init];
    //showImage.allImageArray = article.gallary;
    //showImage.index = (int)indexPath.row;
    showImage.allImageArray = _appObject.gallary;
    showImage.titlePage = self.appObject.title;
    showImage.index = index;
    showImage.themeColor = [UIColor colorWithHexString:[Manager getColorName:self.cate]];
    showImage.subCate = FREEZONE_APPLICATION;
    showImage.cate = FREEZONE;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    
    [self.navigationController pushViewController:showImage animated:NO];
}
-(void)tapped:(id)tap{
    
    if(_appObject.ios !=nil){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _appObject.ios]];
    }
    else{
        if ([UIAlertController class])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ไม่สามารถดาวน์โหลดได้" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ไม่สามารถดาวน์โหลดได้" message:@"" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w_1 = (self.view.frame.size.width/2 -15);
    //float w_1_ipad = (self.view.frame.size.width/2 -30);
    
    if(indexPath.section == 1){
        
        
        return CGSizeMake(w_1,w_1+40);
    }
    else{
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [_appObject.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width*0.8 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 16 : 14], NSParagraphStyleAttributeName : style} context:nil].size;
        float titleHeight = size.height;
        
        
        
        RTLabel *textView = [[RTLabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 1000)];
        
        textView.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = YES;
        // UIFont *test = textView.font;//time news roman 12 pixel
        [textView setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 14: 12]];
        
        [textView setText:_appObject.descriptionContent];
        //textView.text = para.descriptionContent;
        [textView setNeedsDisplay];
        
        [textView setFrame:CGRectMake(0, 0, textView.frame.size.width, textView.optimumSize.height)];
        
        textHeight = titleHeight+textView.optimumSize.height;
        
        h_collecitonView = (self.view.frame.size.width/3-15)*1.7125  ;
        if(_appObject.gallary.count == 0){
            h_collecitonView = 0;
        }
        else{
            float n = _appObject.gallary.count/3.0f;
            float roundedup = ceil(n);
            h_collecitonView = h_collecitonView*roundedup + 20+20+30;
        }
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*0.8+ 30 +textHeight+20+ h_collecitonView +60+60);
        
    }
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
    
    AppContent *preview = recommendArray[indexPath.row];
    
    [self getAppByID:preview.appID];
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
@end
