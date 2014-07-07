//
//  MWGUser.h
//  Mowgli
//
//  Created by Cristian Díaz on 02/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;


@interface MWGUser: NSObject

extern NSString *const GSRUserDidUpdateNotification;

@property (nonatomic) NSUInteger userID;
@property (nonatomic) NSUInteger age;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic) NSString *email;
@property (nonatomic) NSString *login;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *twitterID;
@property (nonatomic) NSString *twitterUserName;
@property (nonatomic) NSString *facebookID;
@property (nonatomic) NSString *facebookUserName;

@property (nonatomic) NSDate *birthday;
@property (nonatomic) UIImage *avatar;
@property (nonatomic) NSURL *avatarUrl;
@property (nonatomic) NSString *aboutMe;

@end
