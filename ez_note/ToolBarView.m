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
}
//
//- (void)showRecording{
//    self.audioButton.tintColor = [UIColor redColor];
//}

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
