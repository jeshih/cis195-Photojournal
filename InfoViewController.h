//
//  InfoViewController.h
//  HW4
//
//  Created by Jeffrey Shih on 11/4/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface InfoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong) NSManagedObject *entry;


@end
