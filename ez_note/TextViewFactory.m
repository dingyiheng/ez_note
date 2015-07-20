//
//  TextViewFactory.m
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import "TextViewFactory.h"



@implementation TextViewFactory

-(NSMutableDictionary *)settings{
    if(!_settings){
        NSLog(@"widthss:%f", self.frameSize.width);
        _settings = [[NSMutableDictionary alloc]initWithObjectsAndKeys: [NSValue valueWithCGSize: self.frameSize], @"frameSize", [UIColor whiteColor], @"backgroundColor", [NSNumber numberWithFloat: self.bottomBlankHeight], @"bottomBlankHeight", nil];
    }
    return _settings;
}


- (instancetype)init{
    self = [super init];
    if(self){
        self.frameSize = CGSizeMake(500, 300);
        self.bottomBlankHeight = 300;
        self.backgroundColor = [UIColor greenColor];
        return self;
    }else{
        NSLog(@"TextView Factory not initialized.");
        return nil;
    }

}



-(EZTextView *)createTextView{
    EZTextView *tv = [[EZTextView alloc] initWithSettings:self.settings];
    NSLog(@"width:%@", self.settings[@"frameSize"]);
    return tv;
}

@end
