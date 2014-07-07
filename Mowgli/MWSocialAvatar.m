//
//  MWSocialAvatar.m
//  Gossier
//
//  Created by Cristian Díaz on 24/06/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWSocialAvatar.h"


@implementation MWSocialAvatar


#pragma mark - Avatar

- (void)getACAccountAvatar:(ACAccount *)account withCallback:(getUserSocialAvatarBlock)callback {
    
    if ([account.accountType.identifier isEqual:ACAccountTypeIdentifierFacebook]) {
        [self getFacebookAvatar:account.username withCallback:^(UIImage *imageResponse) {
            callback(imageResponse);
        }];
    } else if([account.accountType.identifier isEqual:ACAccountTypeIdentifierTwitter]) {
        [self getTwitterAvatar:account.username withCallback:^(UIImage *imageResponse) {
            callback(imageResponse);
        }];
    }
}

- (void)getTwitterAvatar:(NSString *)username withCallback:(getUserSocialAvatarBlock)callback {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    NSDictionary *params = @{@"screen_name" : username};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    // [request setAccount:account];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(responseData) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:&error];
            if(responseDictionary) {
                // http://www.visuallizard.com/blog/2011/02/07/twitter-avatar-image-sizes
                NSString *url_image = [responseDictionary[@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal"
                                                                                                          withString:@""];
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_image]];
                callback([UIImage imageWithData:imageData]);
            }
        } else {
            NSLog(@"JSON Error: %@", [error localizedDescription]);
        }
    }];
}

- (void)getFacebookAvatar:(NSString *)username withCallback:(getUserSocialAvatarBlock)callback {
    // https://developers.facebook.com/docs/reference/api/using-pictures/
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", username]]];
    callback([UIImage imageWithData:imageData]);
}

@end











