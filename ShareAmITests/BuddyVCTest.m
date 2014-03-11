//
//  BuddyVCTest.m
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BuddyVCTest : XCTestCase

@end

@implementation BuddyVCTest{

    UIViewController *_buddyViewController;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    _buddyViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BuddyVC"];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    _buddyViewController = nil;
}

- (void)testExample
{
    XCTAssert(_buddyViewController.view.subviews.count == 5 , @"sign up view should be loaded, subviews equals 2");
}


@end
