//
//  ShareMapViewController.m
//  ShareAmI
//
//  Created by William Katz on 5/29/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//


#import "ShareMapViewController.h"
#import "BKAnnotation.h"
#import "LocationMessageViewController.h"


@interface ShareMapViewController ()

@end

@implementation ShareMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //location manager
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager startUpdatingLocation];
    
    //map
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    MKCoordinateSpan defaultSpan = MKCoordinateSpanMake(1.0, 1.0);
    MKCoordinateRegion userRegion = MKCoordinateRegionMake([[_locationManager location] coordinate], defaultSpan);
    [_mapView setRegion:userRegion];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UISearchBarDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)startSearch:(NSString *)searchString
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    // confine the map search area to the user's current location
    MKCoordinateRegion newRegion;
    newRegion.center = [[_locationManager location] coordinate];
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error){
        if (error != nil) {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr.description
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (MKMapItem *mapItem in [response mapItems]){
                
                BKAnnotation *pm = [[BKAnnotation alloc] init];
                [pm assignTitle:[mapItem name]];
                [pm setCoordinate:mapItem.placemark.coordinate];
                [pm setDict:mapItem.placemark.addressDictionary];
                [pm assignSelected:NO];
                [pm setPhoneNum:mapItem.phoneNumber];
                [array addObject:pm];
            }
            [_mapView showAnnotations:array animated:YES];
            
            
        }
    };
    
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        // we are good to go, start the search
        [self startSearch:searchBar.text];
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MKMapViewDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >) annotation{
    
    static NSString *customIdentifier  = @"BKAnnotation";
    static NSString *calloutIdentifier = @"BKCallout";
    
    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        if ([annotation isKindOfClass:[BKAnnotation class]]){
            //a regular pin
            MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:customIdentifier];
            annView.pinColor = MKPinAnnotationColorGreen;
            return annView;
        }
        else if ([annotation isKindOfClass:[BKCallout class]]) {
            BKCallout *anno = annotation;
            CGSize            size = CGSizeMake(200.0, 180.0);
            MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:calloutIdentifier];
            CGPoint coord = [mapView convertCoordinate:[annotation coordinate] toPointToView:mapView];
            view.frame             = CGRectMake( coord.x, coord.y, size.width, size.height);
            view.backgroundColor   = [UIColor whiteColor];
            UIButton *button       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
           
            UILabel *name = [[UILabel alloc]  initWithFrame: CGRectMake(0.0, 0.0, size.width, 20.0)];
            [name setText: [annotation title]];
            UILabel *address  = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, size.width, 20.0)];
            [address setText:[[anno dict] objectForKey:@"Street"]];
            
            button.frame           = CGRectMake(0.0, 160.0, size.width, 20.0);
            [button setTitle:@"Share" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shareLocation:) forControlEvents:UIControlEventTouchUpInside];
            
            _currentAnnotation = [[BKCallout alloc] init];
            _currentAnnotation = anno;
            
            [view addSubview:name];
            [view addSubview:address];
            [view addSubview:button];
            view.canShowCallout    = NO;
            return view;
        }
    }
    
    return nil;

    
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([view.annotation isKindOfClass:[BKAnnotation class]]) {
        BKAnnotation *anno = view.annotation;
        BKCallout *calloutAnnotation = [[BKCallout alloc] init];
        
        calloutAnnotation.coordinate = anno.coordinate;
        [calloutAnnotation assignTitle: anno.title];
        [calloutAnnotation setDict: anno.dict];
        [calloutAnnotation setPhoneNum: anno.phoneNum];

        [mapView addAnnotation:calloutAnnotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [mapView selectAnnotation:calloutAnnotation animated:YES];
        });
    }

}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[BKCallout class]]) {
        [mapView removeAnnotation:view.annotation];
    }
}


-(void) shareLocation:(BKCallout *)callout {
    NSLog(@"share location, %@", [_currentAnnotation title]);
    LocationMessageViewController *lmvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LMVC"];
    [[self navigationController]  pushViewController:lmvc animated:YES];
}




@end
