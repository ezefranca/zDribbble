//
//  Shots.m
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "Shots.h"

@implementation Shots

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"shotId": @"id",
             @"shotTitle": @"title",
             @"shotDescription": @"description",
             @"shotHeigth": @"height",
             @"shotWidth": @"width",
             @"shotLikesCount": @"likes_count",
             @"shotCommentsCount": @"comments_count",
             @"shotReboundsCount": @"rebounds_count",
             @"shotUrl": @"url",
             @"shotShortUrl": @"short_url",
             @"shotViewsCount": @"views_count",
             @"shotReboundSourceId": @"rebound_source_id",
             @"shotImageUrl": @"image_url",
             @"shotImageTeaserUrl": @"image_teaser_url",
             @"shotImage400Url": @"image_400_url",
             @"shotPlayer": @"player",
             @"shotCreatedAt": @"created_at"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    //    _Player = [[Player alloc] initWithDictionary:[dictionaryValue objectForKey:@"Player"] error:nil];
    _shotPlayer = [MTLJSONAdapter modelOfClass:[Player class] fromJSONDictionary:[dictionaryValue objectForKey:@"shotPlayer"] error:nil];
    
    return self;
}

@end