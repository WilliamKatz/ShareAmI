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
#import "XMPPParser.h"

//#import "BuddyViewController.h"

@class StreamDelegateDelegate;
@protocol StreamDelegateDelegate <NSObject>
@optional
-(void) popSignUpLogInView;
-(void) failedSignUpOrRegister;
@end


@interface StreamDelegate : NSObject < XMPPStreamDelegate, XMPPParserDelegate, NSXMLParserDelegate >{
    BOOL loggedIn;
    
}

@property id <StreamDelegateDelegate> delegate;
@property NSString *serverName;
@property XMPPStream* xmppStream;
@property XMPPRoster* xmppRoster;
@property XMPPPresence* xmppPresence;
//@property XMPPResourceCoreDataStorageObject* coreRoster;
@property XMPPRosterMemoryStorage *memoryRoster;

@property BOOL loggedIn;
@property BOOL registerNewUser;
@property NSMutableArray* addableBuddies;
//@property (nonatomic) KeychainItemWrapper *keychainItem;

-(void) setupStream;
-(BOOL) connect;
-(void) loggedOn;
-(void) registerUser: (NSString*)username password: (NSString*)pword ;
-(void) saveCeredentials: (NSString*)username password: (NSString*) password;
-(void) searchFor: (NSString*) user;
-(void) findAddableBuddies: (NSMutableArray*) contacts;
-(void) requestBuddy: (NSString*) user;


+(StreamDelegate*) getInstance;
@end
