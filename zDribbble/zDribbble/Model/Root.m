//
//  Root.m
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "Root.h"

@implementation Root

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"rootPage": @"page",
             @"rootPerPage": @"per_page",
             @"rootPages": @"pages",
             @"rootShots": @"shots"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    //    _Player = [[Player alloc] initWithDictionary:[dictionaryValue objectForKey:@"Player"] error:nil];
   // _rootShots = [MTLJSONAdapter modelOfClass:[Shots class] fromJSONDictionary:[dictionaryValue objectForKey:@"rootShots"] error:nil];
    
    return self;
}
@end

