//
//  GANewWorkoutViewController.m
//  GymApp
//
//  Created by mdreid 1 on 5/11/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import "GANewWorkoutViewController.h"
#import "GAAddExerciseController.h"

@interface GANewWorkoutViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name_text;

@end

@implementation GANewWorkoutViewController
@synthesize workout_name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    self.name_text.text = [self workout_name];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self setWorkout_name:self.name_text.text];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"add"]) {
        NSLog(@"GANewWorkoutVC-Workout name: %@", [self workout_name]);
        GAAddExerciseController *gaa = (GAAddExerciseController *)segue.destinationViewController;
        gaa.workout_name = [self workout_name];
    }
}

@end
