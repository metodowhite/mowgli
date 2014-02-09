//
//  MWGFilterViewController.m
//  Mowgli
//
//  Created by Cristian Díaz on 03/02/14.
//  Copyright (c) 2014 metodowhite. All rights reserved.
//

#import "MWGFilterViewController.h"

#import "FODFormViewController.h"
#import "FODFormBuilder.h"
#import "FODForm.h"

@interface MWGFilterViewController ()<FODFormViewControllerDelegate>

@end

@implementation MWGFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createFiltersForm];
    
}


-(void)viewDidAppear:(BOOL)animated {
}


-(void)createFiltersForm {
    FODFormBuilder *builder = [[FODFormBuilder alloc] init];
    
    [builder startFormWithTitle:@"Filters"];
    
    [builder section:@"Section 1"];
    
    [builder rowWithKey:@"foo"
                ofClass:[FODBooleanRow class]
               andTitle:@"Foo option"
               andValue:@YES];
    
    [builder section];
    
    { // start subform
        [builder startFormWithTitle:@"Advanced"
                             andKey:@"advanced"].displayInline = YES;
        
        [builder section:@"Section 1"];
        
        [builder rowWithKey:@"advanced_foo"
                    ofClass:[FODBooleanRow class]
                   andTitle:@"Foo option"
                   andValue:@NO];
        
        [builder rowWithKey:@"advanced_foobar"
                    ofClass:[FODTextInputRow class]
                   andTitle:@"Foobar"
                   andValue:@"foobar"
             andPlaceHolder:@"Fooby baz"];
        
        [builder finishForm];
    } // finish subform
    
    [builder rowWithKey:@"date"
                ofClass:[FODDateSelectionRow class]
               andTitle:@"When"
               andValue:nil].displayInline = YES;;
    
    [builder section];
    
    [builder rowWithKey:@"bar"
                ofClass:[FODTextInputRow class]
               andTitle:@"Bar"
               andValue:@"bar"
         andPlaceHolder:@"Fooby baz"];
    
    FODForm *form = [builder finishForm];
    
    FODFormViewController *vc = [[FODFormViewController alloc] initWithForm:form
                                                                   userInfo:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)formSaved:(FODForm *)model
         userInfo:(id)userInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)formCancelled:(FODForm *)model
             userInfo:(id)userInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
