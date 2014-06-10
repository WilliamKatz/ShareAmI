//
//  LocationMessageViewController.m
//  ShareAmI
//
//  Created by William Katz on 6/9/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "LocationMessageViewController.h"
#import "RosterDelegate.h"

@interface LocationMessageViewController ()



@end


@implementation LocationMessageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateBuddyList];
    _location = [[BKCallout alloc] init];
    _location = [self.delegate getLocation];
    [_locationLabel setText:[_location title]];
    
    _msg = [[NSArray alloc] initWithObjects:@"",@"See you",@"Be there", @"Here", @"On my way", nil];
    _preps = [[NSArray alloc] initWithObjects:@"",@"in", @"at", @"now", nil];
    _numbers = [[NSArray alloc] initWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"15", @"20",@"30", @"45", nil];
    _units = [[NSArray alloc] initWithObjects:@"",@"A.M.", @"P.M", @"mins", @"hours",@"ish", nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITABLEVIEW
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_buddyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [[[_buddyList objectAtIndex:[indexPath row]] jid] user];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryNone){
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [_sendToIndices setObject:@YES atIndexedSubscript:[indexPath row]];
    }
    else{
        [[tableView cellForRowAtIndexPath:indexPath ] setAccessoryType: UITableViewCellAccessoryNone];
        [_sendToIndices setObject:@NO atIndexedSubscript:[indexPath row]];
    }
    
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - keyboard delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self dismissKeyboard];
    return YES;
}
- (void) textFieldDidBeginEditing: (UITextField*) tfield{
    //  self.view.center = CGPointMake(originalCenter.x, originalCenter.y - 216);
}
-(void) textFieldDidEndEditing: (UITextField*) tfield{
    //   self.view.center = originalCenter;
    [self dismissKeyboard];
}

-(void)dismissKeyboard {
    [_messageField resignFirstResponder];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ui picker dlegate and datasource methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component){
        case 0: return [_msg count]; break;
        case 1: return [_preps count]; break;
        case 2: return [_numbers count]; break;
        case 3: return [_units count]; break;
    }
    return 0;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component){
        case 0: return [_msg objectAtIndex:row]; break;
        case 1: return [_preps objectAtIndex:row]; break;
        case 2: return [_numbers objectAtIndex:row]; break;
        case 3: return [_units objectAtIndex:row]; break;
    }
    return 0;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    switch (component){
        case 0: return 130.0; break;
        case 1: return 55.0; break;
        case 2: return 35; break;
        case 3: return 75.0; break;
    }
    return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)sendMessage:(UIButton *)sender {
}

-(void) updateBuddyList{
    
    //create buddy list
    _buddyList = [[NSMutableArray alloc] initWithArray:[[[RosterDelegate getInstance] memoryRoster] sortedUsersByName]];
    for (int i = ([_buddyList count]-1) ; i >= 0 ; i--){
        NSString* subscription = [[[_buddyList objectAtIndex:i] itemAttributes] valueForKey:@"subscription"];
        if (![subscription isEqualToString:@"both"]){
            [_buddyList removeObjectAtIndex:i];
        }
        
    }
    
    //create array of people sending message too
    _sendToIndices = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [_buddyList count]; i ++){
        [_sendToIndices addObject:@NO];
    }

    
}






@end
