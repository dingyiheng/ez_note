//
//  AudioView.m
//  try_20150719_audioView
//
//  Created by Yiheng Ding on 7/19/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import "AudioView.h"

@implementation AudioView{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    float recordTimeLimit;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//

- (UIView *)viewFromNib{
    Class class = [self class];
    NSString *nibName = NSStringFromClass(class);
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    UIView *view = [nibViews objectAtIndex:0];
    return view;
}

- (void) addsubviewFromNib
{
    UIView *view = [self viewFromNib];
    view.frame = self.bounds;
    //NSLog(@"%f %f %f %f",self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height);
    
    [self addSubview:view];
}

- (instancetype)initWithFactorySettings:(NSDictionary *)settings{
    self = [super initWithFrame: CGRectMake(0, 0, [settings[@"width"] floatValue], [settings[@"height"] floatValue])];
    
    if(self){
        [self addsubviewFromNib];
        [self.AudioButton setTitle:settings[@"title"] forState:UIControlStateNormal];
        self.AudioLabel.text = @"";
        recordTimeLimit = [settings[@"timeLimit"] floatValue];
        
        
        //this background color is not subview's background color, don't mess up
        self.backgroundColor = settings[@"backgroundColor"];
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:settings[@"outputFileURL"] settings:settings[@"recordSetting"] error:nil];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
        
    }
    return self;
}

- (IBAction)buttonPressed:(id)sender {
    if (recorder.recording) {
        [self stopRecording];
    }
    else{
        if (player.playing) {
            NSLog(@"playing!!");
            [self stopPlaying];
        }
        else{
            [self startPlaying];
        }
    }
}


- (void) timerResponse{
    if (recorder.recording) {
        if (recorder.currentTime < recordTimeLimit) {
            self.AudioLabel.text = [[NSString stringWithFormat:@"%.0f",recorder.currentTime] stringByAppendingString:@"s"];
        }
        else{
            [self stopRecording];
        }
        
    }
    else if (player.playing){
        self.AudioLabel.text = [[NSString stringWithFormat:@"%.0f",player.currentTime] stringByAppendingString:@"s"];
    }
}

- (void) startRecording{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    [recorder record];
    [self.AudioButton setTitle:@"Recording" forState:UIControlStateNormal];
    
    // set a timer
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerResponse) userInfo:nil repeats:YES];
    
    // notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startRecording" object:self userInfo:nil];
}

- (void) stopRecording{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    
    [recorder stop];
    [self.AudioButton setTitle:@"Play" forState:UIControlStateNormal];
    self.AudioLabel.text = @"";
    
    // notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRecording" object:self userInfo:nil];
}

- (void) startPlaying{
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        [self.AudioButton setTitle:@"Playing" forState:UIControlStateNormal];
        
        //nitification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startPlaying" object:self userInfo:nil];
    }
}

- (void) stopPlaying{
    [player stop];
    [self.AudioButton setTitle:@"Play" forState:UIControlStateNormal];
    self.AudioLabel.text = @"";
    
    // nitification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlaying" object:self userInfo:nil];
}


- (void) pauseRecording{
    [recorder pause];
    [self.AudioButton setTitle:@"Pause" forState:UIControlStateNormal];
    
    // nitification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseRecording" object:self userInfo:nil];
}

- (void) resumeRecording{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [recorder record];
    [self.AudioButton setTitle:@"Recording" forState:UIControlStateNormal];
    
    // notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeRecording" object:self userInfo:nil];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlaying];
    
    // notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlaying" object:self userInfo:nil];
}

@end
