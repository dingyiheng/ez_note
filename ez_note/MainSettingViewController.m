//
//  MainSettingViewController.m
//  ez_note
//
//  Created by Fred Wu on 7/28/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import "MainSettingViewController.h"

@interface MainSettingViewController ()

@end

@implementation MainSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)deleteAllButtonTouched:(id)sender {
    NSLog(@"I want to delete all");
    
    NSURL *appDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *documentsStorePath =
    [[appDir path] stringByAppendingPathComponent:@"Note.sqlite"];
    
    // if the expected store doesn't exist, copy the default store
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsStorePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Note" ofType:@"sqlite"];
        if (defaultStorePath) {
            [[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:documentsStorePath error:NULL];
        }
    }else{
        
        NSPersistentStoreCoordinator *storeCoordinator = [self.managedObjectContext persistentStoreCoordinator];
        NSPersistentStore *store = [[storeCoordinator persistentStores] objectAtIndex:0];
        if (![storeCoordinator removePersistentStore:store error:nil]) {
            NSLog(@"Error occurs when removing Persistence Store.");
        }
        if (![[NSFileManager defaultManager] removeItemAtPath:documentsStorePath error:nil]){
            NSLog(@"Error occurs when removing DB file.");
        }
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Note" ofType:@"sqlite"];
        if (defaultStorePath) {
            [[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:documentsStorePath error:NULL];
        }

    }
    
    
}

@end
