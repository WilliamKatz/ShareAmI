//
//  SignUpLogInVCTest.m
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SignUpLogIn.h"

@interface SignUpLogInVCTest : XCTestCase

@end

@implementation SignUpLogInVCTest{
    SignUpLogIn* _signUpLogInVC;
}

- (void)setUp
{
    [super setUp];
    _signUpLogInVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpLogIn"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _signUpLogInVC = nil;
}

- (void)testExample
{
    //click log in
    //see that there are to fields labeled email and password
    //and a button that says submit
    XCTAssert(_signUpLogInVC !=nil, @"sign up view aint nil");
}


@end
