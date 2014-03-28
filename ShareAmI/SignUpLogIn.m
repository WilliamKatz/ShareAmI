//
//  SignUpLogIn.m
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "SignUpLogIn.h"

@interface SignUpLogIn ()

@end

@implementation SignUpLogIn

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
	// Do any additional setup after loading the

    segmentedControlOrigin = [_segmentedControl center];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITextFieldDelegate Method
//////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)textfield {
    [textfield resignFirstResponder];
    return YES;

}

- (IBAction)logInSignUpChoice:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0){
        //log in
        _nameField.alpha = 0;
        _passwordConfirmation.alpha = 0;
        _segmentedControl.center = segmentedControlOrigin;
    }
    else{
        //sign up
        _nameField.alpha=1;
        _passwordConfirmation.alpha = 1;
        _segmentedControl.center = CGPointMake(_segmentedControl.center.x, _segmentedControl.center.y + 37.5) ;
    }
}

- (IBAction)goButton:(UIButton *)sender {
    //send info thru stream delegate
    [[StreamDelegate getInstance] setDelegate:self];
    if ([_segmentedControl selectedSegmentIndex] == 0){
        //log in
        [[StreamDelegate getInstance] saveCeredentials:[_emailField text] password:[_passwordField text]];
        [[StreamDelegate getInstance] connect];
    
    }
    else{
        //register
        if ([[_passwordField text] isEqualToString:[_passwordConfirmation text]]){
            [[StreamDelegate getInstance] registerUser:[_emailField text] password:[_passwordField text]];
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark StreamDelegateDelegate Method
//////////////////////////////////////////////////////////////////////////////////////////
-(void) popSignUpLogInView{
    
    [[StreamDelegate getInstance] setDelegate:nil];
    [self.delegate popSignUpLogInView];
}

-(void) failedSignUpOrRegister{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something failed" message:@"Try again later" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}
@end
