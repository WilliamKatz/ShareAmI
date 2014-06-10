//
//  FirstViewController.h
//  ShareAmI
//
//  Created by William Katz on 3/6/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpLogIn.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "RosterDelegate.h"

#import <MessageUI/MessageUI.h>



@interface BuddyViewController : UITableViewController <SignUpLogInDelegate, RosterDelegateDelegate, MFMessageComposeViewControllerDelegate> {
    SignUpLogIn *signUpLogInVC;
}

//buddy and contact props
@property NSArray* entireRoster;
@property NSMutableArray* buddyList;
@property NSMutableArray* peopleWhoAddedMe;
@property NSMutableArray* contactList;
@property NSMutableArray* addableBuddies;
@property ABAddressBookRef contactsRef;
@property XMPPJID *selectedBuddy;

//view controller elements
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactSegControl;

//view control methods
- (IBAction)segControlValueChange:(UISegmentedControl *)sender;

//buddy methods
- (IBAction)addBuddy:(UIButton *)sender;

//view
- (void) popSignUpLogInView;


@end
