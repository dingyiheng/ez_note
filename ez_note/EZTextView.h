//
//  EZTextView.h
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EZTextView : UITextView <UITextViewDelegate>{
    NSMutableDictionary *keyNameproperties;
    unsigned functionCharLen;
}


@property BOOL isBottomTextView;


typedef enum {
    FormatTypeH1,
    FormatTypeH2,
    FormatTypeH3,
    FormatTypeBold,
    FormatTypeItalic,
    FormatTypeUnderlined,
    FormatTypeHighlighted,
    FormatTypeCenter,
    FormatTypeNone
} FormatType;


typedef enum {
    FormatScopeCharacter,
    FormatScopeWord,
    FormatScopeLine,
    FormatScopeNone
} FormatScope;


- (instancetype)initWithSettings:(NSDictionary *)settings;

@end
