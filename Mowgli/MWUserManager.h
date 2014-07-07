//
//  MWUserManager.h
//  LoginRegister
//
//  Created by Cristian Díaz on 20/04/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWGUser.h"
@import CoreLocation;

@interface MWUserManager : NSObject <CLLocationManagerDelegate>


- (BOOL)userInKeychain;
- (void)loginWithUserInKeychain;

- (void)loginRegisterWithFacebook;
- (void)loginRegisterWithTwitter;
- (void)loginWithUser:(MWGUser *)user;

- (void)requestLogOut;


typedef void (^GSRLocationCompletionBlock)(CLLocation *locationResponse);

- (void)getUserLocation:(GSRLocationCompletionBlock)callback;
- (void)getUsersInRadius:(CGFloat)radius;


@end