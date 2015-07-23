//
//  EZImageView.h
//  EmptyApplication
//
//  Created by Ren Wan on 7/18/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZOptions.h"
#import "EZView.h"

@interface EZImageView : EZView

@property UIImage *img;
@property CGFloat view_Max_Width;
@property CGFloat view_Max_Height;
@property CGFloat width_height_ratio;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

// @property CGFloat x;
// @property CGFloat y;

@property EZOptions *options;
@property (strong, nonatomic) IBOutlet UIButton *imgButton;

- (instancetype)initWithImage:(UIImage *) image;
//- (id) initWithImage:(EZOptions*) opt Image:(UIImage*) img;

- (id) getOutput;

@end
