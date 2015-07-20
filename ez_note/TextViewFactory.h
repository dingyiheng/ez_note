//
//  TextViewFactory.h
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EZTextView.h"

@interface TextViewFactory : NSObject


@property (strong, nonatomic) NSMutableDictionary *settings;
@property (strong, nonatomic) UIColor *backgroundColor;
@property float bottomBlankHeight;
@property CGSize frameSize;


-(EZTextView *)createTextView;

@end
