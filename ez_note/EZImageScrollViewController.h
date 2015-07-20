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
    UIView *containerView;
    UIImageView *imageView;
    CGFloat img_width;
    CGFloat img_height;
    CGFloat img_ratio;
//    CGFloat screen_width;
//    CGFloat screen_height;
//    CGFloat screen_ratio;
    CGFloat content_offset_x;
    CGFloat content_offset_y;
    CGFloat content_width;
    CGFloat content_height;
    CGFloat content_ratio;
}

@property UIImage *img;

- (id) initWithImage: (UIImage*) image;
- (id) initWithImageURL: (NSURL*) url;

@end
