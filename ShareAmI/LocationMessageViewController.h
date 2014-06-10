//
//  LocationMessageViewController.h
//  ShareAmI
//
//  Created by William Katz on 6/9/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationMessageViewController : UIViewController <UITableViewDataSource  , UITableViewDataSource >


@property NSArray *buddyList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end
