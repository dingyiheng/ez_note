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

- (id) initWithImageURL: (NSURL*) url {
    self = [super init];
    if(self){
        NSData *data =[NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        self.img = img;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    img_width = self.img.size.width;
    img_height = self.img.size.height;
    img_ratio = img_height / img_width;
    
    
    // Create a scroll view
    
    sView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    imageView = [UIImageView new];
    imageView.image = self.img;
    
    sView.delegate = self;
    sView.bouncesZoom = YES;
    sView.backgroundColor = [UIColor blackColor];
    
    [self updateImageView];
    
    [sView addSubview:imageView];
    
    self.view = sView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView) name:UIDeviceOrientationDidChangeNotification object: nil];
//    printf("sView Bounds originX:%f originY:%f width:%f  height:%f\n", sView.bounds.origin.x, sView.bounds.origin.y, sView.bounds.size.width, sView.bounds.size.height);
//    printf("sView ContentOffset x:%f  y:%f  ContentSize width %f  height:%f\n", sView.contentOffset.x, sView.contentOffset.y, sView.contentSize.width, sView.contentSize.height);
//    printf("sView Frame originX:%f originY:%f width %f  height:%f\n", sView.frame.origin.x, sView.frame.origin.y, sView.frame.size.width, sView.frame.size.height);
//    printf("imageView Bounds originX:%f originY:%f width:%f  height:%f\n", imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height);
//    printf("imageView Frame originX:%f originY:%f width %f  height:%f\n", imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
    
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTaped:)];
    [self.view addGestureRecognizer:tapRecognizer];
}


- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateImageView {
    imgview_start_x = 0;
    imgview_start_y = 0;
    imgview_width = screen_width;
    imgview_height = screen_height;
    
    zoomscale = 1;
    
    // over size
    if (img_height > screen_height || img_width > screen_width){
        // thin tall
        if (img_width < screen_width) {
            imgview_start_x = (screen_width - img_width) / 2;
            //            content_offset_x = (screen_width - img_width) / 2;
            imgview_width = img_width;
            imgview_height = img_height;
        }
        else {
            zoomscale = img_width / screen_width;
            imgview_height = img_height / zoomscale;
            
            // wide
            if (imgview_height < screen_height) {
                imgview_start_y = (screen_height - imgview_height) / 2;
                //                content_offset_y = (screen_height - imgview_height) / 2;
            }
        }
    }
    else {
        imgview_start_x = (screen_width - img_width) / 2;
        imgview_start_y = (screen_height -img_height) / 2;
        imgview_width = img_width;
        imgview_height = img_height;
    }
    
    CGRect frame = CGRectMake(imgview_start_x, imgview_start_y, imgview_width, imgview_height);
    imageView.frame = frame;
    
//    imageView.image = self.img;
    
    //    [sView sizeToFit];
    sView.contentSize = imageView.bounds.size;
    
    // Minimum and maximum zoom scales
    
    sView.minimumZoomScale = 1.0;
    sView.maximumZoomScale = zoomscale * 2.0;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    printf("sView Bounds originX:%f originY:%f width:%f  height:%f\n", scrollView.bounds.origin.x, scrollView.bounds.origin.y, scrollView.bounds.size.width, scrollView.bounds.size.height);
//    printf("sView ContentOffset x:%f  y:%f  ContentSize width %f  height:%f\n", scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.contentSize.width, scrollView.contentSize.height);
//    //    printf("sView Frame originX:%f originY:%f width %f  height:%f\n", scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
//    printf("imageView Bounds originX:%f originY:%f width:%f  height:%f\n", imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height);
//    printf("imageView Frame originX:%f originY:%f width %f  height:%f\n", imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
//    printf("******************************************\n");
}


// Implement the UIScrollView delegate method so that it knows which view to scale when zooming.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    printf("sView Bounds originX:%f originY:%f width:%f  height:%f\n", scrollView.bounds.origin.x, scrollView.bounds.origin.y, scrollView.bounds.size.width, scrollView.bounds.size.height);
//    printf("sView ContentOffset x:%f  y:%f  ContentSize width %f  height:%f\n", scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.contentSize.width, scrollView.contentSize.height);
//    printf("imageView Bounds originX:%f originY:%f width:%f  height:%f\n", imageView.bounds.origin.x, imageView.bounds.origin.y, imageView.bounds.size.width, imageView.bounds.size.height);
//    printf("imageView Frame originX:%f originY:%f width %f  height:%f\n", imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
//    printf("******************************************\n");
    
    [self updateImageViewFrame];

}

- (void)updateImageViewFrame {
    CGRect frame = imageView.frame;
    
    
    NSLog (@"Screen width: %f  Screen height:  %f", screen_width, screen_height);
    
    if (frame.size.width < screen_width) {
        frame.origin.x = (screen_width - frame.size.width) / 2;
    }
    else {
        frame.origin.x = 0;
    }
    
    if (frame.size.height < screen_height) {
        frame.origin.y = (screen_height - frame.size.height) / 2;
    }
    else {
        frame.origin.y = 0;
    }
    
    imageView.frame = frame;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) screenTaped:(UITapGestureRecognizer *)reognizer {
    NSLog(@"Taped");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageTaped" object:self userInfo:nil];
}

@end
