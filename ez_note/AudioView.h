//
//  AudioView.h
//  try_20150719_audioView
//
//  Created by Yiheng Ding on 7/19/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioView : UIView<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *AudioButton;
@property (weak, nonatomic) IBOutlet UILabel *AudioLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

- (void) addsubviewFromNib;
- (UIView *) viewFromNib;
- (instancetype)initWithFactorySettings:(NSDictionary *)settings;

- (void) startRecording;
- (void) stopRecording;
- (void) startPlaying;
- (void) stopPlaying;
- (void) pauseRecording;
- (void) resumeRecording;

- (void) timerResponse;
- (void) updateSlierTime;

@end
