//
//  MWGListsTableViewController.h
//  Mowgli
//
//  Created by Cristian Díaz on 03/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWGMovie.h"

@interface MWGListsTableViewController : UITableViewController
@property(strong, nonatomic) MWGMovie *movie;
@end
