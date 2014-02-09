//
//  MWGMoviesNowPlayingTableViewController.m
//  Mowgli
//
//  Created by Cristian Díaz on 01/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWGMoviesMainViewController.h"
#import "MWGMovie.h"
#import "MWGMovieCell.h"
#import "MWGMovieDetailViewController.h"
#import "MWGListsManager.h"

#include <JLTMDbClient.h>
#include <AFNetworking/UIImageView+AFNetworking.h>

@interface MWGMoviesMainViewController ()
@property (strong, nonatomic) NSMutableArray *moviesArr;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) BOOL fitCells;
@property (assign, nonatomic) BOOL animatedZooming;
@property (strong, nonatomic) UIPinchGestureRecognizer *gesture;
@property (strong, nonatomic) MWGMovie *selectedMovie;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSArray *posterSizes;
@property (nonatomic) NSInteger numPage;
@end

@implementation MWGMoviesMainViewController

const CGFloat kScaleBoundLower = 0.27;
const CGFloat kScaleBoundUpper = 2.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTMDbConf];
    
    self.fitCells = YES;
    self.animatedZooming = NO;
    
    // Default scale is the average between the lower and upper bound
    //self.scale = (kScaleBoundUpper + kScaleBoundLower)/2.0;
    self.scale = 1.0;
    
    // Add the pinch to zoom gesture
    self.gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [self.collectionView addGestureRecognizer:self.gesture];
}

- (void)loadTMDbConf {
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(NSDictionary *response, NSError *error) {
        if(!error){
            self.baseURL = response[@"images"][@"base_url"];
            self.posterSizes = response[@"images"][@"poster_sizes"];
            self.moviesArr = [NSMutableArray array];
            self.numPage = 1;
            [self loadMovies];
        }
    }];
}

- (void)loadMovies {
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:@{@"page":[NSNumber numberWithInt:_numPage]} andResponseBlock:^(NSDictionary *response, NSError *error) {
        if(!error){
            for (NSDictionary *movie in response[@"results"]) {
                MWGMovie *newMovie = [MTLJSONAdapter modelOfClass:MWGMovie.class fromJSONDictionary:movie error:&error];
                if (newMovie.posterPath != NULL) {
                    [self.moviesArr addObject:newMovie];
                }
                [self.collectionView reloadData];
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self resetNavigationController];
}

- (void)resetNavigationController {
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:nil];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.navigationController.navigationBar setBarTintColor:nil];
}

#pragma mark - Accessors

- (void)setScale:(CGFloat)scale {
    // Make sure it doesn't go out of bounds
    if (scale < kScaleBoundLower) {
        _scale = kScaleBoundLower;
    } else if (scale > kScaleBoundUpper) {
        _scale = kScaleBoundUpper;
    } else {
        _scale = scale;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_moviesArr count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >=  [_moviesArr count] -1) {
        self.numPage++;
        [self loadMovies];
    }
    
    MWGMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    MWGMovie *movie = _moviesArr[indexPath.row];
    
    
    //TODO: mejorar detection of thumbnail size
    NSString *size;
    
    if (_scale > 1) {
        size = _posterSizes[3];
    }
    
    if (_scale <= 1) {
        size = _posterSizes[2];
    }
    
    if (_scale <= 0.5) {
        size = _posterSizes[1];
    }
    
    if (_scale <= 0.3) {
        size = _posterSizes[0];
    }
    
    [cell.imagePoster setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", _baseURL, size, movie.posterPath]]
                     placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Main use of the scale property
    CGFloat scaledWidth = 160 * self.scale;
    CGFloat scaledHeight = 240 * self.scale;
    
    if (self.fitCells) {
        NSInteger cols = floor(320 / scaledWidth);
        NSInteger rows = floor(480 / scaledHeight);
        CGFloat totalSpacingSize = 1 * (cols - 1);
        CGFloat fittedWidth = (320 - totalSpacingSize) / cols;
        CGFloat fittedHeight = (480 - totalSpacingSize) / rows;
        return CGSizeMake(fittedWidth, fittedHeight);
    } else {
        return CGSizeMake(scaledWidth, scaledHeight);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMovie = _moviesArr[indexPath.row];
    [self performSegueWithIdentifier:@"showMovieDetailSegue" sender:self];
}

#pragma mark - Gesture Recognizers

- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture {
    static CGFloat scaleStart;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // Take an snapshot of the initial scale
        scaleStart = self.scale;
        return;
    } if (gesture.state == UIGestureRecognizerStateChanged) {
        // Apply the scale of the gesture to get the new scale
        self.scale = scaleStart * gesture.scale;
        
        
        if (self.animatedZooming) {
            // Animated zooming (remove and re-add the gesture recognizer to prevent updates during the animation)
            // [self.collectionView removeGestureRecognizer:self.gesture];
            // UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
            // [self.collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
            //    [self.collectionView addGestureRecognizer:self.gesture];
            // }];
        } else {
            // Invalidate layout
            [self.collectionView.collectionViewLayout invalidateLayout];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMovieDetailSegue"]) {
        [[segue destinationViewController] setMovie:_selectedMovie];
    }else if ([[segue identifier] isEqualToString:@"searchSegue"]) {
        //TODO: enviar params al search de ser necesario
    }else if ([[segue identifier] isEqualToString:@"showListsSegue"]) {
		[[MWGListsManager sharedInstance] setAddingMovie:NO];
	}
}



@end
