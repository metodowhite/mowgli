//
//  MWGLists.m
//  Mowgli
//
//  Created by Cristian Díaz on 03/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWGListsManager.h"
#import "MWGUser.h"
#import "MWGList.h"

@interface MWGListsManager ()

@end

@implementation MWGListsManager

#pragma mark - Public Methods

+ (id)sharedInstance {
	static dispatch_once_t predicate;
	static MWGListsManager *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
		self.lists = [NSMutableArray array];
		self.selectedLists  = [NSMutableArray array];
		
        [[MWGUser sharedMWGUser] login];
        [[[MWGUser sharedMWGUser] loggingSignal] subscribeCompleted:^{
            [self getMyParseLists];
        }];
    }
    return self;
}

- (void)modelUpdated {
	self.listsUpdated = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        [subscriber sendNext:self];
        return nil;
    }];
}


#pragma mark - Parse Methods

- (void)getMyParseLists {
    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
	[query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *parseLists, NSError *error) {
        if (!error) {
            for (NSDictionary *list in parseLists) {
                [self.lists addObject:list];
            }
			[self modelUpdated];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)addListWithName:(NSString *)name {
    PFObject *list = [PFObject objectWithClassName:@"List"];
    list[@"name"] = name;
    list[@"owner"] = [PFUser currentUser];
    [list saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.lists removeAllObjects];
            [self getMyParseLists];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


@end
