//
//  FirstViewController.m
//  HW4
//
//  Created by Jeffrey Shih on 11/3/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong)  NSMutableArray *journalEntries;


@end

@implementation MapViewController

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.delegate = self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    [self placeAnnotations];
    
    
    
}

-(void)placeAnnotations{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
    NSMutableArray * entries  = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.journalEntries = [[entries reverseObjectEnumerator] allObjects];
    
    for (int i =0; i< [entries count]; i++){
        NSManagedObject *note = [entries objectAtIndex:i];
        
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        pointAnnotation.title = [NSString stringWithFormat:@"%@", [note valueForKey:@"title"]];
        pointAnnotation.subtitle = [NSString stringWithFormat:@"%@", [note valueForKey:@"desc"]];
        

        
        double lat = [[NSString stringWithFormat:@"%@", [note valueForKey:@"latitude"]] doubleValue];
        
        double longi = [[NSString stringWithFormat:@"%@", [note valueForKey:@"longitude"]] doubleValue];
        
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, longi);
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 100, 100);
        [self.mapView addAnnotation:pointAnnotation];
        [self.mapView setRegion:region animated:YES];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *mapPin = nil;

    if (annotation != sender.userLocation){
        static NSString *defaultPinID = @"defaultPin";
        mapPin = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (mapPin == nil )
        {
            mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:defaultPinID];
            mapPin.canShowCallout = YES;
            UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            NSUInteger *index  = [self.mapView.annotations indexOfObject:annotation];
            [disclosureButton addTarget:self action:@selector(segueMap) forControlEvents:UIControlEventTouchUpInside];
            
            mapPin.rightCalloutAccessoryView = disclosureButton;
        }
        else
            mapPin.annotation = annotation;
        
    }
    return mapPin;
/*
    MKAnnotationView *aView = [sender dequeueReusableAnnotationViewWithIdentifier:@"Some identifier"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Some identifier"];
        aView.canShowCallout = YES;
        //aView.leftCalloutAccessoryView = ...;
        //aView.rightCalloutAccessoryView = ...;
        //[UIButton buttonWithType:UIButtonTypeDetailDisclosure]
    }
    aView.annotation = annotation;
    // Reset accessory view content here, in case it was reused
    return aView;*/
}

-(void)segueMap{
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"showNote" sender:self];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Possibly check if left callout is a UIImageView class
    //UIImageView *imageView = (UIImageView *)aView.left...
    //imageView.image = ...;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D coordinate = userLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation * newLocation = [locations lastObject];
    
    
    [self.locationManager stopUpdatingLocation];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end