//
//  KeyBindingsViewController.h
//  inputTest
//
//  Created by Fred Wu on 7/17/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyBindingsViewController : UITableViewController
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *keyBindingTextField;

@end
