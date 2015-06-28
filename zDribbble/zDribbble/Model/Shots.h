//
//  Shots.h
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "Player.h"

@interface Shots : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readwrite) NSNumber *shotId;
@property (strong, nonatomic, readwrite) NSString *shotTitle;
@property (strong, nonatomic, readwrite) NSString *shotDescription;
@property (strong, nonatomic, readwrite) NSNumber *shotHeigth;
@property (strong, nonatomic, readwrite) NSNumber *shotWidth;
@property (strong, nonatomic, readwrite) NSNumber *shotLikesCount;
@property (strong, nonatomic, readwrite) NSNumber *shotCommentsCount;
@property (strong, nonatomic, readwrite) NSNumber *shotReboundsCount;
@property (strong, nonatomic, readwrite) NSString *shotUrl;
@property (strong, nonatomic, readwrite) NSString *shotShortUrl;
@property (strong, nonatomic, readwrite) NSNumber *shotViewsCount;
@property (strong, nonatomic, readwrite) NSNumber *shotReboundSourceId;
@property (strong, nonatomic, readwrite) NSNumber *shotImageUrl;
@property (strong, nonatomic, readwrite) NSNumber *shotImageTeaserUrl;
@property (strong, nonatomic, readwrite) NSString *shotImage400Url;
@property (strong, nonatomic, readwrite) Player   *shotPlayer;
@property (strong, nonatomic, readwrite) NSString *shotCreatedAt;

@end
