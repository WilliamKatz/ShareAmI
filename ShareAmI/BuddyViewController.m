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
    
    if ([[StreamDelegate getInstance] loggedIn]){
        
    }
    else{
        signUpLogInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpLogIn"];
        signUpLogInVC.delegate = self;
        [self.view addSubview:signUpLogInVC.view];
        [self.view bringSubviewToFront:signUpLogInVC.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popSignUpLogInView{
    [[[self.view subviews] lastObject] removeFromSuperview];
    signUpLogInVC = nil;
}

@end
