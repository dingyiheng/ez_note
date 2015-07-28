//
//  AudioFactory.m
//  try_20150719_audioView
//
//  Created by Yiheng Ding on 7/19/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import "AudioFactory.h"

@implementation AudioFactory{
    NSMutableDictionary *settings;
}


- (NSMutableDictionary *)settings{
    if(!settings){
        settings = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithFloat: self.height],@"height",[NSNumber numberWithFloat: self.width] ,@"width",self.outputFileURL,@"outputFileURL",self.recordSetting,@"recordSetting",self.title,@"title",self.backgroundColor,@"backgroundColor",[NSNumber numberWithFloat:self.timeLimit],@"timeLimit" ,nil];
        
    }
    return settings;
}

-(instancetype)init{
    self = [super init];
    
    if(self){
        self.height = 50;
        self.width = 360;
        self.backgroundColor = [UIColor whiteColor];
        self.title = @"Audio Record";
        self.timeLimit = 3600.0f;
        
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"MyAudioMemo.m4a",
                                   nil];
        self.outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        //NSLog(@"%@", self.outputFileURL);
        
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        // Define the recorder setting
        self.recordSetting = [[NSMutableDictionary alloc] init];
        
        [self.recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [self.recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [self.recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];

    }
    
    return self;
}

- (AudioView *)createViewWithSettings{
    //time stamp for naming the record
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"yyyyMMddHHmmss" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",todayString);
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               todayString,
                               nil];
    self.outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    NSLog(@"%@",self.outputFileURL);
    
    AudioView *v = [[AudioView alloc] initWithFactorySettings:self.settings];
    return v;
}

@end
