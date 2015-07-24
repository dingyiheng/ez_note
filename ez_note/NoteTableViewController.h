//
//  NoteTableViewController.h
//  ez_note
//
//  Created by Fred Wu on 7/23/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSMutableArray *notes;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
