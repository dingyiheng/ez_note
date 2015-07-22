//
//  ToolBarView.h
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolBarView : UIToolbar

@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIButton *audioButton;
@property (strong, nonatomic) IBOutlet UIButton *keyboardButton;


- (void)showRecording;
- (void)finishRecording;

@end
