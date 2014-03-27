//
//  StreamDelegate.h
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPP.h"
#import "XMPPAutoPing.h"
#import "KeychainItemWrapper.h"
#import "XMPPFramework.h"
//#import "BuddyViewController.h"

@class StreamDelegateDelegate;
@protocol StreamDelegateDelegate <NSObject>
-(void) popSignUpLogInView;
@end


@interface StreamDelegate : NSObject < XMPPStreamDelegate >{
    BOOL loggedIn;
    
}

@property id <StreamDelegateDelegate> delegate;

@property XMPPStream* xmppStream;
@property XMPPRoster* xmppRoster;
@property XMPPPresence* xmppPresence;
@property XMPPResourceCoreDataStorageObject* coreRoster;
@property XMPPRosterMemoryStorage *memoryRoster;
@property BOOL loggedIn;
//@property (nonatomic) KeychainItemWrapper *keychainItem;

-(void) setupStream;
-(BOOL) connect;
-(void) registerUser;
-(void) saveCeredentials: (NSString*)username password: (NSString*) password;

+(StreamDelegate*) getInstance;
@end
