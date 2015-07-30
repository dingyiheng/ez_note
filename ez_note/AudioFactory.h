//
//  AudioFactory.h
//  try_20150719_audioView
//
//  Created by Yiheng Ding on 7/19/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioView.h"


@interface AudioFactory : NSObject


@property NSMutableDictionary *recordSetting;

@property float width;
@property float height;
@property UIColor *backgroundColor;

@property NSString *title;
@property float timeLimit;

- (AudioView *)createViewWithSettings;
- (AudioView *)createViewWithSettingsAndURL:(NSURL *)url;

@end
