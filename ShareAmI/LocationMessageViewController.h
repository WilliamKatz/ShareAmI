//
//  LocationMessageViewController.h
//  ShareAmI
//
//  Created by William Katz on 6/9/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCallout.h"

@class LocationMessageViewController;
@protocol LocationMessageDelegate <NSObject>
@required
-(BKCallout*) getLocation;
@end


@interface LocationMessageViewController : UIViewController <UITableViewDataSource  , UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate >

@property NSMutableArray *buddyList;
@property NSMutableArray *sendToIndices;

//delegate
@property id <LocationMessageDelegate> delegate;


@property BKCallout *location;

//uipicker data
@property NSArray *msg;
@property NSArray *preps;
@property NSArray *numbers;
@property NSArray *units;

//UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

//message


- (IBAction)sendMessage:(UIButton *)sender;
-(void) updateBuddyList;


@end
