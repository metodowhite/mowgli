//
//  MWGMoviesManager.h
//  Mowgli
//
//  Created by Cristian Díaz on 09/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MWGMoviesManager : NSObject

+ (id)sharedInstance;
- (void)addMovies:(NSArray *)movies toLists:(NSArray *)lists;

@property(strong, nonatomic) RACSignal *savedSignal;
@property(strong, nonatomic) NSMutableArray *selectedMovies;

@end
