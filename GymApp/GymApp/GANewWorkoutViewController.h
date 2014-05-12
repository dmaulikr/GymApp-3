//
//  GANewWorkoutViewController.h
//  GymApp
//
//  Created by mdreid 1 on 5/11/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GANewWorkoutViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *workout_name;
@property (strong, nonatomic) NSString *old_workout_name;

@end
