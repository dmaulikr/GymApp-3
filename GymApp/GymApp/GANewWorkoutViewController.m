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
@property (weak, nonatomic) IBOutlet UILabel *problem_label;
@property (strong, nonatomic) IBOutlet UITextField *name_text;
@end

@implementation GANewWorkoutViewController
@synthesize workout_name, name_text, problem_label, old_workout_name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self workout_name] != nil) {
        NSLog(@"Workout name is %@", self.workout_name);
        NSString *s = [NSString stringWithString:[self workout_name]];
        self.name_text.text = s;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"add"]) {
        // check validity of workout name
        NSString *ex = self.name_text.text;
        NSString *tmp = [ex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([tmp isEqualToString:@""]) {
            // must contain alphanumeric characters
            self.problem_label.text = @"Exercise name must contain alphanumeric characters";
            return;
        }
        
        GAAddExerciseController *gaa = (GAAddExerciseController *)segue.destinationViewController;
        gaa.workout_name = self.name_text.text;
        if ([self.workout_name isEqualToString:self.name_text.text]) {
            gaa.old_workout_name = self.name_text.text;
        }
        else {
            gaa.old_workout_name = self.workout_name;
        }
        
        // logging-unimportant below
        [self setWorkout_name:self.name_text.text];
        NSLog(@"GANewWorkoutVC-Workout name: %@", [self workout_name]);
        
    }
}

@end
