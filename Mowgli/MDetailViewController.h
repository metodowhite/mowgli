//
//  MDetailViewController.h
//  Mowgli
//
//  Created by luisa on 01/02/14.
//  Copyright (c) 2014 luisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
