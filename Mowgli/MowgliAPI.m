//
//  MowgliAPI.m
//  Mowgli
//
//  Created by Cristian Díaz on 07/07/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MowgliAPI.h"

#import "MWGMovie.h"
#import <JLTMDbClient/JLTMDbClient.h>
#import <Mantle/Mantle.h>


@interface MowgliAPI()
@property (nonatomic) NSMutableArray *moviesArr;
@end

@implementation MowgliAPI

NSString *const MWGUserLoginDidSuccessNotification = @"MWGUserLoginDidSuccessNotification";
NSString *const MWGUserLogOutDidSuccesNotification = @"MWGUserLogOutDidSuccesNotification";

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadTMDbConf];
    }
    return self;
}


#pragma mark - TMDb

- (void)loadTMDbConf {
    [[JLTMDbClient sharedAPIInstance] setAPIKey:@"4552c3fa51f05ffc09b73912931a5406"];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(NSDictionary *response, NSError *error) {
        if(!error){
            _kTMDbBaseURL = response[@"images"][@"base_url"];
            _kTMDbPosterSizes = response[@"images"][@"poster_sizes"];
            self.moviesArr = [NSMutableArray array];
        }
    }];
}

- (void)loadMoviesPageNumber:(NSInteger)pageNumber withCompletion:(tmdbLoadMoviesBlock)completion {
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:@{@"page":@(pageNumber)} andResponseBlock:^(NSDictionary *response, NSError *error) {
        if(!error){
            for (NSDictionary *movie in response[@"results"]) {
                MWGMovie *newMovie = [MTLJSONAdapter modelOfClass:MWGMovie.class fromJSONDictionary:movie error:&error];
                if (newMovie.posterPath != NULL) {
                    [self.moviesArr addObject:newMovie];
                }
            }
            completion(_moviesArr, nil);
        } else {
            completion(nil, error);
        }
    }];
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
