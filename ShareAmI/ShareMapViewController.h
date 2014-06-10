//
//  ShareMapViewController.h
//  ShareAmI
//
//  Created by William Katz on 5/29/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKPlacemark.h>
#import "BKCallout.h"
#import "LocationMessageViewController.h"

@interface ShareMapViewController : UIViewController <MKMapViewDelegate, LocationMessageDelegate>{
    
}
//map
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//location manager
@property (strong, nonatomic) CLLocationManager *locationManager;

//search
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) MKLocalSearch *localSearch;

@property BKCallout* currentAnnotation;
//other methods
-(void) shareLocation: (BKCallout*) callout;

@end
