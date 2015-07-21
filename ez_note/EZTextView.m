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
    
    NSString *path;
    NSString *writingPath;
    path = [[NSBundle mainBundle] pathForResource:@"KeyBindings" ofType:@"plist"];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *writingFolder = [arrayPaths objectAtIndex:0];
    writingPath =[[NSString alloc] initWithString:[writingFolder stringByAppendingPathComponent:@"KeyBindings.plist"]];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:writingPath]) {
        if([[NSFileManager defaultManager] copyItemAtPath:path  toPath:writingPath error:&error]){
        }else{
            NSLog(@"Failed");
        }
        keyNameproperties = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }else{
        keyNameproperties = [NSMutableDictionary dictionaryWithContentsOfFile:writingPath];
    }
    functionCharLen = (unsigned)[[keyNameproperties objectForKey:@"functional_char"] length];
    
    return self;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    NSLog(@"text changed");
    
    
    
    //----------formatter part----------------
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSString *lastChars = [self getLastChars:functionCharLen+2];
    //    NSLog(@"%@",lastChars);
    FormatType formatType = FormatTypeNone;
    FormatScope formatScope = FormatScopeNone;
    if ([self isValidFormatter:lastChars]){
        //        NSLog(@"YES");
        formatType = [self getFormatType:lastChars];
        formatScope = [self getFormatScope:lastChars];
        NSRange r = self.selectedRange;
        long loc = r.location-functionCharLen-2;
        NSString *beforeString = [textView.text substringToIndex:loc];
        NSRange formatRange = [self getShouldBeFormattedRange:formatScope beforeString:beforeString];
        NSLog(@"Format text:%@", [self.text substringWithRange:formatRange]);
        NSString *typeName = [self getFormatTypeName:formatType];
        id value = [self getFormatTypeValue:formatType];
        NSLog(@"%@", value);
        
        
        [attributedText addAttribute:typeName value:value range:formatRange];
        [attributedText replaceCharactersInRange: NSMakeRange(loc, functionCharLen+2) withString:@" "];
        self.attributedText = attributedText;
        self.selectedRange = NSMakeRange(loc+1, 0);
    }else{
        NSLog(@"NO");
    }
    //------------formatter part end -------------
    
    
    
    
    
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






- (NSString *)getLastChars:(unsigned)length{
    if(self.text.length < length){
        return self.text;
    }
    NSRange r = self.selectedRange;
    long loc = r.location;
    NSString *s = [self.text substringWithRange: NSMakeRange(loc-length, length)];
    return s;
}


-(BOOL)isValidFormatter:(NSString *)s{
    NSMutableArray *formatTypeArray = [[NSMutableArray alloc] init];
    NSMutableArray *formatScopeArray = [[NSMutableArray alloc] init];
    NSArray *keys = [keyNameproperties allKeys];
    for (NSString *k in keys){
//        NSLog(@"k:%@",k);
        if([k hasPrefix:@"heading"] || [k hasPrefix:@"style"] || [k hasPrefix:@"alignment"]){
//            NSLog(@"ppp:%@",[keyNameproperties objectForKey:k]);
            [formatTypeArray addObject: [keyNameproperties objectForKey:k]];
        }else if([k hasPrefix:@"scope"]){
            [formatScopeArray addObject: [keyNameproperties objectForKey:k]];
        }
    }
//    NSLog(@"count:%lu",(unsigned long)[keyNameproperties count]);
//    NSLog(@"formatTypeArray:%@",formatTypeArray);
//    NSLog(@"len:%u", functionCharLen);
    if([s length] == functionCharLen + 2){
        if ([[s substringWithRange:NSMakeRange(0, functionCharLen)] isEqual: [keyNameproperties objectForKey:@"functional_char"]]) {
            NSLog(@"Enter 1");
            NSString *subStr1 = [s substringWithRange:NSMakeRange(functionCharLen, 1)];
            //            NSLog(@"%@", subStr1);
            if ([formatTypeArray containsObject:subStr1]){
                NSLog(@"Enter 2");
                if ([formatScopeArray containsObject:[s substringWithRange:NSMakeRange(functionCharLen+1, 1)]]){
                    NSLog(@"Valid Formatter");
                    return YES;
                }
            }
        }
    }
     NSLog(@"Not a Valid Formatter");
    return NO;
    
}


- (FormatType)getFormatType:(NSString *)s{
    NSString *typeStr = [s substringWithRange:NSMakeRange(functionCharLen, 1)];
    if([typeStr isEqual:[keyNameproperties objectForKey:@"style_bold"]]){
        return FormatTypeBold;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"style_italic"]]){
        return FormatTypeItalic;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"style_underlined"]]){
        return FormatTypeUnderlined;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"heading_h1"]]){
        return FormatTypeH1;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"heading_h2"]]){
        return FormatTypeH2;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"heading_h3"]]){
        return FormatTypeH3;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"style_highlighted"]]){
        return FormatTypeHighlighted;
    }else if([typeStr isEqual: [keyNameproperties objectForKey:@"alignment_center"]]){
        return FormatTypeCenter;
    }
    return FormatTypeNone;
}

- (FormatScope)getFormatScope:(NSString *)s{
    NSString *typeStr = [s substringWithRange:NSMakeRange(functionCharLen+1, 1)];
    if([typeStr isEqual:[keyNameproperties objectForKey:@"scope_character"]]){
        return FormatScopeCharacter;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"scope_word"]]){
        return FormatScopeWord;
    }else if([typeStr isEqual:[keyNameproperties objectForKey:@"scope_paragraph"]]){
        return FormatScopeLine;
    }
    return FormatScopeNone;
}


- (NSRange)getShouldBeFormattedRange:(FormatScope)scope beforeString:(NSString *)s{
    switch (scope) {
        case FormatScopeCharacter:{
            return NSMakeRange(s.length-1, 1);
            break;
        }
        case FormatScopeWord:{
            NSRange scopeRange = [s rangeOfString:@" " options:NSBackwardsSearch];
            long loc = scopeRange.location;
            if (loc == NSNotFound){
                NSRange scopeRange = [s rangeOfString:@"\n" options:NSBackwardsSearch];
                loc = scopeRange.location;
            }
            if (loc == NSNotFound){
                loc = -1;
            }
            return NSMakeRange(loc+1, s.length-loc-1);
            break;
        }
        case FormatScopeLine:{
            NSRange scopeRange = [s rangeOfString:@"\n" options:NSBackwardsSearch];
            long loc = scopeRange.location;
            if (loc == NSNotFound){
                loc = -1;
            }
            return NSMakeRange(loc+1, s.length-loc-1);
            break;
        }
        default:
            return NSMakeRange(0, 1);
            break;
    }
    return NSMakeRange(0, 1);
}

- (NSString *)getFormatTypeName:(FormatType)type{
    switch (type) {
        case FormatTypeBold:
        case FormatTypeItalic:
        case FormatTypeH1:
        case FormatTypeH2:
        case FormatTypeH3:
            return NSFontAttributeName;
            break;
        case FormatTypeUnderlined:
            return NSUnderlineStyleAttributeName;
            break;
        case FormatTypeHighlighted:
            return NSBackgroundColorAttributeName;
            break;
        case FormatTypeCenter:
            return NSParagraphStyleAttributeName;
            break;
        default:
            return NSFontAttributeName;
    }
}

- (id)getFormatTypeValue:(FormatType)type{
    switch (type) {
        case FormatTypeBold:{
            UIFontDescriptor *boldFontDescriptor = [self.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
            UIFont *boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size:0];
            return boldFont;
            break;
        }
        case FormatTypeItalic:{
            UIFontDescriptor *boldFontDescriptor = [self.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
            UIFont *italicFont = [UIFont fontWithDescriptor:boldFontDescriptor size:0];
            return italicFont;
            break;
        }
        case FormatTypeUnderlined:{
            //            return @(NSUnderlineStyleSingle);
            return @(NSUnderlineStyleSingle);
            break;
        }
        case FormatTypeHighlighted:{
            return [UIColor yellowColor];
            //            [UIColor colorWithRed:0.255 green:0.804 blue:0.470 alpha:1]
            break;
        }
        case FormatTypeH1:{
            return [UIFont systemFontOfSize:32];
            break;
        }
        case FormatTypeH2:{
            return [UIFont systemFontOfSize:24];
            break;
        }
        case FormatTypeH3:{
            return [UIFont systemFontOfSize:18];
            break;
        }
        case FormatTypeCenter:{
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            return paragraphStyle;
            break;
        }
            
        default:
            return nil;
            break;
            
    }
    return nil;
}



@end
