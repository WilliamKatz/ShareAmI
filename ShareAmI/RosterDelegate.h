//
//  RosterDelegate.h
//  ShareAmI
//
//  Created by William Katz on 4/8/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@class RosterDelegateDelegate;
@protocol RosterDelegateDelegate <NSObject>
@optional

-(void) updateBuddyList;
-(void) updatePeopleWhoAddedMe: (XMPPUserMemoryStorageObject*) personWhoAddedMe;

@end


@interface RosterDelegate : NSObject <XMPPRosterDelegate, XMPPRosterMemoryStorageDelegate>

@property id<RosterDelegateDelegate> delegate;
//@property XMPPRosterCoreDataStorage *coreDataRoster;
@property XMPPRosterMemoryStorage *memoryRoster;
@property XMPPRoster *xmppRoster;
+(RosterDelegate*) getInstance;
-(void) setup;
-(void) removeBuddy: (XMPPJID*) buddy;
-(void) requestPerson: (XMPPJID*) person;
-(void) acceptPerson: (XMPPJID*) person;
@end
