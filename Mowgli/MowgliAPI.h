//
//  MowgliAPI.h
//  Mowgli
//
//  Created by Cristian Díaz on 07/07/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MWGNetwork) {
    MWGNetworkTwitter,
    MWGNetworkFacebook
};

#import <Foundation/Foundation.h>

@interface MowgliAPI : NSObject

extern NSString * const MWGUserLoginDidSuccessNotification;
extern NSString * const MWGUserLogOutDidSuccesNotification;

@property (nonatomic, readonly) NSString *kTMDbBaseURL;
@property (nonatomic, readonly) NSArray *kTMDbPosterSizes;

+ (instancetype)sharedInstance;


#pragma mark - Session

typedef void (^tmdbLoadMoviesBlock)(NSArray *movies, NSError *anError);
- (void)loadMoviesPageNumber:(NSInteger)pageNumber withCompletion:(tmdbLoadMoviesBlock)completion;


#pragma mark - Utils

- (NSURL *)applicationDocumentsDirectory;

@end
