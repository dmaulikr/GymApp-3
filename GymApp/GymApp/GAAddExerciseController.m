//
//  GAAddExerciseController.m
//  GymApp
//
//  Created by mdreid 1 on 5/11/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import "GAAddExerciseController.h"
#import "Exercise.h"
#import "Workout.h"

@interface GAAddExerciseController ()
@property (weak, nonatomic) IBOutlet UITextField *exercise_field;
@property (weak, nonatomic) IBOutlet UITextField *set_field;
@property (weak, nonatomic) IBOutlet UILabel *problem_label;
- (IBAction)add_exercise_OnClick:(UIButton *)sender;

@end

@implementation GAAddExerciseController
@synthesize exercise_field, set_field, problem_label, moc, workout_name;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// fetch records
- (id) fetchWorkout {
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = [NSPredicate predicateWithFormat:@"Workout.workout_name = %@",[self workout_name]];
    NSError *e;
    NSArray *tmp = [[self moc] executeFetchRequest:request error:&e];
    if (!tmp) {
        // error occured in fetch
        NSLog(@"%@", e);
    }
    return tmp[0];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
    
    // set, submit, and segue
    Workout *w = (Workout *)[self fetchWorkout];
    Exercise *e = [[Exercise alloc] init];
    e.rank = [NSNumber numberWithInt:rank];
    e.num_sets = [NSNumber numberWithInt:num];
    e.exercise_name = ex;
    [w addExercisesObject:e];
    rank++;
    NSError *error;
    [moc save:&error];
    [self performSegueWithIdentifier:@"submit_exercise" sender:self];
    
}
@end
