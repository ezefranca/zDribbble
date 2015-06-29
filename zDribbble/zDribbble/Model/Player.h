//
//  Player.h
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Player : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readwrite) NSString *playerId;
@property (strong, nonatomic, readwrite) NSString *playerName;
@property (strong, nonatomic, readwrite) NSString *playerLocation;
@property (strong, nonatomic, readwrite) NSNumber *playerFollowersCount;
@property (strong, nonatomic, readwrite) NSNumber *playerDrafteesCount;
@property (strong, nonatomic, readwrite) NSNumber *playerLikesCount;
@property (strong, nonatomic, readwrite) NSNumber *playerLikesReceivedCount;
@property (strong, nonatomic, readwrite) NSNumber *playerCommentsCount;
@property (strong, nonatomic, readwrite) NSNumber *playerCommentsReceivedCount;
@property (strong, nonatomic, readwrite) NSNumber *playerReboundsCount;
@property (strong, nonatomic, readwrite) NSNumber *playerReboundsReceivedCount;
@property (strong, nonatomic, readwrite) NSURL *playerUrl;
@property (strong, nonatomic, readwrite) NSURL *playerAvatarUrl;
@property (strong, nonatomic, readwrite) NSNumber *playerUsername;
@property (strong, nonatomic, readwrite) NSString *playerTwitterScreenName;
@property (strong, nonatomic, readwrite) NSURL *playerWebsiteUrl;
@property (strong, nonatomic, readwrite) NSString *playerDraftedByPlayerId;
@property (strong, nonatomic, readwrite) NSNumber *playerShotsCount;
@property (strong, nonatomic, readwrite) NSNumber *playerFollowingCount;
@property (strong, nonatomic, readwrite) NSString *playerCreatedAt;

@end
