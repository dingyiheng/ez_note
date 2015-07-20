//
//  ViewController.m
//  ez_note
//
//  Created by Yiheng Ding on 7/19/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import "ViewController.h"
#import "AudioView.h"
#import "AudioFactory.h"

@interface ViewController ()

@end

@implementation ViewController{
    float screenWidth;
    float screenHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    
    AudioFactory *af = [[AudioFactory alloc]init];
    AudioView *av = [af createViewWithSettings];
    av.center = CGPointMake(100, 200);
    [self.view addSubview:av];
    
    [av startRecording];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
