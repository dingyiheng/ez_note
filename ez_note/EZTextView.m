//
//  EZTextView.m
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import "EZTextView.h"

@implementation EZTextView{
    float bottomBlankHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithSettings:(NSDictionary *)settings{
    NSValue *sizeObj = settings[@"frameSize"];
    CGSize size = [sizeObj CGSizeValue];
    float width = size.width;
    float height = size.height;
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    self.backgroundColor = settings[@"backgroundColor"];
    self.scrollEnabled = NO;
    self.delegate = self;
    self.isBottomTextView = NO;
    bottomBlankHeight = [settings[@"bottomBlankHeight"] floatValue];
    return self;
}


- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"text changed");
    float oldHeight = textView.frame.size.height;
    if(self.isBottomTextView){
        CGFloat fixedWidth = textView.frame.size.width;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height+bottomBlankHeight);
        textView.frame = newFrame;
        NSLog(@"w:%f, h:%f", newFrame.size.width, newFrame.size.height);
    }else{
        
        CGFloat fixedWidth = textView.frame.size.width;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        NSLog(@"w:%f, h:%f", newFrame.size.width, newFrame.size.height);
        textView.frame = newFrame;
        
    }
    float newHeight = textView.frame.size.height;
    if(oldHeight != newHeight){
        NSNumber *deltaHeight = [NSNumber numberWithFloat:newHeight-oldHeight];
        NSDictionary *info = @{@"deltaHeight": deltaHeight};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"textViewHeightChanged" object:self userInfo:info];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textViewFocused" object:self userInfo:nil];
}


@end
