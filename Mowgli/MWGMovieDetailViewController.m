//
//  MWGMovieDetailViewController.m
//  Mowgli
//
//  Created by Cristian Díaz on 01/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWGMovieDetailViewController.h"
#include <AFNetworking/UIImageView+AFNetworking.h>
#include <ColorArt/UIImage+ColorArt.h>
#include <UICKeyChainStore/UICKeyChainStore.h>
#import "MWGUser.h"
#import "MWGListsManager.h"
#import "MWGMoviesManager.h"

@interface MWGMovieDetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imagePoster;
@property (nonatomic, strong) NSURL *movieURL;
@end

@implementation MWGMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_movie.title];
    
    NSURLRequest *imagePosterRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@", _movie.posterPath]]];
    [self.imagePoster setImageWithURLRequest:imagePosterRequest
                            placeholderImage:[UIImage imageNamed:@"placeholderImage"]
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         [self.imagePoster setImage:image];
                                         [self.navigationController setNavigationBarHidden:NO];
                                         
                                         SLColorArt *colorArt = [image colorArt];
                                         
                                         [UIView animateWithDuration:0.3 animations:^{
                                             [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:colorArt.detailColor}];
                                             [self.navigationController.navigationBar setTintColor:colorArt.secondaryColor];
                                             [self.navigationController.navigationBar setBarTintColor:colorArt.backgroundColor];
                                             [self.navigationController.navigationBar setTranslucent:NO];
                                         }];
                                         
                                         
                                     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         //TODO: implementar falla de carga del poster
                                         [self.navigationController setNavigationBarHidden:NO];
                                     }];
    
    self.movieURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.themoviedb.org/movie/%@", _movie.movieId]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Sheet

- (IBAction)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self showOptions:nil];
    }
}

- (IBAction)showOptions:(id)sender {
    NSString *actionSheetTitle = @"Action Sheet Demo"; //Action Sheet Title
    NSString *safari = @"Open in Safari";
    NSString *compartir = @"Share";
    NSString *addToList = @"Add to List";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:compartir, safari, addToList, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self share];
    }
    
    if  (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:_movieURL];
    }
    
    if  (buttonIndex == 2) {
//        [[MWGUser sharedMWGUser] login];
//        [[[MWGUser sharedMWGUser] loggingSignal] subscribeCompleted:^{
//            [self addToLists];
//        }];
    }
}

#pragma mark – Compartir

- (void)share {
    NSString *mensaje = [NSString stringWithFormat:@"%@ (%@) – via @mowgliapp", _movie.title, _movieURL];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[mensaje] applicationActivities:nil];
    
    [activityVC setExcludedActivityTypes:@[UIActivityTypePostToWeibo,
                                           UIActivityTypePostToVimeo,
                                           UIActivityTypePostToTencentWeibo]];
    
    [self presentViewController:activityVC
                       animated:YES
                     completion:nil];
}

#pragma mark – Listas

- (void)addToLists {
	[[MWGListsManager sharedInstance] setAddingMovie:YES];
	[[[MWGMoviesManager sharedInstance] selectedMovies] addObject:_movie];
	[self performSegueWithIdentifier:@"addToListSegue" sender:self];
}

#pragma mark - Debug Utils

/// Shake for clean debug
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        [self resetKeychainForDebuggingPurposes];
        [self throwAlertWithTitle:@"Reset" message:@"com.metodowhite uuid limpiado"];
    }
}

- (void)resetKeychainForDebuggingPurposes {
    [[UICKeyChainStore keyChainStoreWithService:@"com.metodowhite"] removeItemForKey:@"uuid"];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Alert Utils

- (void)throwAlertWithTitle:(NSString *)title message:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"addToListSegue"]) {
//        [[segue destinationViewController] setMovie:_movie];
//    }
//}

@end
