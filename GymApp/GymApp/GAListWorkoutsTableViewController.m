//
//  GAListWorkoutsTableViewController.m
//  GymApp
//
//  Created by mdreid 1 on 5/10/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import "GAListWorkoutsTableViewController.h"
#import "Workout.h"
#import "GAAppDelegate.h"

@interface GAListWorkoutsTableViewController ()
@property (nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UITableView *tv;
@end

@implementation GAListWorkoutsTableViewController
@synthesize workouts, moc, tv;

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
    
    [self fetchRecords];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tv.delegate = self;
    self.tv.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [self setEditing:YES animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tv setEditing:editing animated:YES];
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
    return [[self workouts] count];
}

// method to get workouts from Models
- (void) fetchRecords {
    GAAppDelegate *ad = (GAAppDelegate*)[UIApplication sharedApplication].delegate;
    [self setMoc:ad.managedObjectContext];
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workout_name" ascending:NO selector:@selector(localizedStandardCompare:)];
    request.sortDescriptors = @[sortDescriptor];
    NSError *e;
    NSArray *tmp = [[self moc] executeFetchRequest:request error:&e];
    NSMutableArray *m = [tmp mutableCopy];
    [self setWorkouts:m];
    if (!tmp) {
        // error occured in fetch
        NSLog(@"%@", e);
    }
}

// set cell to display name of workout
// to do: add when most recently done to cell (UITableViewCellStyle1)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];

    NSString *s = [self.workouts[indexPath.row] workout_name];
    [cell.textLabel setText: s];
    
    return cell;
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
        Workout *w = self.workouts[indexPath.row];
        
        // query db and remove this exercise
        GAAppDelegate *ad = (GAAppDelegate*)[UIApplication sharedApplication].delegate;
        [self setMoc:ad.managedObjectContext];
        NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Workout"];
        request.predicate = [NSPredicate predicateWithFormat:@"workout_name == %@",w.workout_name];
        NSError *error;
        NSArray *tmp = [[self moc] executeFetchRequest:request error:&error];
        [moc deleteObject:tmp[0]];
        if (!tmp) {
            // error occured in fetch
            NSLog(@"%@", error);
        }
        [self.workouts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
