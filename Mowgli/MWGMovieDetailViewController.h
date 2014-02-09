//
//  MWGMovieDetailViewController.h
//  Mowgli
//
//  Created by Cristian Díaz on 01/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWGMovie.h"

@interface MWGMovieDetailViewController : UIViewController<UIActionSheetDelegate>
@property(strong, nonatomic) MWGMovie *movie;
@end
