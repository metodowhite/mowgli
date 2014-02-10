//
//  MWGListMoviesTableViewController.h
//  Mowgli
//
//  Created by Cristian Díaz on 10/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface MWGListMoviesTableViewController : UITableViewController
@property(strong, nonatomic)PFObject *list;
-(void)cleanup;
@end
