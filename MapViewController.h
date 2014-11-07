//
//  FirstViewController.h
//  HW4
//
//  Created by Jeffrey Shih on 11/3/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "PhotoViewController.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>


@end

