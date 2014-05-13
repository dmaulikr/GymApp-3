//
//  GAListWorkoutsTableViewController.h
//  GymApp
//
//  Created by mdreid 1 on 5/10/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAListWorkoutsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *workouts;

- (void) fetchRecords;

@end
