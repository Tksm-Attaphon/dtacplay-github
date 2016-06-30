//
//  PromotionDetailViewController.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/8/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "MyFlowLayout.h"
#import "PromotionDetail.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "ParagraphPromotion.h"
#import "ShowImageViewController.h"
#import "RTLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "DtacWebViewViewController.h"
#import "Manager.h"
#import "SocialView.h"
#import "Banner.h"
#import "BannerImage.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "ImageViewWithLink.h"
@interface PromotionDetailViewController ()<UIGestureRecognizerDelegate,RTLabelDelegate>
{
    UIView *imageHeader;
    UIPageControl *pageControl;
    UIView *contentView;
    UILabel *title;
    
    UIView *background;
    
    PromotionDetail *promotionDetail;
    float screenWidth;
    float screenHeight;
    float scrollViewWidth;
    float scrollViewHeight;
    
    UILabel *titleHeader;
    
    UIImage *bannerImage;
}
@end


@implementation PromotionDetailViewController

-(void)getPromotionDetail{
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
            promotionDetail = [[PromotionDetail alloc]initWithDictionary:result];
            titleHeader.text = promotionDetail.title;
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size = [promotionDetail.title boundingRectWithSize:CGSizeMake(titleHeader.frame.size.width , NSUIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:DEFAULT_TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 24 : 20], NSParagraphStyleAttributeName : style} context:nil].size;
            
            if (size.height > titleHeader.bounds.size.height) {
                
                [titleHeader setFrame:CGRectMake(0,imageHeader.frame.size.height+imageHeader.frame.origin.y+5, screenWidth-20, size.height)];
                if ( IDIOM == IPAD ) {
                    [titleHeader setFrame:CGRectMake(0,imageHeader.frame.size.height+imageHeader.frame.origin.y+5, screenWidth-20, size.height)];
                    
                }
                
            }
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleHeader.frame.size.height+titleHeader.frame.origin.y, scrollViewWidth, 1 )];
            [line setBackgroundColor:[UIColor colorWithHexString:COLOR_PROMOTION]];
            [self.scrollView addSubview:line];
            
            NSString *string = [NSString stringWithFormat:@"Promotion - %@",promotionDetail.title];
            [self googleTagUpdate:@{@"event": @"openScreen", @"screenName": string}];
            
            [self updateContent];
        }
        [self.collectionView reloadData];
        [hud hide:YES];
        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON responseObject: %@ ",error);
    }];
    [op start];
    
}
-(void)updateContent{
    self.content = [[ArticleContent alloc] init];
    self.content.title = @"HEllo World!!!";
    self.content.contentArray = [[NSMutableArray alloc] init];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:promotionDetail.images.imageM1]
     
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                bannerImage = image;
                                [self.carousel reloadData];
                            }
                            
                        }];
    
    
    UIImageView* imageView ;
    UIImage *image;
    float width = self.view.frame.size.width;
    
    if(image.size.width < width)
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width,image.size.height  )];
    else
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
    //NSString* a = promotionDetail.title;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:promotionDetail.images.imageW1]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [imageView setImage:image];
                                    float width = self.scrollView.frame.size.width;
                                    [imageView setFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
                                    [self setFrameContent];
                                    
                                }
                                
                                
                            }];
    }
    else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:promotionDetail.images.imageW2]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [imageView setImage:image];
                                    float width = self.scrollView.frame.size.width;
                                    
                                    [imageView setFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
                                    [self setFrameContent];
                                    
                                }
                                
                            }];
    }
    imageView.tag = 3;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [imageView addGestureRecognizer:pgr];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.tag = 0;
    
    if(promotionDetail.isDisplayIntro == YES){
        // [self.content.contentArray addObject:imageView];
        
    }
    ////// share ....
    UIView *socialblock = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 30)];
    socialblock.tag = 1;
    SocialView *view = [[[NSBundle mainBundle] loadNibNamed:@"SocialView2" owner:self options:nil] objectAtIndex:0];
    [view setFrame:CGRectMake(self.view.frame.size.width-100,0, 100, 30)];
    view.tag = 1;
    view.parentView = self;
   [view setValueForShareTitle:promotionDetail.title Description:promotionDetail.descriptionContent ImageUrl:promotionDetail.images.imageW1 ContentURL:[NSString stringWithFormat: @"%@promotion/%@/%@?m=share",DOMAIN_WEBSITE,promotionDetail.contentID,promotionDetail.title] Category:PROMOTION  SubCategoryType:0 contentID:[promotionDetail.contentID intValue]];
    
    [view setBackgroundColor:[UIColor clearColor]];
    [self.content.contentArray addObject:view];
    
    
    
    
    
    if(promotionDetail.descriptionContent != nil){
        RTLabel *textView = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth-40, 1000)];
        
        textView.delegate = self;
        textView.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
        textView.backgroundColor = [UIColor clearColor];
        textView.userInteractionEnabled = YES;
        // UIFont *test = textView.font;//time news roman 12 pixel
        [textView setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 20: 18]];
        textView.tag =60;
        [textView setText:promotionDetail.descriptionContent];
        //textView.text = para.descriptionContent;
        [textView setNeedsDisplay];
        
        [textView setFrame:CGRectMake(0, 0, textView.frame.size.width, textView.optimumSize.height)];
        [self.content.contentArray addObject:textView];
        
        
    }
    /////
    int i = 1;
    for(ParagraphPromotion *para in promotionDetail.subContent){
        if(para.descriptionContent != nil){
            
            RTLabel *textView = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth-20, 1000)];
            para.descriptionContent = [para.descriptionContent stringByReplacingOccurrencesOfString:@"<br />"
                                                                                         withString:@"\n"];
            textView.delegate = self;
            textView.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
            textView.backgroundColor = [UIColor clearColor];
            textView.userInteractionEnabled = YES;
            // UIFont *test = textView.font;//time news roman 12 pixel
            [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:IDIOM==IPAD ? 18: 16]];
            textView.tag =88;
            [textView setText:para.descriptionContent];
            //textView.text = para.descriptionContent;
            [textView setNeedsDisplay];
            
                [textView setFrame:CGRectMake(0, 0, textView.frame.size.width, textView.optimumSize.height+10)];
            [self.content.contentArray addObject:textView];
            
            NSError *error = nil;
            NSString *html = para.descriptionContent;
            HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
            
            if (error) {
                NSLog(@"Error: %@", error);
              
            }
            else{
                NSMutableArray *imageTag = [[NSMutableArray alloc]init];
                HTMLNode *bodyNode = [parser body];
                
                
                NSArray *spanNodes = [bodyNode findChildTags:@"a"];
                
                for (HTMLNode *spanNode in spanNodes) {
                    if ([spanNode getAttributeNamed:@"href"]) {
                        
                        NSString * href = [spanNode getAttributeNamed:@"href"];
                        HTMLNode * temp = [spanNode findChildTag:@"img"];
                        
                        if(temp){
                            [ imageTag addObject:[temp getAttributeNamed:@"src"]];
                                    ImageViewWithLink *imageView = [[ImageViewWithLink alloc]init];
                                    [self.content.contentArray addObject:imageView];
                                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                                    
                                    imageView.url =[NSURL URLWithString:[href stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
                                    [manager downloadImageWithURL:[NSURL URLWithString:[temp getAttributeNamed:@"src"]]
                                     
                                                          options:0
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                             // progression tracking code
                                                         }
                                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                            if (image) {
                                                                [imageView setImage:image];
                                                                
                                                                float width = scrollViewWidth;
                                                                if(width> image.size.width){
                                                                    width = image.size.width;
                                                                }
                                                                [imageView setFrame:CGRectMake(0, 0, width, (image.size.height * width)/image.size.width  )];
                                                                [self setFrameContent];
                                                                [imageView setUserInteractionEnabled:YES];
                                                                UITapGestureRecognizer *singleFingerTap =
                                                                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                        action:@selector(onTouchImage:)];
                                                                [imageView addGestureRecognizer:singleFingerTap];
                                                                
                                                            }
                                                            
                                                            
                                                        }];

                            
                        }
                    }
                }
                
                
                NSArray *inputNodes = [bodyNode findChildTags:@"img"];
                
                for (HTMLNode *inputNode in inputNodes) {
                    BOOL canDraw = YES;
                    for(NSString *imagelink in imageTag){
                        if([imagelink isEqualToString: [inputNode getAttributeNamed:@"src"] ]){
                            canDraw = NO;
                        }
                    }
                    if([inputNode getAttributeNamed:@"src"] && canDraw == YES){
                        
                        [imageTag addObject:[inputNode getAttributeNamed:@"src"]];
                        ImageViewWithLink *imageView = [[ImageViewWithLink alloc]init];
                        [self.content.contentArray addObject:imageView];
                        [imageView setContentMode:UIViewContentModeScaleAspectFit];
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        
                        [manager downloadImageWithURL:[NSURL URLWithString:[inputNode getAttributeNamed:@"src"]]
                         
                                              options:0
                                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                 // progression tracking code
                                             }
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                if (image) {
                                                    [imageView setImage:image];
                                                    
                                                    float width = scrollViewWidth;
                                                    if(width> image.size.width){
                                                        width = image.size.width;
                                                    }
                                                    [imageView setFrame:CGRectMake(0, 0, width, (image.size.height * width)/image.size.width  )];
                                                    [self setFrameContent];
                                                    
                                                    
                                                }
                                                
                                                
                                            }];
                        
                    }

                }


            }
            
        }
        if(para.images != nil){
            width = screenWidth;
            if(image.size.width < width)
                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width,image.size.height  )];
            else
                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, (width*image.size.height)/ image.size.width  )];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:para.images.imageW1]
                 
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            [imageView setImage:image];
                                            imageView.tag = 66;
                                            float width = scrollViewWidth;
                                            
                                            [imageView setFrame:CGRectMake(0, 0, width, (image.size.height * width)/image.size.width  )];
                                            [self setFrameContent];
                                        }
                                        
                                        
                                    }];
            }
            else{
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:para.images.imageW1]
                 
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            [imageView setImage:image];
                                            imageView.tag = 66;
                                            float width = scrollViewWidth;
                                            
                                            [imageView setFrame:CGRectMake(0, 0, width, (image.size.height * width)/image.size.width )];
                                            [self setFrameContent];
                                        }
                                        
                                        
                                    }];
            }
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(handlePinch:)];
            pgr.delegate = self;
            [imageView addGestureRecognizer:pgr];
            imageView.tag = i++;
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.content.contentArray addObject:imageView];
        }
    }
    
    [self setFrameContent];
}
-(void)onTouchImage:(UITapGestureRecognizer*)gesture{
    ImageViewWithLink *tableGridImage = (ImageViewWithLink*)gesture.view;
    
     [[UIApplication sharedApplication] openURL:tableGridImage.url];
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
                [temp setFrame:CGRectMake(0, y+((promotionDetail.isDisplayIntro == YES) ? 10 : 10), _scrollView.frame.size.width, temp.frame.size.height)];
                break;
            case 66:
                [temp setFrame:CGRectMake(0, y, _scrollView.frame.size.width, temp.frame.size.height)];
                break;
            case 60:
                [temp setFrame:CGRectMake(x+10, y+20, _scrollView.frame.size.width-40, temp.frame.size.height)];
                break;
            case 99:
                [temp setFrame:CGRectMake(x, y, _scrollView.frame.size.width-20, temp.frame.size.height)];
                break;
            case 88:
                [temp setFrame:CGRectMake(x, y, _scrollView.frame.size.width-20, temp.frame.size.height)];
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
    [contentView setFrame:CGRectMake(0, titleHeader.frame.origin.y+titleHeader.frame.size.height+(IDIOM == IPAD ? 20 : 10), scrollViewWidth, y)];
    [self.scrollView addSubview:contentView];
    [contentView setBackgroundColor:[UIColor colorWithHexString:BLOCK_COLOR]];
    contentView.layer.masksToBounds = NO;
    contentView.layer.shadowOffset = CGSizeMake(1, 1);
    contentView.layer.shadowRadius = 2;
    contentView.layer.shadowOpacity = 0.5;
    contentView.layer.shouldRasterize = YES;
    contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    ////
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, contentView.frame.size.height+contentView.frame.origin.y+title.frame.size.height+20)];
}
- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
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
-(void)setup_header{
    
    /// set navigation bar image
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LOGO_NAVIGATIONBAR]];
    self.navigationItem.title = @"โปรโมชั่น";
    ///
    contentView = [[UIView alloc]initWithFrame:self.view.frame];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height-60)];
    scrollViewWidth = self.scrollView.frame.size.width;
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    self.scrollView.clipsToBounds  = NO;
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    
    imageHeader = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, self.view.frame.size.width, [[Manager sharedManager]bannerHeight] )];
    
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
    
    
    [_carousel setUserInteractionEnabled:NO];
    
    // Page Control
    //    if(!pageControl)
    //        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, (self.carousel.frame.size.height-20), self.carousel.frame.size.width, 20.0f)];
    //    pageControl.numberOfPages = 5;
    //    pageControl.currentPage = 0;
    //    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.8];
    //    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:SIDE_BAR_COLOR];
    //    pageControl.userInteractionEnabled = NO;
    //    [_carousel addSubview:pageControl];
    //    [NSTimer scheduledTimerWithTimeInterval:5.0f
    //                                     target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
    
    [self.scrollView addSubview:imageHeader];
    
    [self.scrollView sendSubviewToBack:imageHeader];
    
    titleHeader=[[UILabel alloc] initWithFrame:CGRectMake(0,imageHeader.frame.size.height+imageHeader.frame.origin.y+5, screenWidth-20, 30)];
    if ( IDIOM == IPAD ) {
        titleHeader=[[UILabel alloc] initWithFrame:CGRectMake(0,imageHeader.frame.size.height+imageHeader.frame.origin.y+5, screenWidth-20, 50)];
        
    }
    titleHeader.lineBreakMode = NSLineBreakByWordWrapping;
    titleHeader.numberOfLines = 0;
    [titleHeader setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM == IPAD ? 24 : 20]];
    
    [titleHeader setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
    [titleHeader setText:promotionDetail.title];
    
    
    [self.scrollView addSubview:titleHeader];
    
    
}
#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"did select url %@", url);
    //    DtacWebViewViewController *webViewDtac = [[DtacWebViewViewController alloc]init];
    //    webViewDtac.url = url;
    //    webViewDtac.themeColor = [UIColor colorWithHexString:COLOR_PROMOTION];
    //    webViewDtac.titlePage = @"โปรโมชั่น";
    //    UIBarButtonItem *newBackButton =
    //    [[UIBarButtonItem alloc] initWithTitle:@" "
    //                                     style:UIBarButtonItemStyleBordered
    //                                    target:nil
    //                                    action:nil];
    //    [self.navigationItem setBackBarButtonItem:newBackButton];
    //    [newBackButton setTintColor:[UIColor colorWithHexString:SIDE_BAR_COLOR]];
    //    [self.navigationController pushViewController:webViewDtac animated:YES];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+20);
    textView.frame = newFrame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self setCateID:LIFESTYLE];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_PROMOTION]   ,
       NSFontAttributeName:[UIFont fontWithName:FONT_DTAC_LIGHT size:21]}];
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    // Do any additional setup after loading the view.
    [self setup_header];
    [self getPromotionDetail];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)runLoop:(NSTimer*)NSTimer{
    
    if(_carousel)
        [_carousel scrollToItemAtIndex:self.carousel.currentItemIndex+1 animated:YES];
    
    
    
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
    return 1;
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
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:promotionDetail.images.imageM1]
                       
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
