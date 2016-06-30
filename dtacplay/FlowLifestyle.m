//
//  FlowLifestyle.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/28/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "FlowLifestyle.h"

@implementation FlowLifestyle
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    [self fixLayoutAttributeInsets:attribute];
    
    return attribute;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *results = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attribute in results)
    {
        [self fixLayoutAttributeInsets:attribute];
    }
    
    return results;
}

- (void)fixLayoutAttributeInsets:(UICollectionViewLayoutAttributes *)attribute
{
    if ([attribute representedElementKind])
    { //nil means it is a cell, we do not want to change the headers/footers, etc
        return;
    }
    
    //Get the correct section insets
    UIEdgeInsets sectionInsets;
    
    if ([[[self collectionView] delegate] respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        sectionInsets = [(id<UICollectionViewDelegateFlowLayout>)[[self collectionView] delegate] collectionView:[self collectionView] layout:self insetForSectionAtIndex:[[attribute indexPath] section]];
    }
    else
    {
        sectionInsets = [self sectionInset];
    }
    
    //Adjust the x position of the view, the size should be correct or else do more stuff here
    CGRect frame = [attribute frame];
    
    frame.origin.x = sectionInsets.left;
    
    [attribute setFrame:frame];
}
@end
