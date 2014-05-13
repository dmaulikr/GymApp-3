//
//  GAListExerciseTableViewController.m
//  GymApp
//
//  Created by mdreid 1 on 5/10/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import "GAListExerciseTableViewController.h"
#import "GAAppDelegate.h"
#import "Exercise.h"

@interface GAListExerciseTableViewController ()
@property (nonatomic) NSMutableArray *exerciseList;
@property (nonatomic) NSManagedObjectContext *moc;
@property (nonatomic) NSString *workout_name;
@property (strong, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GAListExerciseTableViewController
@synthesize exerciseList, moc, tv;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tv.delegate = self;
    self.tv.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated {
    GANewWorkoutViewController *vc = (GANewWorkoutViewController *)self.parentViewController;
    if (self.workout_name == nil && vc.workout_name != nil) {
        self.workout_name = vc.workout_name;
        // fetch all exercises associated with workout
        NSLog(@"OWn workout name %@", self.workout_name);
        NSLog(@"vc workout name %@", vc.workout_name);
        [self fetchExercises];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [self setEditing:YES animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self exerciseList] count];
}

- (void) fetchExercises {
    NSLog(@"Executing fetch for table view");
    NSLog(@"Predicate is %@", self.workout_name);
    GAAppDelegate *ad = (GAAppDelegate*)[UIApplication sharedApplication].delegate;
    [self setMoc:ad.managedObjectContext];
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    request.predicate = [NSPredicate predicateWithFormat:@"workout_name == %@",self.workout_name];
    NSError *e;
    NSArray *tmp = [[self moc] executeFetchRequest:request error:&e];
    if (!tmp) {
        // error occured in fetch
        NSLog(@"%@", e);
    }
    NSLog(@"Number of results: %d", [tmp count]);
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmp count]; i++) {
        Exercise *e = (Exercise *)tmp[i];
        listArray[i] = e.exercise_name;
    }
    [self setExerciseList:listArray];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tv setEditing:editing animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.exerciseList[indexPath.row];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

        return UITableViewCellEditingStyleDelete;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *e = self.exerciseList[indexPath.row];
        
        // query db and remove this exercise
        GAAppDelegate *ad = (GAAppDelegate*)[UIApplication sharedApplication].delegate;
        [self setMoc:ad.managedObjectContext];
        NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
        request.predicate = [NSPredicate predicateWithFormat:@"workout_name == %@",e];
        NSError *error;
        NSArray *tmp = [[self moc] executeFetchRequest:request error:&error];
        [moc deleteObject:tmp[0]];
        if (!tmp) {
            // error occured in fetch
            NSLog(@"%@", error);
        }
        [self.exerciseList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
@end