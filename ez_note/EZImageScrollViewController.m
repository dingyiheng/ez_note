//
//  EZImageScrollViewController.m
//  EmptyApplication
//
//  Created by Ren Wan on 7/19/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import "EZImageScrollViewController.h"
#import "utilities.h"

@interface EZImageScrollViewController ()

@end

@implementation EZImageScrollViewController


- (id) initWithImage: (UIImage*) image {
    self = [super init];
    if(self)
        self.img = image;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Create a scroll view
    
    sView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    sView.delegate = self;
    sView.bouncesZoom = YES;
    
    sView.backgroundColor = [UIColor blackColor];
    
  
    img_width = self.img.size.width;
    img_height = self.img.size.height;
    img_ratio = img_height / img_width;
    
    
    CGFloat imgview_start_x = 0;
    CGFloat imgview_start_y = 0;
    CGFloat imgview_width = img_width;
    CGFloat imgview_height = img_height;
    
    content_offset_x = 0;
    content_offset_y = 0;
    content_width = img_width;
    content_height = img_height;
    
    
//    imgview_center_x = screen_width / 2;
//    imgview_center_y = screen_height / 2;
    
    //
//    if (img_height > screen_height && img_ratio > screen_ratio) {
//        
//        
//        imgview_center_x = screen_width / 2;
//        imgview_center_y = img_height / 2;
//    }
    
    
//    CGFloat zoom_ratio = 0.1;
    
    
    
    if (img_width > screen_width) {
//        sView.zoomScale = screen_width / img_width;
    }
    
    // over size
    if (img_height > screen_height || img_width > screen_width){
        // too tall
        if (img_ratio > screen_ratio) {
            if (img_width < screen_width) {
                imgview_start_x = (screen_width - img_width) / 2;

            }
//            if (img_width > screen_width) {
//                sView.zoomScale = screen_width / img_width;
//            }
            
        }
        // too wide
//        else {
//            imgview_Width = screen_Width;
//            imgview_Height = img_Height * screen_Width / img_Width;
    
//        }
    }


//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:self.img];
//    tempImageView.frame = sView.bounds;
//    imageView = tempImageView;
    
//    sView.backgroundColor = [UIColor blackColor];
//    sView.minimumZoomScale = 1.0  ;
//    sView.maximumZoomScale = imageView.image.size.width / scrollView.frame.size.width;
//    sView.zoomScale = 1.0;
//    scrollView.delegate = self;
//    
//    [scrollView addSubview:imageView];
    
    
    
    
    
    CGRect frame = CGRectMake(imgview_start_x, imgview_start_y, imgview_width, imgview_height);
    imageView = [[UIImageView alloc] initWithFrame:frame];
//    imageView.center = CGPointMake(screen_width/2, screen_height/2);
    imageView.image = self.img;
    
    [sView addSubview:imageView];
    
//    [sView sizeToFit];
    sView.contentOffset = CGPointMake(0, content_offset_y);
    sView.contentSize = CGSizeMake(content_width, content_height);
    
    
    
    // Add it as a subview of the container view.
//    [containerView addSubview:imageView];
    
    // Size the container view to fit. Use its size for the scroll view's content size as well.//
//    containerView.frame = CGRectMake(0, 0, img_Width, img_Height);
//    scrollView.contentSize = containerView.frame.size;
    
    // Minimum and maximum zoom scales
    
    // TODO
    sView.minimumZoomScale = MIN(screen_width / img_width, img_width / screen_width);
    sView.maximumZoomScale = 200.0;
    sView.contentMode = UIViewContentModeScaleAspectFit;
    
//    scrollView.con
//    scrollView.contentOffset  CGPoint
    
//    [self.view addSubview:scrollView];
    self.view = sView;
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



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}


// Implement the UIScrollView delegate method so that it knows which view to scale when zooming.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"Bounds width:%f  height:%f", scrollView.bounds.size.width, scrollView.bounds.size.height);
//    NSLog(@"ContentSize width %f  height:%f", scrollView.contentSize.width, scrollView.contentSize.height);

//    UIView *subView = [scrollView.subviews objectAtIndex:0];
//    
//    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
//    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
//    
//    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                 scrollView.contentSize.height * 0.5 + offsetY);
}


@end
