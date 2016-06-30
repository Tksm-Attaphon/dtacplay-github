//
//  ArticleViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "HoroViewController.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "MyFlowLayout.h"
#import "ImageBoxinAlbumCollectionViewCell.h"
#import "ShowImageViewController.h"
#import "AlbumViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "ParagraphContent.h"
#import "ShowImageViewController.h"
#import "ContentDetail.h"
#import "GallaryObject.h"
#import "RTLabel.h"
#import "MBProgressHUD.h"
#import "DtacWebViewViewController.h"
#import "DWTagList.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Manager.h"
#import "SocialView.h"
#import "Banner.h"
#import "BannerImage.h"
@interface HoroViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIGestureRecognizerDelegate,RTLabelDelegate,DWTagListDelegate,UIWebViewDelegate>
{
    UIView *imageHeader;
    UIPageControl *pageControl;
    UIView *contentView;
    UILabel *title;
    ContentDetail *article;
    UIView *background;
    UICollectionView *fooCollection;
    UILabel *titleHeader;
    UILabel *albumLabel;
    UIButton *buttonMoreAlbum;
    UITextView *textViewTag;
    
    UIImageView *bottomImage;
    float screenWidth;
    float screenHeight;
    float scrollViewWidth;
    float scrollViewHeight;
    
    UIWebView *textWebView;
    BOOL isFinishLoad;
    MBProgressHUD *hudWebView ;
    NSTimer *timer;
    
    NSURL *linkBanner;
    
    
}
@property (nonatomic, strong) NSMutableArray        *array;
@property (nonatomic, strong) DWTagList             *tagList;
@end

@implementation HoroViewController

-(void)getArticleDetail{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getContentById\",\"params\":{ \"conId\":%@}}",_contentID];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setColor:[UIColor whiteColor]];
    [hud setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"result"]) {
            NSDictionary *result =[responseObject objectForKey:@"result"] ;
            article = [[ContentDetail alloc]initWithDictionary:result];
            [self getBannerCredit:[article.feedID intValue]];
            if(article.feedID){
                NSString *canReadDate = [Manager dateTimeToReadableString:article.publishDate];
                article.title = [NSString stringWithFormat:@"%@\n",article.title];
                titleHeader.text = article.title ;
                
                UIFont *arialFont = [UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 18];
                NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
                NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:article.title attributes: arialDict];
                
                UIFont *VerdanaFont = [UIFont fontWithName:@"HelveticaNeue" size:IDIOM == IPAD ? 16 : 14];
                NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
                NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: canReadDate attributes:verdanaDict];
                
                [aAttrString appendAttributedString:vAttrString];
                
                
                titleHeader.attributedText = aAttrString;
            }else{
                titleHeader.text = article.title;
            }
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size = [article.title boundingRectWithSize:CGSizeMake(titleHeader.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 18], NSParagraphStyleAttributeName : style} context:nil].size;
            
            if (size.height > titleHeader.bounds.size.height) {
                
                [titleHeader setFrame:CGRectMake(0,imageHeader.frame.size.height+imageHeader.frame.origin.y+5, screenWidth-20, size.height)];
                
            }
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleHeader.frame.size.height+titleHeader.frame.origin.y, scrollViewWidth, 1 )];
            [line setBackgroundColor:[UIColor colorWithHexString:COLOR_LIFESTYLE]];
            [self.scrollView addSubview:line];
            NSString *content = [NSString stringWithFormat:@"Lifestyle - Horoscope​ - %@",article.title];
            [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": content}];
           
        }
        [self.collectionView reloadData];
        [hud hide:YES];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
    }];
    [op start];
    
}
-(void)setup_header{
    
    /// set navigation bar image
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];
    //    self.navigationItem.titleView = image;
    //
    self.navigationItem.title = self.titlePage;
    ///
    contentView = [[UIView alloc]initWithFrame:self.view.frame];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, screenWidth-20, screenHeight-60)];
    scrollViewWidth = self.scrollView.frame.size.width;
    self.scrollView.pagingEnabled = NO;
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    self.scrollView.clipsToBounds  = NO;
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    
    imageHeader = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, screenWidth, [[Manager sharedManager]bannerHeight] )];
    
    [imageHeader setBackgroundColor:[UIColor whiteColor]];
    
    imageHeader.clipsToBounds = YES;
    
    
    if(!_carousel)
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageHeader.frame.size.width, imageHeader.frame.size.height)];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeLinear;
    _carousel.backgroundColor = [UIColor clearColor];
    //_carousel.
    [imageHeader addSubview:_carousel];
    
    
    
    
    // Page Control
    if(!pageControl)
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (self.carousel.frame.size.height-20), self.carousel.frame.size.width, 20.0f)];
    pageControl.numberOfPages = [[Manager sharedManager] bannerArray].count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    pageControl.userInteractionEnabled = NO;
    [_carousel addSubview:pageControl];
    [timer invalidate];
    timer = nil;
    timer =  [NSTimer scheduledTimerWithTimeInterval:5.0f
                                              target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
    
    [self.scrollView addSubview:imageHeader];
    
    [self.scrollView sendSubviewToBack:imageHeader];
    
    titleHeader=[[UILabel alloc] initWithFrame:CGRectMake(0,imageHeader.frame.size.height+imageHeader.frame.origin.y, screenWidth-20, 30)];
    if ( IDIOM == IPAD ) {
        titleHeader=[[UILabel alloc] initWithFrame:CGRectMake(0,imageHeader.frame.size.height+imageHeader.frame.origin.y, screenWidth-20, 50)];
        
    }
    titleHeader.lineBreakMode = NSLineBreakByWordWrapping;
    titleHeader.numberOfLines = 0;
    [titleHeader setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 22 : 18]];
    
    [titleHeader setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
    [titleHeader setText:article.title];
    
    
    [self.scrollView addSubview:titleHeader];
    
}
- (BOOL)isLabelTruncated:(UILabel *)label
{
    BOOL isTruncated = NO;
    
    CGRect labelSize = [label.text boundingRectWithSize:CGSizeFromString(label.text) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:nil];
    
    if (labelSize.size.width / labelSize.size.height > label.numberOfLines) {
        
        isTruncated = YES;
    }
    
    return isTruncated;
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}
-(void)updateContent{
    self.content = [[ArticleContent alloc] init];
    self.content.title = @"HEllo World!!!";
    self.content.contentArray = [[NSMutableArray alloc] init];
    UIImageView* imageView ;
    UIImage *image;
    float width = screenWidth;
    if(image.size.width < width)
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width,image.size.height  )];
    else
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
    //NSString* a = promotionDetail.title;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:article.images.imageThumbnailL]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [imageView setImage:image];
                                    [imageView setFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
                                    [imageView setContentMode:UIViewContentModeScaleToFill];
                                    [self setFrameContent];
                                    
                                }
                                
                                
                                
                            }];
    }
    else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:article.images.imageThumbnailL]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [imageView setImage:image];
                                    
                                    [imageView setFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
                                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                                    [self setFrameContent];
                                }
                                
                            }];
    }
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [imageView addGestureRecognizer:pgr];
    
    imageView.tag = 11;
    if(article.isDisplayIntro == YES)
        [self.content.contentArray addObject:imageView];
    ////// share ....
    UIView *socialblock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth, 30)];
    socialblock.tag = 1;
    
    SocialView *view = [[[NSBundle mainBundle] loadNibNamed:@"SocialView2" owner:self options:nil] objectAtIndex:0];
    [view setFrame:CGRectMake(self.view.frame.size.width-100,0, 100, 30)];
    view.tag = 1;
    NSString *url;
    if([article.feedID intValue] == 20){//26
        url = [NSString stringWithFormat: @"%@horo/daily/%@?m=share",DOMAIN_WEBSITE,article.contentID];
    }
    else if([article.feedID intValue] == 21){
        url = [NSString stringWithFormat: @"%@horo/weekly/%@?m=share",DOMAIN_WEBSITE,article.contentID];

    }
    else{
         url = [NSString stringWithFormat: @"%@horo/zodiac/%@?m=share",DOMAIN_WEBSITE,article.contentID];
    }
   
    [view setParentView:self];
    [view setValueForShareTitle:article.title Description:article.descriptionContent ImageUrl:article.images.imageL ContentURL:url Category:[article.cateID intValue] SubCategoryType:article.subCateID contentID:[article.contentID intValue]];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.content.contentArray addObject:view];
    
    
       /////
    //    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10,0, screenWidth-20, 30)];
    //    if ( IDIOM == IPAD ) {
    //        label=[[UILabel alloc] initWithFrame:CGRectMake(10,0, screenWidth-20, 50)];
    //
    //    }
    //
    //    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:IDIOM == IPAD ? 21 : 16]];
    //
    //    [label setTextColor:[UIColor blackColor]];
    //    [label setText:article.title];
    //    label.lineBreakMode = NSLineBreakByWordWrapping;
    //    label.numberOfLines = 0;
    //    label.tag = 99;
    //    [self.content.contentArray addObject:label];
    /////
//    
//    if(article.feedID == nil){
//        if(article.descriptionContent != nil){
            RTLabel *textView = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth-20, 1000)];
            
            textView.delegate = self;
            textView.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
            textView.backgroundColor = [UIColor clearColor];
            textView.userInteractionEnabled = YES;
            // UIFont *test = textView.font;//time news roman 12 pixel
            [textView setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 20: 18]];
            textView.tag =80;
            if([article.feedID intValue] == 21)
                [textView setText:[NSString stringWithFormat:@"%@" ,article.descriptionContent]];
            else
                [textView setText:[NSString stringWithFormat:@"%@" ,article.descriptionContent]];
            //textView.text = para.descriptionContent;
            [textView setNeedsDisplay];
            
            [textView setFrame:CGRectMake(0, 0, textView.frame.size.width, textView.optimumSize.height+10)];
            [self.content.contentArray addObject:textView];
//        }
//        
//    }
//    else{
//        article.descriptionContent = [NSString stringWithFormat:@"<style type='text/css'>img {width: %fpx; height: auto;}body{ background-color: f5f5f5}</style>%@",scrollViewWidth-20,article.descriptionContent];
//        textWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth, 1000)];
//        [textWebView loadHTMLString:article.descriptionContent baseURL:nil];
//        textWebView.tag =78952;
//        textWebView.delegate = self;
//        isFinishLoad = NO;
//        textWebView.scrollView.scrollEnabled = NO;
//        textWebView.scrollView.bounces = NO;
//        [self.content.contentArray addObject:textWebView];
//        hudWebView = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        [hudWebView setColor:[UIColor whiteColor]];
//        [hudWebView setActivityIndicatorColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
//    }
    
    /////
    
    //    int i = 1;
    //    for(ParagraphContent *para in article.subContent){
    //        if(para.descriptionContent != nil){
    //            RTLabel *textView = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth-20, 100)];
    //
    //            textView.delegate = self;
    //            textView.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
    //            textView.backgroundColor = [UIColor whiteColor];
    //            textView.userInteractionEnabled = YES;
    //            // UIFont *test = textView.font;//time news roman 12 pixel
    //            [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:IDIOM==IPAD ? 18: 16]];
    //            textView.tag =88;
    //            [textView setText:para.descriptionContent];
    //
    //            [textView setFrame:CGRectMake(0, 0, scrollViewWidth, textView.optimumSize.height)];
    //            [textView setNeedsDisplay];
    //
    //            [self.content.contentArray addObject:textView];
    //
    //        }
    //        if(para.images != nil){
    //            width = screenWidth;
    //            if(image.size.width < width)
    //                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width,image.size.height  )];
    //            else
    //                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
    //            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
    //                SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //                [manager downloadImageWithURL:[NSURL URLWithString:para.images.imageL]
    //                                      options:0
    //                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //                                         // progression tracking code
    //                                     }
    //                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    //                                        if (image) {
    //                                            [imageView setImage:image];
    //                                            imageView.tag = 66;
    //                                            float width = scrollViewWidth;
    //
    //                                            [imageView setFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
    //
    //                                            [imageView setContentMode:UIViewContentModeScaleAspectFit];
    //                                            [self setFrameContent];
    //                                        }
    //
    //
    //                                    }];
    //            }
    //            else{
    //                SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //                [manager downloadImageWithURL:[NSURL URLWithString:para.images.imageM]
    //                                      options:0
    //                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //                                         // progression tracking code
    //                                     }
    //                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    //                                        if (image) {
    //                                            [imageView setImage:image];
    //                                            imageView.tag = 66;
    //                                            float width = scrollViewWidth;
    //
    //                                            [imageView setFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
    //                                            [imageView setContentMode:UIViewContentModeScaleAspectFit];
    //                                            [self setFrameContent];
    //                                        }
    //
    //
    //                                    }];
    //            }
    //            imageView.userInteractionEnabled = YES;
    //
    //            UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
    //                                           initWithTarget:self action:@selector(handlePinch:)];
    //            pgr.delegate = self;
    //            [imageView addGestureRecognizer:pgr];
    //            imageView.tag = i++;
    //            [self.content.contentArray addObject:imageView];
    //        }
    //    }
    [self setFrameContent];
}
#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"did select url %@", url);
    [[UIApplication sharedApplication] openURL:url];
    //    DtacWebViewViewController *webViewDtac = [[DtacWebViewViewController alloc]init];
    //    webViewDtac.url = url;
    //    webViewDtac.themeColor = self.themeColor;
    //    webViewDtac.titlePage = self.titlePage;
    //    UIBarButtonItem *newBackButton =
    //    [[UIBarButtonItem alloc] initWithTitle:@" "
    //                                     style:UIBarButtonItemStyleBordered
    //                                    target:nil
    //                                    action:nil];
    //    [self.navigationItem setBackBarButtonItem:newBackButton];
    //    [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    //    [self.navigationController pushViewController:webViewDtac animated:YES];
}
-(void)setFrameContent{
    //////
    float y = 0;
    float x = 10;
    for (int i = 0; i < self.content.contentArray.count; i++) {
        UIView * temp = self.content.contentArray[i];
        
        switch(temp.tag){
            case 0:
                [temp setFrame:CGRectMake(0, y, _scrollView.frame.size.width, temp.frame.size.height)];
                break;
            case 1:
                [temp setFrame:CGRectMake(0, y-5+((article.isDisplayIntro == YES )? 0 : 10), _scrollView.frame.size.width, temp.frame.size.height)];
                break;
            case 11:
                [temp setFrame:CGRectMake(0, y-5, _scrollView.frame.size.width, temp.frame.size.height)];
                break;
            case 66:
                [temp setFrame:CGRectMake(0, y, _scrollView.frame.size.width, temp.frame.size.height)];
                break;
            case 99:
                [temp setFrame:CGRectMake(x, y, _scrollView.frame.size.width-20, temp.frame.size.height)];
                break;
            case 88:
                [temp setFrame:CGRectMake(x, y, _scrollView.frame.size.width-20, temp.frame.size.height)];
                break;
            case 80:
                [temp setFrame:CGRectMake(x, y, _scrollView.frame.size.width-20, temp.frame.size.height)];
                break;
            case 78952:
                [temp setFrame:CGRectMake(0, y, _scrollView.frame.size.width, temp.frame.size.height)];
                break;
            default:
                [temp setFrame:CGRectMake(x, y, _scrollView.frame.size.width-20, temp.frame.size.height)];
                break;
        }
        
        [contentView addSubview:temp];
        
        if ( IDIOM == IPAD ) {
            y = temp.frame.size.height+temp.frame.origin.y+20;
        }
        else{
            
            y = temp.frame.size.height+temp.frame.origin.y+10;
            
        }
        
        
    }
    [contentView setFrame:CGRectMake(0,titleHeader.frame.origin.y+titleHeader.frame.size.height+ (IDIOM == IPAD ? 20 : 10), scrollViewWidth, y-10)];
    [self.scrollView addSubview:contentView];
    [contentView setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
    contentView.layer.masksToBounds = NO;
    contentView.layer.shadowOffset = CGSizeMake(1, 1);
    contentView.layer.shadowRadius = 2;
    contentView.layer.shadowOpacity = 0.5;
    contentView.layer.shouldRasterize = YES;
    contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;

    if(!bottomImage){
     [self.scrollView setContentSize:CGSizeMake(scrollViewWidth, contentView.frame.size.height+contentView.frame.origin.y+title.frame.size.height+fooCollection.frame.size.height+albumLabel.frame.size.height+_tagList.frame.size.height+bottomImage.frame.size.height+10)];
    }
    else{
  
        [self.scrollView setContentSize:CGSizeMake(scrollViewWidth, contentView.frame.size.height+contentView.frame.origin.y+title.frame.size.height+fooCollection.frame.size.height+albumLabel.frame.size.height+_tagList.frame.size.height+bottomImage.frame.size.height+5)];
    }
    
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    if(isFinishLoad == NO){
        CGRect frame = aWebView.frame;
        frame.size.height = 1;
        aWebView.frame = frame;
        CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        aWebView.frame = frame;
        [self setFrameContent];
        NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
        isFinishLoad =YES;
        [hudWebView hide:YES];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        [webView loadRequest:nil];
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
    return YES;
    
}
- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}
//DW taglist Delegate
- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex{
    
}
- (void)handlePinch:(UITapGestureRecognizer *)pinchGestureRecognizer
{
    //    ShowImageViewController* showImage= [[ShowImageViewController alloc]init];
    //    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    //    [imageArr addObject:IDIOM == IPAD ?promotionDetail.images.imageW1: promotionDetail.images.imageW2];
    //    for(ParagraphPromotion *para in promotionDetail.subContent){
    //        [imageArr addObject:IDIOM == IPAD ?para.images.imageW1: para.images.imageW2];
    //
    //    }
    //    showImage.allImageArray = imageArr;
    //    UIBarButtonItem *newBackButton =
    //    [[UIBarButtonItem alloc] initWithTitle:@" "
    //                                     style:UIBarButtonItemStyleBordered
    //                                    target:nil
    //                                    action:nil];
    //    [self.navigationItem setBackBarButtonItem:newBackButton];
    //
    //    [self.navigationController pushViewController:showImage animated:YES];
}

//-(void)setup_content{
//    self.content = [[ArticleContent alloc] init];
//    self.content.title = @"HEllo World!!!";
//    self.content.contentArray = [[NSMutableArray alloc] init];
//
//    UIFont *font_1 = [UIFont fontWithName:@"HelveticaNeue" size:IDIOM==IPAD ? 19: 14];
//     UIFont *font_2 = [UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 19: 14];
//
//    UIImageView* imageView ;
//
//    if ( IDIOM == IPAD ) {
//        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 300 )];
//         [imageView setImage:[UIImage imageNamed:@"TRAVEL_CON_L_01.jpg"]];
//    }
//    else{
//        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 150 )];
//         [imageView setImage:[UIImage imageNamed:@"TRAVEL_CON_M_01.jpg"]];
//    }
//
//    [imageView setContentMode:UIViewContentModeScaleToFill];
//    [self.content.contentArray addObject:imageView];
//    ////// share ....
//    UIView *socialblock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 25)];
//
//    [self.content.contentArray addObject:socialblock];
//
//    UIImageView *lineIcon = [[UIImageView alloc]initWithFrame:CGRectMake(socialblock.frame.size.width-50, 2, 23, 23)];
//    [lineIcon setImage:[UIImage imageNamed:@"line_icon.jpg"]];
//    [lineIcon setContentMode:UIViewContentModeScaleToFill];
//    [socialblock addSubview:lineIcon];
//
//    UIImageView *tweeterIcon = [[UIImageView alloc]initWithFrame:CGRectMake(socialblock.frame.size.width-80, 2, 23, 23)];
//    [tweeterIcon setImage:[UIImage imageNamed:@"tweet_icon"]];
//    [tweeterIcon setContentMode:UIViewContentModeScaleToFill];
//    [socialblock addSubview:tweeterIcon];
//
//    UIImageView *faceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(socialblock.frame.size.width-110, 2, 23, 23)];
//    [faceIcon setImage:[UIImage imageNamed:@"facebook_icon"]];
//    [faceIcon setContentMode:UIViewContentModeScaleToFill];
//    [socialblock addSubview:faceIcon];
//
//    UILabel *titleShareNumber=[[UILabel alloc] initWithFrame:CGRectMake(socialblock.frame.size.width-150,0,30,23)];
//    if ( IDIOM == IPAD ) {
//        titleShareNumber=[[UILabel alloc] initWithFrame:CGRectMake(10,contentView.frame.size.height+contentView.frame.origin.y+20, screenWidth-20, 50)];
//
//    }
//
//    [titleShareNumber setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM == IPAD ? 55 : 27]];
//
//    [titleShareNumber setTextColor:[UIColor blackColor]];
//    [titleShareNumber setText:@"75"];
//    [socialblock addSubview:titleShareNumber];
//
//    UILabel *shareText=[[UILabel alloc] initWithFrame:CGRectMake(socialblock.frame.size.width-200,5,50,23)];
//    if ( IDIOM == IPAD ) {
//        shareText=[[UILabel alloc] initWithFrame:CGRectMake(10,contentView.frame.size.height+contentView.frame.origin.y+20, screenWidth-20, 50)];
//
//    }
//
//    [shareText setFont:[UIFont fontWithName:FONT_DTAC_LIGHT size:IDIOM == IPAD ? 21 : 16]];
//
//    [shareText setTextColor:[UIColor grayColor]];
//    [shareText setText:@"Shares"];
//    [socialblock addSubview:shareText];
//
//    UIImageView *shareIcon = [[UIImageView alloc]initWithFrame:CGRectMake(socialblock.frame.size.width-220, 10, 15, 15)];
//    [shareIcon setImage:[UIImage imageNamed:@"share_icon"]];
//    [shareIcon setContentMode:UIViewContentModeScaleToFill];
//    [socialblock addSubview:shareIcon];
//    if ( IDIOM == IPAD ) {
//        [socialblock setFrame:CGRectMake(0, 0, screenWidth, 46)];
//        [lineIcon setFrame:CGRectMake(socialblock.frame.size.width-85, 6, 46, 46)];
//        [tweeterIcon setFrame:CGRectMake(socialblock.frame.size.width-140, 6, 46, 46)];
//        [faceIcon setFrame:CGRectMake(socialblock.frame.size.width-195, 6, 46, 46)];
//        [titleShareNumber setFrame:CGRectMake(socialblock.frame.size.width-260,0,60,50)];
//        [shareText setFrame:CGRectMake(socialblock.frame.size.width-330,10,80,50)];
//        [shareIcon setFrame:CGRectMake(socialblock.frame.size.width-365, 20, 30, 30)];
//    }
//
//    /////
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10,0, screenWidth-20, 30)];
//    if ( IDIOM == IPAD ) {
//        label=[[UILabel alloc] initWithFrame:CGRectMake(10,0, screenWidth-20, 50)];
//
//    }
//
//    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:IDIOM == IPAD ? 21 : 16]];
//
//    [label setTextColor:[UIColor blackColor]];
//    [label setText:@"5 ตลาดสุดชิค สายฮิปสเตอร์ ห้ามพลาด!!"];
//      [self.content.contentArray addObject:label];
//    /////
//
//    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
//    textView.textColor =[UIColor blackColor];
//    textView.backgroundColor = [UIColor whiteColor];
//    textView.userInteractionEnabled = NO;
//    [textView setFont:font_1];
//
//    textView.text = @" วันนี้ฤกษ์งามยามดีเลยจัดรีวิวมาให้เพื่อนๆได้ชมกัน เป็นรีวิวแรกของผมกับพันทิปโฉมใหม่หลังจากรีวิวล่าสุดเมื่อหลายปีที่แล้ว นานมากกกกก ฮ่าๆ .. สืบเนื่องจากสายการบิน Bangkok Airways ได้ออกโปรฉลองครบรอบ 45 ปีของสายการบิน  บินในประเทศเริ่มต้นเพียงแค่ 945 บาทเท่านั้น !! รวมภาษีเสร็จสรรพก็อยู่ที่พันนิดๆเห็นแบบนี้แล้วกิเลสขึ้นเลยครับพ่อแม่พี่น้อง จัดการสอยไปเบาๆ BKK-CNX-BKK , BKK-HKT-BKK  บินกันสนุกสนานเลยทีเดียวเชียว ปั๊มเงินไปเที่ยวแทบไม่ทัน วันหยุดวันลาก็แทบจะไม่เหลือตั้งแต่ครึ่งปีแรก ฮ่าๆๆ ..  เชียงใหม่นี่ไปบ่อยมากเพราะมีบ้านอยู่ที่นั่น ปกติก็ใช้บริการบูติคแอร์ตลอดๆของเค้าเริ่ดจริงอะไรจริง  ส่วนภูเก็ตบ่องตงว่ายังไม่เคยไปเลย นี่คือครั้งแรกที่จะไปเที่ยวภูเก็ต";
//
//    [self textViewDidChange:textView];
//
//    [self.content.contentArray addObject:textView];
//
//    if ( IDIOM == IPAD ) {
//        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 300 )];
//        [imageView setImage:[UIImage imageNamed:@"TRAVEL_CON_L_02.jpg"]];
//    }
//    else{
//        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 150 )];
//        [imageView setImage:[UIImage imageNamed:@"TRAVEL_CON_L_02.jpg"]];
//    }
//
//    [imageView setContentMode:UIViewContentModeScaleToFill];
//    [self.content.contentArray addObject:imageView];
//
//
//    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
//    textView.textColor =[UIColor blackColor];
//    textView.backgroundColor = [UIColor whiteColor];
//    textView.userInteractionEnabled = NO;
//     [textView setFont:font_1];
//    textView.text = @"วันนี้ฤกษ์งามยามดีเลยจัดรีวิวมาให้เพื่อนๆได้ชมกัน เป็นรีวิวแรกของผมกับพันทิปโฉมใหม่หลังจากรีวิวล่าสุดเมื่อหลายปีที่แล้ว นานมากกกกก ฮ่าๆ .. สืบเนื่องจากสายการบิน Bangkok Airways ได้ออกโปรฉลองครบรอบ 45 ปีของสายการบิน  บินในประเทศเริ่มต้นเพียงแค่ 945 บาทเท่านั้น !! รวมภาษีเสร็จสรรพก็อยู่ที่พันนิดๆเห็นแบบนี้แล้วกิเลสขึ้นเลยครับพ่อแม่พี่น้อง จัดการสอยไปเบาๆ BKK-CNX-BKK , BKK-HKT-BKK  บินกันสนุกสนานเลยทีเดียวเชียว ปั๊มเงินไปเที่ยวแทบไม่ทัน วันหยุดวันลาก็แทบจะไม่เหลือตั้งแต่ครึ่งปีแรก ฮ่าๆๆ ..  เชียงใหม่นี่ไปบ่อยมากเพราะมีบ้านอยู่ที่นั่น ปกติก็ใช้บริการบูติคแอร์ตลอดๆของเค้าเริ่ดจริงอะไรจริง  ส่วนภูเก็ตบ่องตงว่ายังไม่เคยไปเลย นี่คือครั้งแรกที่จะไปเที่ยวภูเก็ต";
//    [self textViewDidChange:textView];
//
//    [self.content.contentArray addObject:textView];
//
//   ///////
//    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
//    textView.textColor =[UIColor blackColor];
//    textView.backgroundColor = [UIColor whiteColor];
//    textView.userInteractionEnabled = NO;
//    [textView setFont:font_2];
//    textView.text = @"เขื่อนรัชประภาสุราษฎร์ธานี เขื่อนรัชประภาสุราษฎร์ธานี เขื่อนรัชประภาสุราษฎร์ธานี เขื่อนรัชประภาสุราษฎร์ธานี เขื่อนรัชประภาสุราษฎร์ธานี เขื่อนรัชประภาสุราษฎร์ธานี";
//    [self textViewDidChange:textView];
//     [self.content.contentArray addObject:textView];
//
//    float y = 0;
//    float x = 10;
//    for (int i = 0; i < self.content.contentArray.count; i++) {
//            UIView * temp = self.content.contentArray[i];
//            [temp setFrame:CGRectMake(x, y, _scrollView.frame.size.width-10, temp.frame.size.height)];
//            [contentView addSubview:temp];
//
//        if ( IDIOM == IPAD ) {
//              y = temp.frame.size.height+temp.frame.origin.y+20;
//        }
//        else{
//             y = temp.frame.size.height+temp.frame.origin.y+10;
//        }
//
//
//    }
//     [contentView setFrame:CGRectMake(0, imageHeader.frame.size.height+imageHeader.frame.origin.y+title.frame.size.height+23, scrollViewWidth, y)];
//    [self.scrollView addSubview:contentView];
//    [contentView setBackgroundColor:[UIColor whiteColor]];
//    contentView.layer.masksToBounds = NO;
//    contentView.layer.shadowOffset = CGSizeMake(1, 1);
//    contentView.layer.shadowRadius = 2;
//    contentView.layer.shadowOpacity = 0.5;
//    contentView.layer.shouldRasterize = YES;
//    contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//
//    ///// create footer
//
//    UILabel *albumLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,contentView.frame.size.height+contentView.frame.origin.y+20, screenWidth-20, 30)];
//    if ( IDIOM == IPAD ) {
//        albumLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,contentView.frame.size.height+contentView.frame.origin.y+20, screenWidth-20, 50)];
//
//    }
//
//    [albumLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 21 : 16]];
//
//    [albumLabel setTextColor:[UIColor colorWithHexString:@"9f064f"]];
//    [albumLabel setText:@"อัลบัมภาพ"];
//    [self.scrollView addSubview:albumLabel];
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
//    CGRect frame = CGRectMake(scrollViewWidth-30, albumLabel.center.y-10, 25, 25);
//    if ( IDIOM == IPAD ) {
//       frame = CGRectMake(scrollViewWidth-50, albumLabel.center.y-20, 50, 50);
//        button.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
//         button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    }
//    button.frame = frame;
//    [button setImage:[UIImage imageNamed:@"more_button_maroon" ] forState:UIControlStateNormal];
//
//    [button addTarget:self action:@selector(gotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
//    button.clipsToBounds = YES;
//    //half of the width
//    button.layer.cornerRadius = 10;
//
//    [self.scrollView addSubview:button];
//
//    MyFlowLayout *layout=[[MyFlowLayout alloc] init];
//    UICollectionView *fooCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, albumLabel.frame.origin.y+ albumLabel.frame.size.height+20, scrollViewWidth, screenWidth/3+30) collectionViewLayout:layout];
//
//    [fooCollection setDataSource:self];
//    [fooCollection setDelegate:self];
//
//    [fooCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageBoxinAlbumCollectionViewCell"];
//
//    [fooCollection setBackgroundColor:[UIColor whiteColor]];
//    [self.scrollView addSubview:fooCollection];
//
//
//    ////
//    [self.scrollView setContentSize:CGSizeMake(scrollViewWidth, contentView.frame.size.height+imageHeader.frame.size.height+imageHeader.frame.origin.y+title.frame.size.height+albumLabel.frame.size.height+fooCollection.frame.size.height+50)];
//}
-(void)gotoAlbum:(UIButton*)sender{
    AlbumViewController* album= [[AlbumViewController alloc]init];
    album.allImageArray = article.gallary;
    album.titlePage = self.titlePage;
    album.titleArticle = article.title;
    album.themeColor = self.themeColor;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    [self.navigationController pushViewController:album animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self setCateID:LIFESTYLE];
    switch (self.pageType) {
        case NEWS:
            _themeColor = [UIColor colorWithHexString:COLOR_NEWS];
            self.navigationItem.title = @"ข่าว";
            break;
        case ENTERTAINMENT:
            _themeColor = [UIColor colorWithHexString:COLOR_ENTERTAINMENT];
            self.navigationItem.title = @"บันเทิง";
            break;
        case PROMOTION:
            _themeColor = [UIColor colorWithHexString:COLOR_PROMOTION];
            self.navigationItem.title = @"โปรโมชั่น";
            break;
        case LIFESTYLE:
            _themeColor = [UIColor colorWithHexString:COLOR_LIFESTYLE];
            self.navigationItem.title = @"ไลฟ์สไตล์";
            break;
        case FREEZONE:
            _themeColor = [UIColor colorWithHexString:COLOR_FREEZONE];
            self.navigationItem.title = @"ฟรีโซน";
            break;
        case SPORT:
            _themeColor = [UIColor colorWithHexString:COLOR_SHOPPING];
            self.navigationItem.title = @"กีฬา";
            break;
        case SHOPPING:
            _themeColor = [UIColor colorWithHexString:COLOR_SHOPPING];
            self.navigationItem.title = @"ชอปปิ้ง";
            break;
        default:
            break;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:_themeColor,
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    
    [self setup_header];
    [self getArticleDetail];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

-(void)runLoop:(NSTimer*)NSTimer{
    
    if(_carousel)
        [_carousel scrollToItemAtIndex:self.carousel.currentItemIndex+1 animated:YES];
    
    
    
}
- (void)getBannerCredit:(int)feedID{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"getPartnerCredit\",\"params\":{ \"feedId\":%d}}",feedID];
    
    
    NSString *valueHeader;
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
            NSDictionary *result_1 = [responseObject objectForKey:@"result"] ;
            NSArray* result_2 = [result_1 objectForKey:@"banners"];
            
            NSDictionary *result = result_2.count >= 1 ? result_2[0] : nil;
            NSDictionary *imageAll = [[result objectForKey:@"images"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"images"] ;
            NSString *imageURL = [[imageAll objectForKey:@"m"] isEqual:[NSNull null]] ? nil : [imageAll objectForKey:@"m"] ;
            NSString *linkImage = [[result objectForKey:@"imageLink"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"imageLink"] ;
            NSString *detail = [[result objectForKey:@"detail"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"detail"] ;
            NSString *link = [[result objectForKey:@"link"] isEqual:[NSNull null]] ? nil : [result objectForKey:@"link"];
            
            linkBanner = [NSURL URLWithString:linkImage];
            
            NSString *supporter = @"";
            
            if(detail)
                supporter = [Manager returnSupporter:[article.feedID intValue] :detail : link ];
            article.descriptionContent = [NSString stringWithFormat:@"%@ %@",article.descriptionContent,supporter];
            
            
            UIImage *image = [UIImage imageNamed:@"Horoscope_banner_L.jpg"];
            bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, _tagList.frame.size.height+contentView.frame.origin.y + contentView.frame.size.height+10, self.scrollView.frame.size.width, (200*contentView.frame.size.width)/940)];
            [self.scrollView addSubview:bottomImage];
            [bottomImage setContentMode:UIViewContentModeScaleAspectFit];
            [bottomImage setImage:image];
            [bottomImage setBackgroundColor:[UIColor clearColor]];
            [self setFrameContent];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imageURL]
             
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
     
                                        [bottomImage setContentMode:UIViewContentModeScaleAspectFit];
                                        
                                        [bottomImage setImage:image];
                                        [bottomImage setUserInteractionEnabled:YES];
                                        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
                                        
                                        singleTap.numberOfTapsRequired = 1;
                                        singleTap.numberOfTouchesRequired = 1;
                                        [bottomImage addGestureRecognizer: singleTap];
                                         [self updateContent];
                                    }
                                    
                                    
                                }];
            
            
            
        }
        
        [self updateContent];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
        [self updateContent];
        
    }];
    [op start];
}
-(void) handleSingleTap:(UITapGestureRecognizer *)gr {
    if(linkBanner)
        [[UIApplication sharedApplication] openURL:linkBanner];
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
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    Banner *temp  = [[Manager sharedManager] bannerArray ][index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.link]];
}
//////////
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(article.gallary.count<4){
        [self.scrollView setContentSize:CGSizeMake(scrollViewWidth, contentView.frame.size.height+contentView.frame.origin.y+title.frame.size.height+fooCollection.frame.size.height/2+albumLabel.frame.size.height+_tagList.frame.size.height)];
    }
    return article.gallary.count >6 ? 6 : article.gallary.count;
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
        UIEdgeInsets inset = UIEdgeInsetsMake(20,10,20,10);
        return inset;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(0,10,0,10);
    return inset;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=(UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageBoxinAlbumCollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    GallaryObject* gallaryTemp = article.gallary[indexPath.row];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:gallaryTemp.thumb]
                    
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
    [cell addSubview:imageView];
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
    if ( IDIOM == IPAD ) {
        
        return CGSizeMake(screenWidth/3-25, screenWidth/3-25);
    }
    return CGSizeMake(screenWidth/3-20, screenWidth/3-20);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShowImageViewController* showImage= [[ShowImageViewController alloc]init];
    showImage.allImageArray = article.gallary;
    showImage.index = (int)indexPath.row;
    showImage.titlePage = self.titlePage;
    showImage.themeColor = self.themeColor;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    
    [self.navigationController pushViewController:showImage animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    // The container should have already been opened, otherwise events pushed to
//    // the data layer will not fire tags in that container.
//    TAGDataLayer *dataLayer = [TAGManager instance].dataLayer;
//
//    NSString *content = [NSString stringWithFormat:@"Lifestyle - Horoscope - %@",article.title];
//    [dataLayer push:@{@"event": @"openScreen", @"screenName": content}];
//    
//    
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end