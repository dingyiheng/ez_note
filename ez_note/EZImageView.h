//
//  EZImageView.h
//  EmptyApplication
//
//  Created by Ren Wan on 7/18/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZOptions.h"


@interface EZImageView : UIButton

@property UIImage *img;
@property CGFloat view_Max_Width;
@property CGFloat view_Max_Height;
@property CGFloat width_height_ratio;


@property CGFloat x;
@property CGFloat y;

@property EZOptions *options;


- (id) initWithImage:(EZOptions*) opt Image:(UIImage*) img;

@end
