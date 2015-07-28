//
//  ViewController.h
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (strong, nonatomic) NSMutableArray *myViews;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearButton;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;



@property (strong, nonatomic) NSManagedObjectID *noteID;

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property BOOL isNewDocument;


//-(void)loadViewsFromJSON:(NSData *)json;
-(void)loadViews:(NSManagedObjectID *) noteID;

@end

