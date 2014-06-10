//
//  RosterDelegate.m
//  ShareAmI
//
//  Created by William Katz on 4/8/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "RosterDelegate.h"
#import "AppDelegate.h"
#import "XMPPUserMemoryStorageObject.h"
#import "XMPPResourceMemoryStorageObject.h"



@implementation RosterDelegate

static RosterDelegate *instance = nil;
+(RosterDelegate*) getInstance{
    @synchronized(self)
    {
        if (instance == nil){
            instance = [RosterDelegate new];
        }
        
    }
    return instance;
}

-(void) setup{
    instance = self;
    _memoryRoster = [[XMPPRosterMemoryStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_memoryRoster];
//    _memoryRoster
    [_xmppRoster activate:[[(AppDelegate *)[[UIApplication sharedApplication] delegate] streamDelegate] xmppStream ]];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _xmppRoster.autoFetchRoster = YES;
    
    
}

-(void)removeBuddy:(XMPPJID *)buddy{
    [_xmppRoster removeUser: buddy];
//    [_delegate updateBuddyList];
}

-(void) requestPerson:(XMPPJID *)person{
    [_xmppRoster subscribePresenceToUser: person];
}

-(void) acceptPerson:(XMPPJID *)person {
//    [_xmppRoster acceptPresenceSubscriptionRequestFrom:person andAddToRoster:YES];
    [_xmppRoster addUser:person withNickname:[person user] groups:nil subscribeToPresence:YES];
}


#pragma mark - XMPPRoster Delegate Methods


- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    //buddy request
    NSLog(@"%@, sub ask from", [presence from]);
    XMPPUserMemoryStorageObject *person = [[XMPPUserMemoryStorageObject alloc] initWithJID: [presence from]];
    [[self delegate] updatePeopleWhoAddedMe:person];
    
    
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq{
    //if ask="subscribe" then they want to be my friends
    
}


- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{

}

- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    //roster is done, great time to reload data?
    
}


- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item{
//    if ([[item name] isEqualToString:@"item"]){
//        NSLog(@"%@",[item valueForKey:@"jid"]);
//    }
    //if scrubtion="none" neither are followed
    //  if "from" then they want us to follow them
    //  if both then we are friends
    //[_delegate updateBuddyList];
//    if ([[item attributeForName:@"ask"] ])
    
}

#pragma  mark - XMPPRosterMemoryStorageDelegate methods

- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender{
    [_delegate updateBuddyList];
}

- (void)xmppRosterDidPopulate:(XMPPRosterMemoryStorage *)sender{
//    [_delegate updateBuddyList];
}

- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender didAddUser:(XMPPUserMemoryStorageObject *)user{
//    NSLog(@"%@, resource",[_memoryRoster resourceForJID:[user jid]]);

    
    
}
- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender didUpdateUser:(XMPPUserMemoryStorageObject *)user{
    
}
- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender didRemoveUser:(XMPPUserMemoryStorageObject *)user{
    
}

@end
