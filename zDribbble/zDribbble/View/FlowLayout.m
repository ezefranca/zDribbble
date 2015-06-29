//
//  FlowLayout.m
//  zDribbble
//
//  Created by Ezequiel on 6/29/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "FlowLayout.h"

@implementation FlowLayout

- (void)prepareLayout {
    self.itemSize = self.collectionView.frame.size;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.pagingEnabled = NO;
    self.minimumLineSpacing = 0.0;
    self.minimumInteritemSpacing = 0.0;
    self.sectionInset = UIEdgeInsetsZero;
    self.footerReferenceSize = CGSizeZero;
    self.headerReferenceSize = CGSizeZero;
}

@end
