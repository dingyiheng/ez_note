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

@interface EZImageView : EZView {
    CGFloat widthscale;
}

@property UIImage *img;
@property UIImage *dispImage;
@property NSURL *url;
@property CGFloat view_Max_Width;
@property CGFloat view_Max_Height;
@property CGFloat width_height_ratio;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

// @property CGFloat x;
// @property CGFloat y;

@property EZOptions *options;
@property (strong, nonatomic) IBOutlet UIButton *imgButton;

- (instancetype)initWithImage:(UIImage *) image;
- (instancetype)initWithURL:(NSURL *) imageURL;
- (BOOL) saveImage;
- (BOOL) deleteImage;
//- (id) initWithImage:(EZOptions*) opt Image:(UIImage*) img;
- (void) update;
- (void) updateFrame;
- (id) getOutput;

@end
