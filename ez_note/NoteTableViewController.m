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
#import "NoteSearchResultsViewController.h"
#import "NoteCell.h"

@interface NoteTableViewController (){
    

    
}

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// our secondary search results table view
@property (nonatomic, strong) NoteSearchResultsViewController *resultsTableController;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

//NSString *const kCellIdentifier = @"cellID";
//NSString *const kTableCellNibName = @"NoteCell";

@implementation NoteTableViewController


const int RecentNoteCount = 5;


-(NSMutableArray *)recentNotes{
    if(!_recentNotes){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
                                                  inManagedObjectContext:self.managedObjectContext];
        NSError *error;
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"create_time" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByDate]];
        
        
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        long count = [fetchedObjects count];
        
        if(count>RecentNoteCount){
            count = RecentNoteCount;
        }
        
        _recentNotes = [NSMutableArray arrayWithArray:[fetchedObjects subarrayWithRange:NSMakeRange(0, count)]];
        
    }
    return _recentNotes;
}


-(NSMutableArray *)notes{
    if(!_notes){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
                                                  inManagedObjectContext:self.managedObjectContext];
        NSError *error;
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
        
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        _notes = [NSMutableArray arrayWithArray:fetchedObjects];
        
    }
    return _notes;
}



- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Reload data");
    self.notes = nil;
    self.recentNotes = nil;
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // to reload selected cell
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NoteCell" bundle:nil] forCellReuseIdentifier:@"NoteCell"];
    
    
    NSLog(@"Context: %@", self.managedObjectContext);
    
    NSLog(@"notes count: %lu", [self.notes count]);
    
    
    _resultsTableController = [[NoteSearchResultsViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
   
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.recentNotes count];
            break;
        case 1:
            return [self.notes count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Recent Notes";
            break;
        case 1:
            return @"All Notes";
            break;
        default:
            return @"";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    NoteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    
    
    
    Note *note = nil;
    
    switch (indexPath.section) {
        case 0:
            note = [self.recentNotes objectAtIndex:indexPath.row];
            break;
        case 1:
            note = [self.notes objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    cell.titleLabel.text = note.title;
    cell.detailLabel.text = note.text_content;
    
    //@"Here is the detail text of the note";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM/dd/yy HH:mm"];
    
    cell.dateLabel.text = [df stringFromDate: note.create_time];
    
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




#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.notes mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        
        lhs = [NSExpression expressionForKeyPath:@"text_content"];
        rhs = [NSExpression expressionForConstantValue:searchString];
        finalPredicate = [NSComparisonPredicate
                          predicateWithLeftExpression:lhs
                          rightExpression:rhs
                          modifier:NSDirectPredicateModifier
                          type:NSContainsPredicateOperatorType
                          options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
            

        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
//        NSExpression *lhs2 = [NSExpression expressionForKeyPath:@"text_content"];
//        NSExpression *rhs2 = [NSExpression expressionForConstantValue:searchString];

    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    NoteSearchResultsViewController *tableController = (NoteSearchResultsViewController *)self.searchController.searchResultsController;
    tableController.filteredNotes = searchResults;
    [tableController.tableView reloadData];
}


#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}








- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue");
    if([segue.identifier isEqualToString:@"createNote"]) {
        NSLog(@"Prepare here.");
        ViewController *v = (ViewController *)segue.destinationViewController;
        v.managedObjectContext = self.managedObjectContext;
        v.isNewDocument = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd HH:mm"];
        NSString *todayString=[dateFormatter stringFromDate:[NSDate date]];
        
        v.titleText = [NSString stringWithFormat:@"Note @ %@",todayString];
    }
    
    else if ([segue.identifier isEqualToString:@"openNote"]) {
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected");
    Note *note = nil;
    if(indexPath.section == 0){
        note = [self.recentNotes objectAtIndex:indexPath.row];
    }else{
        note = [self.notes objectAtIndex:indexPath.row];
    }
    
    //        NSData *jsonData = note.content;
    
    ViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"noteEditorID"];
    v.managedObjectContext = self.managedObjectContext;
    v.isNewDocument = NO;
    v.noteID = note.objectID;
    //        [v loadViews: note.objectID];
    //        [v loadViewsFromJSON:jsonData];
    v.titleText = note.title;
//    NSLog(@"open note");
//
//    NSDictionary *book = [books objectAtIndex:indexPath.section*2+indexPath.row];
//    NSLog(@"section: %ld row:%ld",(long)indexPath.section, (long)indexPath.row);
//    BookDetailViewController *bookDetailViewController = [[BookDetailViewController alloc]initWithBookID:[book[@"id"] intValue]];
//    bookDetailViewController.title = book[@"title"];
    [self.navigationController pushViewController:v animated:YES];
}

@end
