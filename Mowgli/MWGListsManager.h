//
//  MWGLists.h
//  Mowgli
//
//  Created by Cristian Díaz on 03/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWGListsManager : NSObject

+(id)sharedInstance;
- (void)addListWithName:(NSString *)name;

//@property(strong, nonatomic) RACSignal *listsUpdated;
@property(strong, nonatomic) NSMutableArray *lists;
@property(assign, getter=isAddingMovie) BOOL addingMovie;
@property(strong, nonatomic) NSMutableArray *selectedLists;

@end
