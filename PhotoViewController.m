//
//  PhotoViewController.m
//  HW4
//
//  Created by Jeffrey Shih on 11/4/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *longText;
@property (strong, nonatomic) IBOutlet UILabel *descText;
@property (strong, nonatomic) IBOutlet UILabel *latText;

@property (strong, nonatomic) IBOutlet UINavigationItem *titleEntry;


@end

@implementation PhotoViewController

@synthesize entry;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    if (self.entry){
        NSString * entryTitle = [self.entry valueForKey:@"title"];
        self.titleEntry.title = entryTitle;
        [self.descText setText:[self.entry valueForKey:@"desc"]];
        NSLog(@"%@", [self.entry valueForKey:@"longitude"]);
        [self.longText setText:[self.entry valueForKey:@"longitude"]];
        [self.latText setText:[self.entry valueForKey:@"latitude"]];

        [self showPhoto];
        //self.imageView = [UIImageView alloc];
        //[self.scrollView addSubview:self.imageView];
        
    }
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.view setNeedsDisplay];
    
}

-(void)showPhoto{
    UIImage *image = [UIImage imageWithData:[self.entry valueForKey:@"photo"]];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:self.imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"editEntry"]) {
        InfoViewController *destViewController = segue.destinationViewController;
        destViewController.entry = self.entry;
    }
    
}


@end
