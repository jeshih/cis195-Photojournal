//
//  JournalViewController.h
//  HW4
//
//  Created by Jeffrey Shih on 11/4/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PhotoViewController.h"

@interface JournalViewController : UITableViewController


- (NSManagedObjectContext *)managedObjectContext;

@end
