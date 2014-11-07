//
//  InfoViewController.m
//  HW4
//
//  Created by Jeffrey Shih on 11/4/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "InfoViewController.h"
#import "JournalViewController.h"


@interface InfoViewController ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *descInput;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSString * lat;
@property (strong,nonatomic) NSString * longi;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation InfoViewController

@synthesize entry;


- (NSManagedObjectContext *)managedObjectContext {
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
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    [self.locationManager startUpdatingLocation];
    
    
    [self.locationManager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedWhenInUse) {
            //            self.mapView.showsUserLocation = YES;
        }
    }
    
    if (self.entry){
        [self.titleInput setText:[self.entry valueForKey:@"title"]];
        [self.descInput setText:[self.entry valueForKey:@"desc"]];
        
        [self showPhoto];
    }
}


-(void)showPhoto{ //updates Photo for entry
    self.image = [UIImage imageWithData:[self.entry valueForKey:@"photo"]];
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.scrollView addSubview:self.imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)saveEntry:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];


    
    if (self.entry){
        [self.entry setValue:self.titleInput.text forKey:@"title"];
        [self.entry setValue:self.descInput.text forKey:@"desc"];
        NSData *imageData = UIImagePNGRepresentation(self.image);
        [self.entry setValue:imageData forKey:@"photo"];
    }
    else{
    // Create a new managed object
    NSManagedObject *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
    [newEntry setValue:self.titleInput.text forKey:@"title"];
    [newEntry setValue:self.descInput.text forKey:@"desc"];
    [newEntry setValue:[NSDate date] forKey:@"date"];
    NSData *imageData = UIImagePNGRepresentation(self.image);
    [newEntry setValue:imageData forKey:@"photo"];
    [newEntry setValue:self.longi forKey:@"longitude"];
    [newEntry setValue:self.lat forKey:@"latitude"];

//    NSLog(@"Long: %@ , Lat: %@", self.longi, self.lat);
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    }
    NSLog(@"SAVING NOW");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}
- (IBAction)choosePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    NSLog(@"Available media types: %@", [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]);
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@", info);
    self.image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.scrollView addSubview:self.imageView];
    NSLog(@"Finished picking image");
    [self dismissViewControllerAnimated:picker completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:picker completion:nil];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation * newLocation = [locations lastObject];
    
    NSLog(@"Latitude :  %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude :  %f", newLocation.coordinate.longitude);
    
    self.lat = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    self.longi = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];

    
    
   // [self.locationManager stopUpdatingLocation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
