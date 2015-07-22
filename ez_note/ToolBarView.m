//
//  ToolBarView.m
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import "ToolBarView.h"

@implementation ToolBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)viewFromNib
{
    Class class = [self class];
    NSString *nibName = NSStringFromClass(class);
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    UIView *view = [nibViews objectAtIndex:0];
    return view;
}


- (void)addSubviewFromNib
{
    UIView *view = [self viewFromNib];
    view.frame = self.bounds;
    [self addSubview:view];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviewFromNib];
    }
    
    return self;
}


- (void)showRecording{
    self.audioButton.tintColor = [UIColor redColor];
//    [UIView animateWithDuration:5.0f animations:^{
//        self.audioButton.tintColor = [UIColor redColor];
//    } completion:^(BOOL finished) {
//    }];
    
//    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^(void) { self.audioButton.tintColor = [UIColor redColor]; } completion:^(BOOL finished) {
//                             __weak id weakSelf = self;
//                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                                 [weakSelf showRecording];
//                             }];
//                         }
//
//     ];
//    
//    CABasicAnimation *theAnimation;
//    theAnimation=[CABasicAnimation animationWithKeyPath:@"backgroundColor"];
//    theAnimation.duration=1;
//    theAnimation.repeatCount= UINT32_MAX;
//    theAnimation.autoreverses = YES;
//    theAnimation.fromValue= [UIColor redColor];
//    theAnimation.toValue= [UIColor colorWithRed:0.21 green:0.43 blue:0.12 alpha:1];
//    [self.audioButton.layer addAnimation:theAnimation forKey:@"animateLayer"];
}

- (void)finishRecording{
    self.audioButton.tintColor = [UIColor colorWithRed:0.21 green:0.43 blue:0.12 alpha:1];
}
//
//- (void)showRecording{
//    self.audioButton.tintColor = [UIColor redColor];
//}


- (IBAction)cameraButtonTouched:(id)sender {
    NSLog(@"Camera Button Touched");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraButtonTouched" object:self userInfo:nil];
}

- (IBAction)imageButtonTouched:(id)sender {
    NSLog(@"Image Button Touched");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageButtonTouched" object:self userInfo:nil];
}
- (IBAction)audioButtonTouched:(id)sender {
    NSLog(@"Audio Button Touched");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"audioButtonTouched" object:self userInfo:nil];
}
- (IBAction)keyboardButtonTouched:(id)sender {
    NSLog(@"Keyboard Button Touched");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardButtonTouched" object:self userInfo:nil];
}



@end
