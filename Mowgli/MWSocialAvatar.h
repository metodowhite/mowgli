//
//  MWSocialAvatar.h
//  Gossier
//
//  Created by Cristian Díaz on 24/06/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Social;
@import Accounts;


@interface MWSocialAvatar : NSObject

typedef void (^getUserSocialAvatarBlock)(UIImage *imageResponse);

- (void)getACAccountAvatar:(ACAccount *)account withCallback:(getUserSocialAvatarBlock)callback;
- (void)getTwitterAvatar:(NSString *)username withCallback:(getUserSocialAvatarBlock)callback;
- (void)getFacebookAvatar:(NSString *)username withCallback:(getUserSocialAvatarBlock)callback;

@end
