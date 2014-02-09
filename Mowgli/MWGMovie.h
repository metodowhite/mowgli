//
//  MWGMovie.h
//  Mowgli
//
//  Created by Cristian Díaz on 01/02/14.
//  Copyright (c) 2014 luisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface MWGMovie : MTLModel <MTLJSONSerializing>

@property (copy, readonly, nonatomic) NSNumber *adult;
@property (copy, readonly, nonatomic) NSString *backdropPath;
@property (copy, readonly, nonatomic) NSNumber *movieId;
@property (copy, readonly, nonatomic) NSString *originalTitle;
@property (copy, readonly, nonatomic) NSNumber *popularity;
@property (copy, readonly, nonatomic) NSString *posterPath;
@property (copy, readonly, nonatomic) NSDate *releaseDate;
@property (copy, readonly, nonatomic) NSString *title;
@property (copy, readonly, nonatomic) NSNumber *voteAverage;
@property (copy, readonly, nonatomic) NSNumber *voteCount;

//TODO: listar propiedades relativas a listas y funciones internas.

@end
