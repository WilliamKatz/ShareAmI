//
//  FirstViewController.h
//  ShareAmI
//
//  Created by William Katz on 3/6/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpLogIn.h"


@interface BuddyViewController : UIViewController <SignUpLogInDelegate > {
    SignUpLogIn *signUpLogInVC;
}

-(void) popSignUpLogInView;

@end
