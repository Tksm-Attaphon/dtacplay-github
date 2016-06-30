//
//  AlbumViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/7/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "AlbumViewController.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "MyFlowLayout.h"
#import "ShowImageViewController.h"
#import "GallaryObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Manager.h"
#import "Banner.h"
#import "BannerImage.h"
@interface AlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    UIPageControl *pageControl;
    UIView *contentView;
    UILabel *title;
    NSTimer *timer;
    UIView *background;
}
@end

@implementation AlbumViewController

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ( IDIOM == IPAD ) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [[NSString stringWithFormat:@"อัลบั้มภาพ > %@",self.titleArticle ] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
        
        return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight] +size.height+10);
    }
    else{
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize size = [[NSString stringWithFormat:@"อัลบั้มภาพ > %@",self.titleArticle ] boundingRectWithSize:CGSizeMake( self.view.frame.size.width-20 , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
        
        return CGSizeMake( self.view.frame.size.width, [[Manager sharedManager]bannerHeight] +size.height+10);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// set navigation bar image
    
    NSString *string ;
    switch (self.subcate) {
        case LIFESTYLE_TRAVEL:
            string = [NSString stringWithFormat:@"LifeStyle - Travel - Gallery - %@",self.titleArticle];
            break;
        case LIFESTYLE_RESTAURANT:
            string = [NSString stringWithFormat:@"LifeStyle - Restaurant - Gallery - %@",self.titleArticle];
            break;
        default:
            string =  [NSString stringWithFormat:@"LifeStyle - Unknow - Gallery - %@",self.titleArticle];
            break;
    }
    [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": string}];
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];
    self.navigationItem.title = self.titlePage;
    ///
    
    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height-60) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageBoxinAlbumCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderView"];
    
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    
    [timer invalidate];
    timer = nil;
    timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                              target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view.
}
-(void)runLoop:(NSTimer*)NSTimer{
    if(_carousel)
        [_carousel scrollToItemAtIndex:_carousel.currentItemIndex+1 animated:YES];
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
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
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    pageControl.userInteractionEnabled = NO;
    [_carousel addSubview:pageControl];
    
    title=[[UILabel alloc] initWithFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y+10, self.view.frame.size.width-20, 30)];
    if ( IDIOM == IPAD ) {
        title=[[UILabel alloc] initWithFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y+10, self.view.frame.size.width-20, 50)];
        
    }
    title.lineBreakMode = NSLineBreakByWordWrapping;
    title.numberOfLines = 0;
    [title setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20]];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor colorWithHexString:@"9f064f"]];
    [title setText:[NSString stringWithFormat:@"อัลบั้มภาพ > %@",self.titleArticle ]];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size = [title.text boundingRectWithSize:CGSizeMake(title.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
    
    if (size.height > title.bounds.size.height) {
        
        [title setFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y+10, self.view.frame.size.width-20, size.height)];
        if ( IDIOM == IPAD ) {
            [title setFrame:CGRectMake(10,_carousel.frame.size.height+_carousel.frame.origin.y+10, self.view.frame.size.width-20, size.height)];
            
        }
        
    }
    
    [headerView addSubview:title];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, title.frame.size.height+title.frame.origin.y, self.view.frame.size.width-20, 1 )];
    [line setBackgroundColor:[UIColor colorWithHexString:@"9f064f"]];
    [headerView addSubview:line];
    
    
    return headerView;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[Manager sharedManager]bannerArray].count;
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

//////////
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _allImageArray.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ( IDIOM == IPAD ) {
        UIEdgeInsets inset = UIEdgeInsetsMake(20,20,20,20);
        return inset;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(10,10,15,10);
    return inset;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=(UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageBoxinAlbumCollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    GallaryObject* gallaryTemp = _allImageArray[indexPath.row];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:gallaryTemp.image]
                         
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                
                                [imageView setImage:image];
                            }
                        }];
    
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [imageView setClipsToBounds:YES];
    [cell addSubview:imageView];
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.layer.shadowRadius = 2;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [cell setBackgroundColor:[UIColor grayColor]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( IDIOM == IPAD ) {
        
        return CGSizeMake(self.view.frame.size.width/3-25, self.view.frame.size.width/3-25);
    }
    return CGSizeMake(self.view.frame.size.width/3-15, self.view.frame.size.width/3-20);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShowImageViewController* showImage= [[ShowImageViewController alloc]init];
    showImage.allImageArray = _allImageArray;
    showImage.index = (int)indexPath.row;
    showImage.titlePage = self.titlePage;
    showImage.themeColor = self.themeColor;
    showImage.subCate = self.subcate;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [self.navigationController pushViewController:showImage animated:NO];
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
