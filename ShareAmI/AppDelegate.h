//
//  AppDelegate.h
//  ShareAmI
//
//  Created by William Katz on 3/6/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "StreamDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property StreamDelegate *streamDelegate;

@end
