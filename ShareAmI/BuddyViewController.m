//
//  FirstViewController.m
//  ShareAmI
//
//  Created by William Katz on 3/6/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "BuddyViewController.h"

@interface BuddyViewController ()

@end

@implementation BuddyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    signUpLogInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpLogIn"];
    [self.view addSubview:signUpLogInVC.view];
    [self.view bringSubviewToFront:signUpLogInVC.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
