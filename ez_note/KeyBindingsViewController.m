//
//  KeyBindingsViewController.m
//  inputTest
//
//  Created by Fred Wu on 7/17/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import "KeyBindingsViewController.h"
#import "KeyBindingTextField.h"

@interface KeyBindingsViewController (){
    NSString *path;
    NSString *writingPath;
    NSMutableDictionary *keyNameproperties;
}

@end

@implementation KeyBindingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    path = [[NSBundle mainBundle] pathForResource:@"KeyBindings" ofType:@"plist"];
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *writingFolder = [arrayPaths objectAtIndex:0];
    writingPath =[[NSString alloc] initWithString:[writingFolder stringByAppendingPathComponent:@"KeyBindings.plist"]];
    NSLog(@"writing path: %@", writingPath);
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:writingPath]) {
        NSLog(@"NO Exist");
        if([[NSFileManager defaultManager] copyItemAtPath:path  toPath:writingPath error:&error]){
            NSLog(@"Success");
        }else{
            NSLog(@"Failed");
        }
        keyNameproperties = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }else{
        NSLog(@"Exist");
        keyNameproperties = [NSMutableDictionary dictionaryWithContentsOfFile:writingPath];
    }
    for (KeyBindingTextField *f in self.keyBindingTextField){
        NSLog(@"%@",f.keyBindingName);
        f.text = [keyNameproperties objectForKey: f.keyBindingName];
    }
    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        path = [[NSBundle mainBundle] pathForResource:@"KeyBindings" ofType:@"plist"];
//        
//    }
//    NSLog(@"%@", [keyNameproperties objectForKey:@"scope_word"]);
    
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
// 
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
- (IBAction)keyBindingEditingDidEnd:(UITextField *)sender {
//    int index = [[self.keyBindingTextField objectAtIndex:sender] intValue];
//    NSLog(@"%@", sender);
    NSString *keyName = [sender valueForKey:@"keyBindingName"];
    NSLog(@"%@", keyName);
//    NSLog(@"%@", [sender text]);
    [keyNameproperties setValue:[sender text] forKey:keyName];
    NSLog(@"%@", [keyNameproperties objectForKey: keyName]);
    NSError *error;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:keyNameproperties format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if(data) {
        if([data writeToFile:writingPath atomically:YES]){
            NSLog(@"success");
        }else{
            NSLog(@"failed");
        };
//
    }else{
        NSLog(@"%@",error);
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

@end
