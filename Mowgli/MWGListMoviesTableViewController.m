//
//  MWGListMoviesTableViewController.m
//  Mowgli
//
//  Created by Cristian Díaz on 10/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWGListMoviesTableViewController.h"
#import "MWGMoviesManager.h"
#import "MWGMovie.h"

@interface MWGListMoviesTableViewController ()

@end

@implementation MWGListMoviesTableViewController

- (void)cleanup {
	[[[MWGMoviesManager sharedInstance] listedMovies] removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:_list[@"name"]];
	MWGMoviesManager *myMovies = [MWGMoviesManager sharedInstance];
//    [RACObserve(myMovies, moviesUpdated) subscribeNext:^(id x) {
//		[self.tableView reloadData];
//	}];
}

-(void)viewDidAppear:(BOOL)animated {
	[[MWGMoviesManager sharedInstance] getMoviesFromList:_list];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[MWGMoviesManager sharedInstance] listedMovies] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
	PFObject *movie = [[MWGMoviesManager sharedInstance] listedMovies][indexPath.row];
    [[cell textLabel] setText:movie[@"title"]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
