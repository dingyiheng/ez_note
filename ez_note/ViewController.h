//
//  ViewController.h
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController <UITextFieldDelegate ,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


//extern const int16_t EZTypeTextView;
//extern const int16_t EZTypeAudioView;
//extern const int16_t EZTypeImageView;

@property (strong, nonatomic) NSMutableArray *myViews;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearButton;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;



@property (strong, nonatomic) NSManagedObjectID *noteID;

//@property (strong, nonatomic) UITextField *titleField;


@property (strong, nonatomic) NSString *titleText;






@property BOOL isNewDocument;


//-(void)loadViewsFromJSON:(NSData *)json;
-(void)loadViews:(NSManagedObjectID *) noteID;

@end

