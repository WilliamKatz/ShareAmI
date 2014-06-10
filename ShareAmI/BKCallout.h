//
//  BKCallout.h
//  ShareAmI
//
//  Created by William Katz on 5/29/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLPlacemark.h>

@interface BKCallout : NSObject <MKAnnotation>

@property UIView *calloutView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic) NSDictionary* dict;

@property (nonatomic) NSString *phoneNum;
@property (readonly) BOOL selected;

-(void)assignTitle:(NSString *)newTitle;
-(void)assignSelected:(BOOL) boolVal;

@end

