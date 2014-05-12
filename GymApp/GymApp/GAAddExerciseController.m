//
//  GAAddExerciseController.m
//  GymApp
//
//  Created by mdreid 1 on 5/11/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import "GAAddExerciseController.h"
#import "GANewWorkoutViewController.h"
#import "Exercise.h"
#import "Workout.h"
#import "GAAppDelegate.h"

@interface GAAddExerciseController ()
@property (weak, nonatomic) IBOutlet UITextField *exercise_field;
@property (weak, nonatomic) IBOutlet UITextField *set_field;
@property (weak, nonatomic) IBOutlet UILabel *problem_label;
- (IBAction)add_exercise_OnClick:(UIButton *)sender;
@property (weak, nonatomic) NSManagedObjectContext * moc;

@end

@implementation GAAddExerciseController
@synthesize exercise_field, set_field, problem_label, workout_name, moc, old_workout_name;
//@synthesize moc;
static int rank;

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
    rank = 1;
    // Do any additional setup after loading the view.
    exercise_field.delegate = self;
    set_field.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// fetch records
- (id) fetchWorkout {
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = [NSPredicate predicateWithFormat:@"workout_name = %@",[self old_workout_name]];
    NSError *e;
    NSArray *tmp = [[self moc] executeFetchRequest:request error:&e];
    if (!tmp) {
        // error occured in fetch
        NSLog(@"%@", e);
    }
    if ([tmp count] == 0) {
        // in this case we make the workout and return it
        GAAppDelegate *ad = (GAAppDelegate*)[UIApplication sharedApplication].delegate;
        [self setMoc:ad.managedObjectContext];
        Workout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:[self moc]];
        workout.workout_name = self.workout_name;
        return workout;
    }
    return tmp[0];
}

// Makes return button collapse keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"submit_exercise"]) {
        GANewWorkoutViewController *vc = (GANewWorkoutViewController *)segue.destinationViewController;
        NSLog(@"GAAddExerciseController-Workout name: %@", [self workout_name]);
        vc.workout_name = [self workout_name];
        NSLog(@"vc new workout name: %@", vc.workout_name);
    }
}


- (IBAction)add_exercise_OnClick:(UIButton *)sender {
    // check exercise name
    NSString *ex = [[self exercise_field] text];
    NSString *tmp = [ex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([tmp isEqualToString:@""]) {
        // must contain alphanumeric characters
        self.problem_label.text = @"Exercise name must contain alphanumeric characters";
        return;
    }
    // check number of sets
    NSString *sets = [[self set_field] text];
    int num = [sets integerValue];
    if (num < 1) {
        self.problem_label.text = @"Number of sets must be at least 1";
        return;
    }
    
    GAAppDelegate *ad = (GAAppDelegate*)[UIApplication sharedApplication].delegate;
    [self setMoc:ad.managedObjectContext];
    // set, submit, and segue
    Workout *w = (Workout *)[self fetchWorkout];
    w.workout_name = [NSString stringWithString:self.workout_name];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:self.moc];
    Exercise *e = [[Exercise alloc] initWithEntity:entity insertIntoManagedObjectContext:[self moc]];
    e.rank = [NSNumber numberWithInt:rank];
    e.num_sets = [NSNumber numberWithInt:num];
    e.exercise_name = ex;
    e.workout_name = w.workout_name;
    [w addExercisesObject:e];
    rank++;
    NSError *error;
    [moc save:&error];
    [self performSegueWithIdentifier:@"submit_exercise" sender:self];
    
}
@end
