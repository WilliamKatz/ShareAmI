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
    _buddyList = [[NSArray alloc] initWithArray:[[[RosterDelegate getInstance] memoryRoster] sortedUsersByName]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    if (![[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark){
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [[tableView cellForRowAtIndexPath:indexPath ] setAccessoryType: UITableViewCellAccessoryNone];
    }
    
    
}




@end
