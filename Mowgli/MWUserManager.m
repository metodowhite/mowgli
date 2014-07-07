//
//  MWUserManager.m
//  LoginRegister
//
//  Created by Cristian Díaz on 20/04/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWUserManager.h"

#import <UICKeyChainStore/UICKeyChainStore.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>

#import "MWGUser.h"
#import "MWSocialAvatar.h"

@import Social;
@import Accounts;


@interface MWUserManager()

@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *accountType;
@property (nonatomic) NSArray *availableTwitterAccounts;
@property (nonatomic) ACAccount *userACAccount;
@property (nonatomic) NSString *uuid;

@property (nonatomic, strong) CLLocationManager *locationManager;
@end


@implementation MWUserManager

static NSString *keychainServiceName = @"com.metodowhite.mowgli";
#warning Required ACFacebookAppIdKey if special permissions asked.
static const NSString *kFacebookAppIdKey = @"";


#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [NSException raise:@"MWUserManagerInitialization"
                    format:@"Use initWithUserModel:BaaSConnector:, not init"];
    }
    return self;
}


#pragma mark - Login/Register Methods

- (void)loginRegisterWithFacebook {
    if (!self.userInKeychain) {
        [self requestFacebookUser];
    } else {
        [self loginWithCurrentACAccount];
    }
}

- (void)loginRegisterWithTwitter {
    if (!self.userInKeychain) {
        [self requestTwitterUser];
    } else {
        [self loginWithCurrentACAccount];
    }
}

- (void)loginWithCurrentACAccount {
    //    MWGUser *newUser = [[MWGUser alloc] initWithACAccount:_userACAccount];
    //    [self loginWithUser:newUser];
}

- (void)registerWithACAccount {
    //    MWGUser *newUser = [[MWGUser alloc] initWithACAccount:_userACAccount];
    //    [self registerWithUser:newUser];
}

- (void)loginWithUser:(MWGUser *)user {
    //    [self.BAASConnector logInWithUser:user delegate:self];
    //    [self.BAASConnector logInWithUser:user completion:^(MWGUser * leLoggedUser, NSError *anError) {
    //        if (!anError) {
    //            [self userLoginDidSuccess:leLoggedUser];
    //        } else {
    //            [self registerWithUser:user];
    //        }
    //    }];
}

- (void)registerWithUser:(MWGUser *)user {
    //    [self.BAASConnector registerWithUser:user delegate:self];
}

- (void)requestLogOut {
    [self deleteUserInKeyChain];
    //    [self.BAASConnector requestLogOut];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


#pragma mark - Social Accounts Methods

- (void)requestTwitterUser {
    self.accountStore = [ACAccountStore new];
    self.accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:_accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            _availableTwitterAccounts = [self.accountStore accountsWithAccountType:_accountType];
            
            if (_availableTwitterAccounts.count == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self showAlertWithTitle:@"Twitter account not found" message:@"Please setup your account in Settings app."];
                });
                
            } else if (_availableTwitterAccounts.count == 1) {
                
                self.userACAccount = [_availableTwitterAccounts firstObject];
                [self loginWithCurrentACAccount];
                
            } else if (_availableTwitterAccounts.count > 1) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    NSMutableArray *accounts = [[NSMutableArray alloc] init];
                    for (ACAccount *twitterAccount in _availableTwitterAccounts) {
                        [accounts addObject:twitterAccount.accountDescription];
                    }
                    
                    [UIAlertView showWithTitle:@"Select Twitter Account"
                                       message:nil
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:accounts
                                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                          if (buttonIndex == alertView.cancelButtonIndex) {
                                              NSLog(@"Cancel button tapped.");
                                              return;
                                          }
                                          
                                          NSInteger indexInAvailableTwitterAccountsArray = buttonIndex - 1;
                                          self.userACAccount = [_availableTwitterAccounts objectAtIndex:indexInAvailableTwitterAccountsArray];
                                          [self loginWithCurrentACAccount];
                                      }];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self showAlertWithTitle:@"Error" message:@"Access to Twitter accounts was not granted."];
            });
        }
    }];
}

- (void)requestFacebookUser {
    self.accountStore = [ACAccountStore new];
    self.accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{ACFacebookAppIdKey:kFacebookAppIdKey,
                              ACFacebookPermissionsKey: @[@"email"]};
    
    [self.accountStore requestAccessToAccountsWithType:_accountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accountsArr = [_accountStore accountsWithAccountType:_accountType];
            
            if ([accountsArr count]) {
                self.userACAccount = [accountsArr lastObject];
                [self loginWithCurrentACAccount];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSLog(@"%@",error.description);
                if([error code] == ACErrorAccountNotFound) {
                    [self showAlertWithTitle:@"Facebook account not found" message:@"Please setup your account in Settings app."];
                } else {
                    [self showAlertWithTitle:@"Error" message:@"Access to Facebook account was not granted."];
                }
            });
        }
    }];
}


#pragma mark - Keychain Methods

- (BOOL)userInKeychain {
    if([[UICKeyChainStore keyChainStoreWithService:keychainServiceName] stringForKey:@"uuid"] != nil) {
        self.uuid = [[UICKeyChainStore keyChainStoreWithService:keychainServiceName] stringForKey:@"uuid"];
        return YES;
    } else {
        self.uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return NO;
    }
}

- (void)loginWithUserInKeychain {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keychainServiceName];
    // NSLog(@"%@", store); // Print all keys and values for the service.
    
    MWGUser *keychainUser = [[MWGUser alloc] init];
    
    if ([store stringForKey:@"login"]) {
        keychainUser.login = [store stringForKey:@"login"];
    }
    
    if ([store stringForKey:@"email"]) {
        keychainUser.email = [store stringForKey:@"email"];
    }
    
    keychainUser.fullName = [[UICKeyChainStore keyChainStoreWithService:keychainServiceName] stringForKey:@"fullName"];
    keychainUser.password = [[UICKeyChainStore keyChainStoreWithService:keychainServiceName] stringForKey:@"password"];
    
    [self loginWithUser:keychainUser];
}

- (void)saveUserInKeyChain:(MWGUser *)user {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keychainServiceName];
    [store setString:_uuid forKey:@"uuid"];
    
    MWGUser *userToSave = user;
    
    if (userToSave.login) {
        [store setString:userToSave.login forKey:@"login"];
    }
    
    if (userToSave.email) {
        [store setString:userToSave.email forKey:@"email"];
    }
    
    [store setString:userToSave.fullName forKey:@"fullName"];
    [store setString:userToSave.password forKey:@"password"];

    [store synchronize];
    
    NSLog(@"%@", store); // Print all keys and values for the service.
}

- (void)deleteUserInKeyChain {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:keychainServiceName];
    [store removeItemForKey:@"uuid"];
    [store removeItemForKey:@"userAccount"];
    [store removeItemForKey:@"login"];
    [store removeItemForKey:@"email"];
    [store removeItemForKey:@"password"];
    [store removeItemForKey:@"fullName"];
    
    [store synchronize];
}


#pragma mark - MWUserManagerDelegate Protocol Methods

- (void)userLoginDidFail {
    NSLog(@"User Login Did Fail.");
    
    [UIAlertView showWithTitle:@"User not recognized"
                       message:@"You need to be logged into Gossier"
             cancelButtonTitle:@"Ok"
             otherButtonTitles:nil
                      tapBlock:nil];
};

- (void)userLoginDidSuccess:(MWGUser *)user {
    NSLog(@"Great! User Logged.\n");
    
    if (!self.userInKeychain) {
        [self saveUserInKeyChain:user];
    }
}

- (void)userRegisterDidFail {
    [self showAlertWithTitle:@"Frak!" message:@"User Registration Did Fail."];
};

- (void)userDidLogout {
//    [self.delegate userDidLogout];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Alert Utils

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg {
    [UIAlertView showWithTitle:title
                       message:msg
             cancelButtonTitle:@"Ok"
             otherButtonTitles:nil
                      tapBlock:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return; // User Canceled
    }
    
    NSInteger indexInAvailableTwitterAccountsArray = buttonIndex - 1;
    self.userACAccount = [_availableTwitterAccounts objectAtIndex:indexInAvailableTwitterAccountsArray];
    [self loginWithCurrentACAccount];
}


#pragma mark - Location methods

void(^getUserLocationCallback)(CLLocation *locationResponse);

- (void)getUserLocation:(GSRLocationCompletionBlock)callback {
    [self requestLocationServicesAuthorization];
    getUserLocationCallback = callback;
}

- (void)requestLocationServicesAuthorization {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
#if __IPHONE_8_0 >= __IPHONE_OS_VERSION_MAX_ALLOWED
    [self.locationManager requestAlwaysAuthorization];
#endif
    
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    
    getUserLocationCallback(location);
    
}


@end

