//
//  MWGMovie.m
//  Mowgli
//
//  Created by Cristian Díaz on 01/02/14.
//  Copyright (c) 2014 luisa. All rights reserved.
//

#import "MWGMovie.h"

@implementation MWGMovie

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"adult": @"adult",
             @"backdropPath": @"backdrop_path",
             @"movieId": @"id",
             @"originalTitle": @"original_title",
             @"popularity": @"popularity",
             @"posterPath": @"poster_path",
             @"releaseDate": @"release_date",
             @"title": @"title",
             @"voteAverage": @"vote_average",
             @"voteCount": @"vote_count"
             };
}


@end
