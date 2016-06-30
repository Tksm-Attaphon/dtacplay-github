//
//  BlockCollectionViewCell.m
//  layout
//
//  Created by attaphon on 9/26/2558 BE.
//  Copyright (c) 2558 attaphon. All rights reserved.
//

#import "BlockCollectionViewCell.h"
#import "ContentPreview.h"
#import "ContentPreviewPromotion.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Manager.h"
@implementation BlockCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setImageViewFromURL{
    
    if([_content isKindOfClass:[ContentPreview class]]){
        ContentPreview* content = _content;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:content.images.imageL]
         
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    _imageView.image = image;
                                }
                            }];
        
    
  
    [self.label setText:content.title];
    }
    else{
        ContentPreviewPromotion* content = _content;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:content.images.imageW1]
                              
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        _imageView.image = image;
                                    }
                                }];
      
        
        [self.label setText:content.title];
    }

}
@end
