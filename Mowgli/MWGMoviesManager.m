//
//  MWGMoviesManager.m
//  Mowgli
//
//  Created by Cristian Díaz on 09/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWGMoviesManager.h"
#import "MWGMovie.h"
#import "MWGList.h"
#import <Parse/Parse.h>

@interface MWGMoviesManager ()

@end


@implementation MWGMoviesManager

#pragma mark - Public Methods

+ (id)sharedInstance{
	static dispatch_once_t predicate;
	static MWGMoviesManager *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedMovies = [NSMutableArray array];
		self.listedMovies = [NSMutableArray array];
		[self saveDone]; //TODO: investigar RAC y la ausencia de "send" en caso de no haberse ejecutado el metodo previamente
    }
    return self;
}

- (void)addMovies:(NSArray *)movies toLists:(NSArray *)lists {
	NSMutableArray *parseMovieArr = [NSMutableArray array];
	for (MWGMovie *movie in movies) {
		for (MWGList *list in lists) {
			PFObject *newMovie = [PFObject objectWithClassName:@"Movie"];
			newMovie[@"movieId"] = movie.movieId;
			newMovie[@"title"] = movie.title;
			newMovie[@"list"] = list;
			[parseMovieArr addObject:newMovie];
		}
	}
	[PFObject saveAllInBackground:parseMovieArr block:^(BOOL succeeded, NSError *error) {
		[self saveDone];
	}];
}

- (void)saveDone {
	self.savedSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        [subscriber sendCompleted];
        return nil;
    }];
}


#pragma mark - Parse Methods

- (void)getMoviesFromList:(PFObject *)list{
	PFQuery *query = [PFQuery queryWithClassName:@"Movie"];
    [query whereKey:@"list" equalTo:list];
    [query findObjectsInBackgroundWithBlock:^(NSArray *movies, NSError *error) {
        if (!error) {
            for (NSDictionary *movie in movies) {
                [self.listedMovies addObject:movie];
            }
			[self modelUpdated];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)modelUpdated {
	self.moviesUpdated = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        [subscriber sendCompleted];
        return nil;
    }];
}

@end
