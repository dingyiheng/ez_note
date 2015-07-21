//
//  EZImageScrollViewController.h
//  EmptyApplication
//
//  Created by Ren Wan on 7/19/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZImageScrollViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *sView;
    UIImageView *imageView;
    CGFloat img_width;
    CGFloat img_height;
    CGFloat img_ratio;
    
    CGFloat imgview_start_x;
    CGFloat imgview_start_y;
    CGFloat imgview_width;
    CGFloat imgview_height;
}

@property UIImage *img;

- (id) initWithImage: (UIImage*) image;
- (id) initWithImageURL: (NSURL*) url;

@end
