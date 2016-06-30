//
//  FreeZoneGameDetailCell.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/6/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "FreeZoneAppDetailCell.h"
#import "Constant.h"
#import "UIColor+Extensions.h"
#import "SocialView.h"
#import "MyFlowLayout.h"
#import "GallaryObject.h"
#import "DtacImage.h"
#import "Manager.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation FreeZoneAppDetailCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //casetitude_popup_delete
        //float h = frame.size.height;
        float w = frame.size.width;
        [self setBackgroundColor:[UIColor whiteColor]];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(w*0.1,0, w*0.8,w*0.8);
       // [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor whiteColor]];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setClipsToBounds:YES];
        [_imageView setImage:[UIImage imageNamed:@"default_image_02_L.jpg"]];
        
        
        [self addSubview:_imageView];
   
        
        
       
        
        
        
        _socialView = [[[NSBundle mainBundle] loadNibNamed:@"SocialView" owner:self options:nil] objectAtIndex:0];
        [_socialView setFrame:CGRectMake(_imageView.frame.origin.x+10,_imageView.frame.size.height+10, _imageView.frame.size.width-20, 30)];
        [self addSubview:_socialView];
        
        
        
        _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(10,_socialView.frame.size.height+_socialView.frame.origin.y+10, self.frame.size.width, 20)];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 0;
        [_titleLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_titleLabel setFont:[UIFont fontWithName:FONT_DTAC_BOLD size:IDIOM == IPAD ? 16 : 14]];
        
        
        _detailLabel = [[RTLabel alloc]initWithFrame:CGRectMake(10,_titleLabel.frame.size.height+_titleLabel.frame.origin.y+10,self.frame.size.width-20, _imageView.frame.size.height-50)];
        
        _detailLabel.textColor =[UIColor colorWithHexString:DEFAULT_TEXT_COLOR];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.userInteractionEnabled = YES;
        // UIFont *test = textView.font;//time news roman 12 pixel
        [_detailLabel setFont:[UIFont fontWithName:FONT_DTAC_REGULAR size:IDIOM==IPAD ? 14: 12]];
        
        //textView.text = para.descriptionContent;
        [_detailLabel setNeedsDisplay];
        

        [self addSubview:_titleLabel];
        [self addSubview:_detailLabel];
        
        _imageShowcaseLabel= [[UILabel alloc]initWithFrame:CGRectMake(10,_detailLabel.frame.size.height+_detailLabel.frame.origin.y+10, self.frame.size.width, 20)];
        _imageShowcaseLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_imageShowcaseLabel setText:@"ภาพตัวอย่าง"];
        [_imageShowcaseLabel setTextColor:[UIColor colorWithHexString:DEFAULT_TEXT_COLOR]];
        [_imageShowcaseLabel setFont:[UIFont fontWithName:FONT_DTAC_BOLD size:IDIOM == IPAD ? 16 : 14]];
         [self addSubview:_imageShowcaseLabel];
        
        MyFlowLayout *layout=[[MyFlowLayout alloc] init];
        _imageShowCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(10, _imageShowcaseLabel.frame.origin.y+ _imageShowcaseLabel.frame.size.height+20, self.frame.size.width-20, (self.frame.size.width/3-15)*1.7125+(self.frame.size.width/3-15)*1.7125+10) collectionViewLayout:layout];
        
        [_imageShowCollection setDataSource:self];
        [_imageShowCollection setDelegate:self];
        
        [_imageShowCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageBoxinAlbumCollectionViewCell"];
        
        [_imageShowCollection setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_imageShowCollection];
        
        _downloadLabel= [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2,_detailLabel.frame.origin.y+ _detailLabel.frame.size.height, w-_imageView.frame.size.width-10, 30)];
        
        _downloadLabel = [UIButton buttonWithType:UIButtonTypeCustom];
  
        [_downloadLabel setImage:[UIImage imageNamed:@"dtacplay_appstore"] forState:UIControlStateNormal];
        _downloadLabel.frame = CGRectMake(self.frame.size.width/2-125,_socialView.frame.origin.y+ _socialView.frame.size.height, 250, 90);
      
        
        [self addSubview:_downloadLabel];
        
    }
    return self;
}
-(void)setSocialItem{
    if(_app != nil){
        NSString *url;
        
        _socialView.parentView = _parentView;
        url = [NSString stringWithFormat: @"%@app/%@?m=share",DOMAIN_WEBSITE,_app.appID];
        
        
       [_socialView setValueForShareTitle:_app.title Description:_app.descriptionContent ImageUrl:_app.images.imageL ContentURL:url Category:_app.cate SubCategoryType:_app.subcate contentID:[_app.appID intValue]];
        
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return  _screenArray.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0,0,0,0);
    return inset;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=(UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageBoxinAlbumCollectionViewCell" forIndexPath:indexPath];
    NSString *object = _screenArray[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"default_screenshot.jpg"]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:object]
                      
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                [imageView setImage:image];
                                
                            }
                            else{
                               
                            }
                        }];
    
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [cell addSubview:imageView];
    
    [cell setBackgroundColor:[UIColor grayColor]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(self.frame.size.width/3-15, (self.frame.size.width/3-15)*1.7125);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id<ImageShowCaseDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(onTouchImageShowCase:)]) {
        [strongDelegate onTouchImageShowCase:indexPath.row];
    }
}

- (void)layoutSubviews {
    
    //NSLog(@"Printing heading label bounds width: %f", _headingLabel.bounds.size.width);

    
    [super layoutSubviews];
}
@end
//
//  FreeZoneAppDetailCell.m
//
