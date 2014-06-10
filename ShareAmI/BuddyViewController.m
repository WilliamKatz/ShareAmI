//
//  FirstViewController.m
//  ShareAmI
//
//  Created by William Katz on 3/6/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "BuddyViewController.h"


@interface BuddyViewController ()


@end

@implementation BuddyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[RosterDelegate getInstance] setDelegate: (id<RosterDelegateDelegate>)self];
    _selectedBuddy = [[XMPPJID alloc] init];
    _peopleWhoAddedMe = [[NSMutableArray alloc] init];
    _buddyList = [[NSMutableArray alloc] init];
    _entireRoster = [[NSArray alloc] init];
    
    if ([[StreamDelegate getInstance] loggedIn]){
//        [[StreamDelegate getInstance] setDelegate:self];
    }
    else{
        signUpLogInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpLogIn"];
        signUpLogInVC.delegate = self;
        signUpLogInVC.hidesBottomBarWhenPushed =YES;
        [[self navigationController] pushViewController:signUpLogInVC animated:YES];
    }
    
    _contactsRef = ABAddressBookCreateWithOptions(NULL, NULL);
    _contactList = [[NSMutableArray alloc] init];
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_contactsRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(_contactsRef);
                for (int i = 0 ; i< CFArrayGetCount(allPeople); i++){
                    ABRecordRef record = CFArrayGetValueAtIndex(allPeople,i);
                    [_contactList addObject: (__bridge id)(record)];

                }
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
//        [self _addContactToAddressBook];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segControlValueChange:(UISegmentedControl *)sender {
    
    [self.tableView reloadData];
}

- (IBAction)addBuddy:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTitle:(@"Add Buddy")];
    alert.delegate = self;
    
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Request"];
    alert.tag = 1;
    [alert show];
    
}


-(void) popSignUpLogInView{
    [[self navigationController] popToRootViewControllerAnimated:YES];
    signUpLogInVC = nil;
    //[[StreamDelegate getInstance] findAddableBuddies: _contactList];
    
    
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( [_contactSegControl selectedSegmentIndex]== 0){
        return 1;
    }
    else{
        return 3;
    }
        
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_contactSegControl selectedSegmentIndex] == 0) return [_buddyList count];
    else{
        if (section == 0){
            return [_peopleWhoAddedMe count];
        }
        else if (section == 1){
            return  [_addableBuddies count];
        }
        else return [_contactList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ( [_contactSegControl selectedSegmentIndex] == 0){
        static NSString *CellIdentifier = @"Buddy";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[[_buddyList objectAtIndex:[indexPath row]] jid] user];
    }
    else{
        if ([indexPath section] == 0){
            //someone added me
            cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleWhoAddedMe"];
            cell.textLabel.text = [[[_peopleWhoAddedMe objectAtIndex:[indexPath row]] jid] user];
        }
        else if ([indexPath section]== 1){
            //addable
            cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleICanAdd"];
            
        }
        else {
            //other contacts
            cell = [tableView dequeueReusableCellWithIdentifier:@"NonUserContact"];
            cell.textLabel.text =  (__bridge NSString*) ABRecordCopyValue((__bridge ABRecordRef)([_contactList objectAtIndex:[indexPath row]]), kABPersonFirstNameProperty);
        }
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }

    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([_contactSegControl selectedSegmentIndex] == 0){
        return @"Buddies";
    }
    else {
        if ( section == 0) return @"People Who Added Me";
        else if ( section == 1) return @"People I Can Add";
        else return @"Contacts";
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    
    if ([_contactSegControl selectedSegmentIndex] == 0){
//        /buddy side
        [alert addButtonWithTitle:@"Share r u?"];
        [alert addButtonWithTitle:@"Shere I am"];
        [alert addButtonWithTitle:@"remove"];
        [alert addButtonWithTitle:@"block"];
        [alert addButtonWithTitle:@"Cancel"];
        alert.cancelButtonIndex = 4;
        alert.tag = 2;
        _selectedBuddy = [[_buddyList objectAtIndex:[indexPath row]] jid];
        [alert show];
    }
    else{
        if ([indexPath section] ==0 ){
            [alert addButtonWithTitle:@"Accept"];
            [alert addButtonWithTitle:@"Cancel"];
            alert.cancelButtonIndex = 1;
            alert.tag = 3;
            _selectedBuddy = [[_peopleWhoAddedMe objectAtIndex:[indexPath row]] jid];
            [alert show];
        }
        else if ([indexPath section] == 2){
            [alert addButtonWithTitle:@"Invite"];
            [alert addButtonWithTitle:@"Cancel"];
            alert.cancelButtonIndex = 1;
            alert.tag = 4;
            [alert show];

//            [[StreamDelegate getInstance] searchFor:(__bridge NSString*) ABRecordCopyValue((__bridge ABRecordRef)([_contactList objectAtIndex:[indexPath row]]), kABPersonFirstNameProperty)];

            
        }
//        NSLog(@"%@", (__bridge NSString*) ABRecordCopyValue((__bridge ABRecordRef)([_contactList objectAtIndex:[indexPath row]]), kABPersonEmailProperty));
//
//        [        //[[StreamDelegate getInstance] findAddableBuddies:_contactList];
    }
    
//    NSLog(@"%@, testing", [[[_buddyList objectAtIndex:[indexPath row]] itemAttributes] objectForKey:@"subscription"]);
}

#pragma mark - UIAlerView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        //add buddy button top right
        if (buttonIndex == 1){
            //request presnece subscription to non-buddy
            [[RosterDelegate getInstance] requestPerson: [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@williamkatz.local", [[alertView textFieldAtIndex:0] text] ] ] ];
            
        }
    }
    if (alertView.tag == 2){
        //4 options
        //1 share are you, 2 share i am, 3 remove, 4 block
        //want to move share are you and shere i am to the cell somehow
        if (buttonIndex ==0){
            NSLog(@"share r u?");
        }
        else if ( buttonIndex == 1){
            NSLog(@"shere i am");
        }
        else if ( buttonIndex == 2){
            NSLog(@"remove");
            [[RosterDelegate getInstance] removeBuddy:_selectedBuddy];
        }
        else if ( buttonIndex == 3){
            NSLog(@"block, %@", @"opo" );
        }
    
    }
    if (alertView.tag == 3){
        if (buttonIndex == 0){
            //accept
            [[RosterDelegate getInstance] acceptPerson:_selectedBuddy];
        }
    }
    if (alertView.tag == 4){
        //invite person via sms or email
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"Hello from Mugunth";
            controller.recipients = [NSArray arrayWithObjects:@"12345678", @"87654321", nil];
            controller.messageComposeDelegate = (id<MFMessageComposeViewControllerDelegate>) self;
//            [self presentModalViewController:controller animated:YES];
            [self presentViewController:controller animated:YES completion:nil];
        }
    
        
    }
    
    
}

#pragma mark - Message Composing Delegate Methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			break;
		case MessageComposeResultSent:
			break;
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - RosterDelegateDelegate Methods

-(void) updateBuddyList{
    _entireRoster = [[[RosterDelegate getInstance] memoryRoster] sortedUsersByName];
    NSMutableArray *tempBuddy = [[NSMutableArray  alloc] init];
    NSMutableArray *tempPplWhoAddedMe = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [_entireRoster count] ; i++){
        NSString* subscription = [[[_entireRoster objectAtIndex:i] itemAttributes] valueForKey:@"subscription"];
        if ([subscription isEqualToString:@"none"]){
//            NSLog(@"%@, is not a buddy", [[[_buddyList objectAtIndex:i] jid] user]);
        }
        else if ([subscription isEqualToString:@"to"]){
            //they added me?
      
        }
        else if ([subscription isEqualToString:@"from"]){
            [tempPplWhoAddedMe addObject:[_entireRoster objectAtIndex:i]];
//            [_peopleWhoAddedMe addObject:[_entireRoster objectAtIndex:i]];
            
        }
        else if ([subscription isEqualToString:@"both"]){
            [tempBuddy insertObject:[_entireRoster objectAtIndex:i] atIndex:[tempBuddy count]];
            
        }
    }
    [_peopleWhoAddedMe addObjectsFromArray:tempPplWhoAddedMe];
    _buddyList = tempBuddy;
    
    [self.tableView reloadData];
}

-(void) updatePeopleWhoAddedMe:(XMPPUserMemoryStorageObject *)personWhoAddedMe{
    [_peopleWhoAddedMe addObject:personWhoAddedMe];
    
}


@end
