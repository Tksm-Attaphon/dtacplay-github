//
//  MyFlowLayout.m
//  googlenewstand
//
//  Created by attaphon on 9/20/2558 BE.
//  Copyright (c) 2558 attaphon. All rights reserved.
//

#import "MyFlowLayout.h"

@implementation MyFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn)
    {
        if (nil == attributes.representedElementKind)
        {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

-(CGSize)collectionViewContentSize { //Workaround
    CGSize superSize = [super collectionViewContentSize];
    CGRect frame = self.collectionView.frame;
    return CGSizeMake(fmaxf(superSize.width, CGRectGetWidth(frame)), fmaxf(superSize.height, CGRectGetHeight(frame)));
}
@end
