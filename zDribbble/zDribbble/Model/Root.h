//
//  Root.h
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "MTLModel.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "Shots.h"

@interface Root : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readwrite) NSNumber *rootPage;
@property (strong, nonatomic, readwrite) NSNumber *rootPerPage;
@property (strong, nonatomic, readwrite) NSNumber *rootPages;
@property (strong, nonatomic, readwrite) NSArray *rootShots;

@end
