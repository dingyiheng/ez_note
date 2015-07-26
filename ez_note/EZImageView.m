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


- (instancetype)initWithURL:(NSURL *) imageURL {
    NSData *data =[NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:data];
    return [self initWithImage:image];
}

- (instancetype)initWithImage:(UIImage *) image {
    //    self.img = image;
    
    NSLog(@"Image Oriientation: %ld", [image imageOrientation]);
    
    self.img = [self fixOrientation:image];
    if (![self saveImage:self.img]) {
        NSLog(@"Can't save image");
    }
    
    NSLog(@"%@", [self.url path]);
    
    /*
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if( [filemgr fileExistsAtPath:[self.url path]])
         NSLog(@"Existing");
    else
        NSLog(@"Not existing");
    
    NSError * error;
    NSData *ImageData = [NSData dataWithContentsOfURL:self.url options:NSDataReadingUncached error:&error];
    self.img = [UIImage imageWithData:ImageData];
    //*/
     
     
    self.width_height_ratio = 3.0/2;
    
    self.view_Max_Width = screen_width * 0.95;
    self.view_Max_Height = self.view_Max_Width / self.width_height_ratio;
    UIImage *buttonImage = [self cropImage];
    
//    NSLog(@"buttonImage frame width:%f height:%f", [self getViewFrame:buttonImage].size.width, [self getViewFrame:buttonImage].size.height);
    
    self = [super initWithFrame: [self getViewFrame:buttonImage]];
    
    if(self){
        [self addsubviewFromNib];
//        [self.imgButton setImage:buttonImage forState:UIControlStateNormal];
        self.imageView.image = buttonImage;
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
    //*
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
        
//        croppedImg = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:[self.img imageOrientation]];
        
        NSLog(@"Cropped Image Oriientation: %ld", [croppedImg imageOrientation]);
        
        CGImageRelease(imageRef);
    }
     //*/
    
    return croppedImg;
}


- (UIImage *)fixOrientation:(UIImage *) image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *imgToDisplay = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return imgToDisplay;
}

- (IBAction)imgTouched:(id)sender {
    NSLog(@"Pressed");
    NSDictionary *info = @{@"img": self.img};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageViewTouched" object:self userInfo:info];
}

- (id) getOutput {
    return self.url;
}


- (BOOL) saveImage: (UIImage *) image {
    BOOL sucess = YES;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
    NSString *path = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
/*
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyFolder"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
 */
    
    [filemgr createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *guid = [[NSUUID new] UUIDString];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1e20];
    NSString *filename = [NSString stringWithFormat:@"%@%@%@", guid, timestamp, @".png"];
    path = [path stringByAppendingPathComponent:filename];
    NSData *imageData = UIImagePNGRepresentation(image);
    if(![imageData writeToFile:path atomically:YES]) {
        sucess = NO;
    }
    path = [NSString stringWithFormat:@"file://%@", path];
    self.url = [NSURL URLWithString:path];
    
    /*
    
    NSURL *directoryURL = <#An NSURL object that contains a reference to a directory#>;
    
    NSArray *keys = [NSArray arrayWithObjects:
                     NSURLIsDirectoryKey, NSURLIsPackageKey, NSURLLocalizedNameKey, nil];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:(NSDirectoryEnumerationSkipsPackageDescendants |
                                                  NSDirectoryEnumerationSkipsHiddenFiles)
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return <#YES or NO#>;
                                         }];
    
    for (NSURL *url in enumerator) {
        
        // Error checking is omitted for clarity.
        
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        if ([isDirectory boolValue]) {
            
            NSString *localizedName = nil;
            [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
            
            NSNumber *isPackage = nil;
            [url getResourceValue:&isPackage forKey:NSURLIsPackageKey error:NULL];
            
            if ([isPackage boolValue]) {
                NSLog(@"Package at %@", localizedName);
            }
            else {
                NSLog(@"Directory at %@", localizedName);
            }
        }
    }
    */
    
    
    return sucess;
    
}

- (BOOL) deleteImage {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSError *error;
    BOOL sucess = [filemgr removeItemAtURL:self.url error:&error];
    return sucess;
}

@end
