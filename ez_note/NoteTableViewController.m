//
//  NoteTableViewController.m
//  ez_note
//
//  Created by Fred Wu on 7/23/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import "NoteTableViewController.h"
#import "ViewController.h"
#import "Note.h"

@interface NoteTableViewController (){
    
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NoteTableViewController



-(NSMutableArray *)notes{
    NSLog(@"running");
    if(!_notes){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
                                                  inManagedObjectContext:self.managedObjectContext];
        NSError *error;
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
//        for (Note *note in fetchedObjects) {
//            NSLog(@"ID: %@", note.title);
//            NSLog(@"First Name: %@", note.create_time);
//        }
//        
        _notes = [NSMutableArray arrayWithArray:fetchedObjects];
        
    }
    return _notes;
}



- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Reload data");
    self.notes = nil;
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // to reload selected cell
}




- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Context: %@", self.managedObjectContext);
    
    NSLog(@"notes count: %lu", [self.notes count]);
   
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        Note *note = [self.notes objectAtIndex:indexPath.row];
        [self.notes removeObjectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:note];
        
        NSError *error;
        
        if([self.managedObjectContext save: &error]){
            NSLog(@"Deleted");
        }else{
            NSLog(@"Failed to delete - error: %@", [error localizedDescription]);
        }

        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    NSInteger count = [self.fetchedResultsController sections].count;
//    
//    if (count == 0) {
//        count = 1;
//    }
//    
//    return count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSInteger numberOfRows = 0;
//    
//    if ([self.fetchedResultsController sections].count > 0) {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//        numberOfRows = [sectionInfo numberOfObjects];
//    }
//    NSLog(@"number %lu", numberOfRows);
//    
//    return numberOfRows;
    NSLog(@"count3: %lu", [self.notes count]);
    return [self.notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // dequeue a RecipeTableViewCell, then set its recipe to the recipe for the current row
    UITableViewCell *cell =
    (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
//    Note *note = (Note *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    Note *note = [self.notes objectAtIndex:indexPath.row];
    
    NSLog(@"%@",note.title);
    
    cell.textLabel.text = note.title;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM/dd/yy"];
    cell.detailTextLabel.text = [df stringFromDate: note.create_time];
    
    return cell;
}




//- (NSFetchedResultsController *)fetchedResultsController {
//    
//    // Set up the fetched results controller if needed.
//    if (_fetchedResultsController == nil) {
//        // Create the fetch request for the entity.
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        // Edit the entity name as appropriate.
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
//        [fetchRequest setEntity:entity];
//        
//        // Edit the sort key as appropriate.
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
//        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//        
//        [fetchRequest setSortDescriptors:sortDescriptors];
//        
//        // Edit the section name key path and cache name if appropriate.
//        // nil for section name key path means "no sections".
//        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//        aFetchedResultsController.delegate = self;
//        self.fetchedResultsController = aFetchedResultsController;
//    }
//    
//    return _fetchedResultsController;
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"createNote"]) {
        NSLog(@"Prepare here.");
        ViewController *v = (ViewController *)segue.destinationViewController;
        v.managedObjectContext = self.managedObjectContext;
        v.isNewDocument = YES;
        v.titleText = @"New Note";
    }else if ([segue.identifier isEqualToString:@"openNote"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Note *note = [self.notes objectAtIndex:indexPath.row];
        
//        NSData *jsonData = note.content;
        
        ViewController *v = (ViewController *)segue.destinationViewController;
        v.managedObjectContext = self.managedObjectContext;
        v.isNewDocument = NO;
        v.noteID = note.objectID;
//        [v loadViews: note.objectID];
//        [v loadViewsFromJSON:jsonData];
        v.titleText = note.title;
        NSLog(@"open note");
    }
}

@end
