//
//  GAWelcomePageViewController.m
//  GymApp
//
//  Created by mdreid 1 on 5/12/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import "GAWelcomePageViewController.h"
#import "GAAppDelegate.h"

@interface GAWelcomePageViewController ()
@property (nonatomic) NSManagedObjectContext *moc;
- (IBAction)clearAll_onClick:(UIButton *)sender;

@end

@implementation GAWelcomePageViewController
@synthesize moc;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

    // go to Model and delete everything

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self clearAll];
    }
}

- (IBAction)clearAll_onClick:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check" message:@"Are you sure you want to remove all workouts?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

- (void) clearAll {
    // get the app delegate's moc
    GAAppDelegate *ad = (GAAppDelegate*)[UIApplication sharedApplication].delegate;
    [self setMoc:ad.managedObjectContext];
    NSFetchRequest *exerciseRequest =[NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    NSFetchRequest *workoutRequest = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    // query for everything
    NSError *e;
    NSError *e2;
    NSArray *tmp = [[self moc] executeFetchRequest:exerciseRequest error:&e];
    if (!tmp) {
        // error occured in fetch
        NSLog(@"%@", e);
    }
    NSArray *tmp2 = [[self moc] executeFetchRequest:workoutRequest error:&e];
    if (!tmp2) {
        // error occured in fetch
        NSLog(@"%@", e2);
    }
    
    // iterate through and delete all
    for (int i = 0; i < [tmp count]; i++) {
        [self.moc deleteObject:(NSManagedObject *)tmp[i]];
    }
    for (int j = 0; j < [tmp2 count]; j++) {
        [self.moc deleteObject:(NSManagedObject *)tmp2[j]];
    }
    
    // alert the user
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Done" message:@"All workouts have been removed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [a show];
}
@end
