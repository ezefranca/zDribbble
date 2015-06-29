//
//  ViewController.h
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+AFNetworking.h"
#import "AFURLSessionManager.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Root.h"
#import "ShotsCustomCell.h"

#define DRIBBBLE_API_URL @"http://api.dribbble.com/shots/popular"

@interface ShotsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

//Principal
@property(nonatomic,weak) IBOutlet UICollectionView *shotsList;

//Para o pull refresh custom
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;


@end

