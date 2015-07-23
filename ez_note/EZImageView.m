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


- (UIView *)viewFromNib{
    Class class = [self class];
    NSString *nibName = NSStringFromClass(class);
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    UIView *view = [nibViews objectAtIndex:0];
    return view;
}

- (void) addsubviewFromNib
{
    UIView *view = [self viewFromNib];
    view.frame = self.bounds;
    [self addSubview:view];
}


- (instancetype)initWithImage:(UIImage *) image {
    self.img = image;
    
    self.width_height_ratio = 3.0/2;
    
    self.view_Max_Width = screen_width * 0.95;
    self.view_Max_Height = self.view_Max_Width / self.width_height_ratio;
    UIImage *buttonImage = [self cropImage];
    
    self = [super initWithFrame: [self getViewFrame:buttonImage]];
    
    if(self){
        [self addsubviewFromNib];
//        [self.imgButton setImage:buttonImage forState:UIControlStateNormal];
        self.imageView.image = image;
    }
    return self;
}


- (CGRect) getViewFrame:(UIImage *) buttonImage {
    CGFloat view_Width = self.view_Max_Width;
    CGFloat view_Height = self.view_Max_Height;
    

    CGFloat img_Width = buttonImage.size.width;
    CGFloat img_Height = buttonImage.size.height;
    CGFloat img_ratio = img_Width / img_Height;
    
    // Over Size
    if(img_Width > self.view_Max_Width || img_Height > self.view_Max_Height) {
        //        button_Width = self.view_Max_Width;
        // too wide
        if (img_ratio > self.width_height_ratio)
            view_Height = view_Width / img_ratio;
        // too tall
        else {
            if (img_Width > self.view_Max_Width)
                view_Width = self.view_Max_Width;
            else
                view_Width = img_Width;
            
            view_Height = self.view_Max_Height;
        }
    }
    // too small
    else if (img_Width < self.view_Max_Width && img_Height < self.view_Max_Height) {
        view_Width = img_Width;
        view_Height = img_Height;
    }
    

    return CGRectMake(0, 0, view_Width, view_Height);
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


- (IBAction)imgTouched:(id)sender {
    NSLog(@"Pressed");
    NSDictionary *info = @{@"img": self.img};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageViewTouched" object:self userInfo:info];
}

- (id) getOutput{
    return nil;
}


@end
