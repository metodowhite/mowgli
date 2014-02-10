//
//  MWGListsTableViewController.m
//  Mowgli
//
//  Created by Cristian Díaz on 03/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWGListsTableViewController.h"
#import "MWGUser.h"
#import "MWGMoviesManager.h"
#import "MWGListsManager.h"
#import "MWGListMoviesTableViewController.h"

@interface MWGListsTableViewController ()
@property(nonatomic, strong) NSMutableArray *selectedLists;
@end

@implementation MWGListsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MWGListsManager *myLists = [MWGListsManager sharedInstance];
    [RACObserve(myLists, listsUpdated) subscribeNext:^(id x) {
		[self.tableView reloadData];
		//		[self.tableView endUpdates];
		//		[self.tableView scrollToRowAtIndexPath:indexPathOfNewItem
		//							  atScrollPosition:UITableViewScrollPositionBottom
		//									  animated:YES];
	}];
	self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	if ([[MWGListsManager sharedInstance] isAddingMovie]) {
		[self.tableView setEditing:YES animated:YES];
	}
}


- (IBAction)addList:(id)sender {
	//    [self.tableView beginUpdates];
	[self askListName];
}

- (IBAction)saveAndDismiss:(id)sender {
	[self saveMoviesInLists];
}

- (void)saveMoviesInLists {
	NSMutableArray *selectedMovies = [[MWGMoviesManager sharedInstance] selectedMovies];
	NSMutableArray *selectedLists = [[MWGListsManager sharedInstance] selectedLists];
	
	[[MWGMoviesManager sharedInstance] addMovies:selectedMovies
										 toLists:selectedLists];
	
	[[[MWGMoviesManager sharedInstance] savedSignal] subscribeCompleted:^{
		[selectedMovies removeAllObjects];
		[selectedLists removeAllObjects];
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
}


- (void)askListName {
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"List Name"
													   message:@"Desired Name for your new List?"
													  delegate:self
											 cancelButtonTitle:@"Cancel"
											 otherButtonTitles:@"Create", nil];
	[alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *buttonIndex) {
		if ([buttonIndex isEqual:@1]) {
			[[MWGListsManager sharedInstance] addListWithName:[[alertView textFieldAtIndex:0] text]];
		}
	}];
	[alertView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = [[[MWGListsManager sharedInstance] lists] count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    PFObject *list = [[MWGListsManager sharedInstance] lists][indexPath.row];
    [[cell textLabel] setText: list[@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[MWGListsManager sharedInstance] isAddingMovie]) {
		[[[MWGListsManager sharedInstance] selectedLists] addObject:[[MWGListsManager sharedInstance] lists][indexPath.row]];
	}else{
		[self performSegueWithIdentifier:@"showMoviesInListSegue" sender:self];
	}
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[[segue destinationViewController] cleanup];
	[[segue destinationViewController] setList:[[MWGListsManager sharedInstance] lists][indexPath.row]];
}


@end
