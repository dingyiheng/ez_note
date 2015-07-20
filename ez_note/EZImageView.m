//
//  EZImageView.m
//  EmptyApplication
//
//  Created by Ren Wan on 7/18/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import "EZImageView.h"
#import "utilities.h"

@implementation EZImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id) initWithImage:(EZOptions*) opt Image:(UIImage*) image
{
    self.width_height_ratio = 3.0/2;
    
    self.view_Max_Width = 300;
    self.view_Max_Height = self.view_Max_Width / self.width_height_ratio;
    
    CGFloat button_Width = self.view_Max_Width;
    CGFloat button_Height = self.view_Max_Height;
    self.img = image;
    
    UIImage *buttonImage = [self cropImage];
    CGFloat img_Width = buttonImage.size.width;
    CGFloat img_Height = buttonImage.size.height;
    CGFloat img_ratio = img_Width / img_Height;
    
    // Over Size
    if(img_Width > self.view_Max_Width || img_Height > self.view_Max_Height) {
//        button_Width = self.view_Max_Width;
        // too wide
        if (img_ratio > self.width_height_ratio)
            button_Height = button_Width / img_ratio;
        // too tall
        else {
            if (img_Width > self.view_Max_Width)
                button_Width = self.view_Max_Width;
            else
                button_Width = img_Width;
            
            button_Height = self.view_Max_Height;
        }
    }
    // too small
    else if (img_Width < self.view_Max_Width && img_Height < self.view_Max_Height) {
        button_Width = img_Width;
        button_Height = img_Height;
    }
    
    NSLog (@"Button Width: %f  Button Height  %f", button_Width, button_Height);
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;    // 375
    self.x = (screenWidth - button_Width) / 2;
    
    self = [super initWithFrame:CGRectMake(self.x, 0, button_Width, button_Height)];
    [self setImage:buttonImage forState:UIControlStateNormal];
    [self addTarget:self action:@selector(imgPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;

}

- (UIImage *) cropImage {
    CGFloat img_Width = self.img.size.width;
    CGFloat img_Height = self.img.size.height;
    
    UIImage *croppedImg = self.img;
    
    if(img_Height > self.view_Max_Height) {
        CGFloat origin_x;
        CGFloat origin_y;
        CGFloat disp_height;
        CGFloat disp_width;
        CGRect croprect;
        
        if (img_Width > self.view_Max_Width)
            disp_height = self.view_Max_Height * img_Width / self.view_Max_Width;
        else
            disp_height = self.view_Max_Height;
        
        disp_width = img_Width;
        
        origin_x = 0;
        origin_y = (img_Height - disp_height) / 2;
        
        croprect = CGRectMake(origin_x, origin_y, disp_width, disp_height);
        
        // Draw new image in current graphics context
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.img CGImage], croprect);
        
        // Create new cropped UIImage
        croppedImg = [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
    }
    return croppedImg;
}

- (void) imgPressed:(EZImageView *) EZIV {
    
//    [self.navigationController pushViewController:playboard animated:YES];
    NSLog(@"Pressed");
}


@end
