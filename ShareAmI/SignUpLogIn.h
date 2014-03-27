//
//  SignUpLogIn.h
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamDelegate.h"

@class SignUpLogIn;
@protocol SignUpLogInDelegate <NSObject>
@required
-(void) popSignUpLogInView;
@end


@interface SignUpLogIn : UIViewController <StreamDelegateDelegate> {
    CGPoint segmentedControlOrigin;
}
@property (strong, nonatomic) IBOutlet UIView *SignUpLogInView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property id <SignUpLogInDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmation;
- (IBAction)logInSignUpChoice:(UISegmentedControl *)sender;
- (IBAction)goButton:(UIButton *)sender;

@end
