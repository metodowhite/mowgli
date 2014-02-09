//
//  MWGList.h
//  Mowgli
//
//  Created by Cristian Díaz on 09/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface MWGList : MTLModel <MTLJSONSerializing>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSArray *movies;


@end
