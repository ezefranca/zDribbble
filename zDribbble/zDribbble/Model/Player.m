//
//  Player.m
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "Player.h"

@implementation Player

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"playerId": @"id",
             @"playerName": @"name",
             @"playerLocation": @"location",
             @"playerFollowersCount": @"followers_count",
             @"playerDrafteesCount": @"draftees_count",
             @"playerLikesCount": @"likes_count",
             @"playerLikesReceivedCount": @"likes_received_count",
             @"playerCommentsCount": @"comments_count",
             @"playerCommentsReceivedCount": @"comments_received_count",
             @"playerReboundsCount": @"rebounds_count",
             @"playerReboundsReceivedCount": @"rebounds_received_count",
             @"playerUrl": @"url",
             @"playerAvatarUrl": @"avatar_url",
             @"playerUsername": @"username",
             @"playerTwitterScreenName": @"twitter_screen_name",
             @"playerWebsiteUrl": @"website_url",
             @"playerDraftedByPlayerId": @"drafted_by_player_id",
             @"playerShotsCount": @"shots_count",
             @"playerFollowingCount": @"following_count",
             @"playerCreatedAt": @"created_at"
             };
}

@end
