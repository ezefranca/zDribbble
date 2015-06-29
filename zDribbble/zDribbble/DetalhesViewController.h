//
//  DetalhesViewController.h
//  zDribbble
//
//  Created by Ezequiel on 6/29/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shots.h"
#import "UIImageView+WebCache.h"

@interface DetalhesViewController : UIViewController

@property(nonatomic, strong) Shots *shot;


@property(nonatomic, weak) IBOutlet UILabel *shotDescription;

@property (strong, nonatomic) IBOutlet UIImageView *shotImage;
@property (strong, nonatomic) IBOutlet UIImageView *playerPhoto;
@property (strong, nonatomic) IBOutlet UILabel *shotTitle;
@property (strong, nonatomic) IBOutlet UILabel *shotViewCount;
@property (strong, nonatomic) IBOutlet UILabel *playerName;

@end
