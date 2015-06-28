//
//  ShotsCustomCell.h
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShotsCustomCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *Image;
@property(nonatomic, weak) IBOutlet UILabel *Title, *ViewsCount;

@end
