//
//  BKAnnotation.h
//  ShareAmI
//
//  Created by William Katz on 5/29/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLPlacemark.h>


@interface BKAnnotation : NSObject <MKAnnotation>


@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic) NSDictionary* dict;

@property (nonatomic) NSString *phoneNum;
@property (readonly) BOOL selected;

-(void)assignTitle:(NSString *)newTitle;
-(void)assignSelected:(BOOL) boolVal;

@end

