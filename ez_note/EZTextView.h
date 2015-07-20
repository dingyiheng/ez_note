//
//  EZTextView.h
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EZTextView : UITextView <UITextViewDelegate>


@property BOOL isBottomTextView;

- (instancetype)initWithSettings:(NSDictionary *)settings;

@end
