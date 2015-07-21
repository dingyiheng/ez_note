//
//  ViewController.m
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//

#import "ViewController.h"

#import "AudioView.h"
#import "AudioFactory.h"


#import "EZImageViewFactory.h"
#import "EZImageScrollViewController.h"

#import "TextViewFactory.h"
#import "EZTextView.h"

#import "ToolBarView.h"

@interface ViewController (){
    
    ToolBarView *toolbar;
    EZTextView *currentTextView;
    EZTextView *bottomTextView;
    
    AudioView *currentAudioView;
    AudioFactory *audioFactory;
    
    EZImageViewFactory *imageFactory;
    
    
    TextViewFactory *textViewFactory;
    float scrollViewHeight;
    float scrollViewWidth;
    float screenWidth;
    float screenHeight;
    
    BOOL isRecording;
}

@end

@implementation ViewController


- (NSMutableArray *)myViews{
    if(!_myViews)
        _myViews = [[NSMutableArray alloc] init];
    return _myViews;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.pagingEnabled = NO;
    
    scrollViewHeight = self.view.frame.size.height;
    scrollViewWidth = self.view.frame.size.width;
    
    
    toolbar = [[ToolBarView alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth, 40)];
    
    textViewFactory = [[TextViewFactory alloc] init];
    textViewFactory.frameSize = CGSizeMake(scrollViewWidth, scrollViewHeight-100);
    textViewFactory.bottomBlankHeight = scrollViewHeight-100;
    
    
    audioFactory = [[AudioFactory alloc] init];
    
    imageFactory = [[EZImageViewFactory alloc] init];
    
    
    isRecording = NO;
    
    
    [self getFirstTextView];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardButtonTouched:) name:@"keyboardButtonTouched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageButtonTouched:) name:@"imageButtonTouched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioButtonTouched:) name:@"audioButtonTouched" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewHeightChanged:) name:@"textViewHeightChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewFocused:) name:@"textViewFocused" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewTouched:) name:@"imageViewTouched" object:nil];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)resizeContent{
    CGSize size = CGSizeMake(scrollViewWidth, [self getContentHeight]);
    self.scrollView.contentSize = size;
    NSLog(@"%f",self.scrollView.contentSize.height);
}

- (float)getContentHeight {
    float totalHeight = 0;
    for(UIView *v in self.myViews){
        totalHeight += v.frame.size.height;
    }
    return totalHeight;
}



-(void)getFirstTextView{
    EZTextView *v = [textViewFactory createTextView];
    NSLog(@"%@", [v class]);
    NSLog(@"%@",v);
    [self.myViews addObject:v];
    
    v.inputAccessoryView = toolbar;
    v.isBottomTextView = YES;
    currentTextView = v;
    bottomTextView = v;
    [self.scrollView addSubview: v];
    [self resizeContent];
    
}




-(void)splitTextView:(EZTextView *)v{
    
    NSMutableAttributedString *beforeAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString: v.attributedText];
    NSMutableAttributedString *afterAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString: v.attributedText];
    
    NSLog(@"length: %lu", afterAttributedString.length);
    
   
    
    long beforeStringEndAt = v.selectedRange.location;
    long afterStringStartAt = v.selectedRange.location+v.selectedRange.length;
    long stringLength = v.text.length;
    
    NSLog(@"text length: %lu", stringLength);
    
    [beforeAttributedString replaceCharactersInRange: NSMakeRange(afterStringStartAt, stringLength-afterStringStartAt) withString:@""];
    [afterAttributedString replaceCharactersInRange: NSMakeRange(0, beforeStringEndAt) withString:@""];
    
    
    
//    NSString *remainingStr = [v.text substringFromIndex: v.selectedRange.location+v.selectedRange.length];
//    NSString *topString =[v.text substringToIndex: v.selectedRange.location];
//    NSLog(@"topStr: %@", topString);
//    v.text = topString;
    v.attributedText = beforeAttributedString;
    
    
    
    CGFloat fixedWidth = v.frame.size.width;
    CGSize newSize = [v sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = v.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    v.contentSize = newSize;
    
    
    //    float oH = v.frame.size.height;
    //    CGRect frame;
    //    frame = v.frame;
    //    frame.size.height = v.contentSize.height;
    //    NSLog(@"contentHeight: %f",v.contentSize.height);
    v.frame = newFrame;
    v.isBottomTextView = NO;
    
    EZTextView *v2 = [textViewFactory createTextView];
    [self.myViews addObject:v2];
    [self.scrollView addSubview:v2];
    if ([v.text hasPrefix:@"\n"]){
        v.text = [v.text substringFromIndex:1];
    }
//    v2.text = remainingStr;
    v2.attributedText = afterAttributedString;
    
    
    CGFloat fixedWidth2 = v2.frame.size.width;
    CGSize newSize2 = [v2 sizeThatFits:CGSizeMake(fixedWidth2, MAXFLOAT)];
    CGRect newFrame2 = v2.frame;
    newFrame2.size = CGSizeMake(fmaxf(newSize2.width, fixedWidth2), newSize2.height);
    
    v2.contentSize = newSize;
    
    
    NSLog(@"v2:offset:%f", v.frame.origin.y+v.frame.size.height);
    v2.frame = CGRectMake(0,v.frame.origin.y+v.frame.size.height, fixedWidth2, newSize2.height);
    NSLog(@"v2 height:%f", v2.contentSize.height);
    if(v2 == [self getBottomView]){
        //        bottomTextView.isBottomTextView = NO;
        //        v2.isBottomTextView = YES;
        //        bottomTextView = v2;
        v2.frame = CGRectMake(0,v2.frame.origin.y, v2.frame.size.width, v2.frame.size.height+textViewFactory.bottomBlankHeight);
    }
    [self resetBottonView];
    v2.inputAccessoryView = toolbar;
    [v2 becomeFirstResponder];
    v2.selectedRange = NSMakeRange(0, 0);
    [self moveDownViews:v2.frame.origin.y+v2.frame.size.height dis:v2.frame.size.height];
    
    
//    NSLog(@"WTF:%@", bottomTextView);
    
    
    //    float nH = currentTextView.frame.size.height;
    //    CGPoint p1 = CGPointMake(0, currentTextView.frame.origin.y+currentTextView.frame.size.height);
    //    currentContentHeight -= oH-nH;
    //    [self moveDownViews:currentTextView.frame.origin.y dis:oH-nH];
    //    UIImageView *iv = [self addImageViewAndReturnAt:p1];
    //    CGPoint p2 = CGPointMake(0, iv.frame.origin.y+iv.frame.size.height);
    //    UITextView *tv = [self addTextViewAndReturnAt:p2];
    //    tv.text = remainingStr;
    //
    //    [tv becomeFirstResponder];
    //    tv.selectedRange = NSMakeRange(0, 0);
    //    CGPoint p3 = CGPointMake(0, iv.frame.origin.y+iv.frame.size.height-30);
    //    self.scrollView.contentOffset = p3;
    
    
    
    
}

-(void)insertViewAtOffset:(UIView *)view offset:(float)offset{
    [self moveDownViews:offset dis:view.frame.size.height];
}

//- (void)moveUpViews:(float)oY dis:(float)dis{
//    for(UIView *v in self.myViews){
//        float originY = v.frame.origin.y;
//        if (originY>oY){
//            v.center = CGPointMake(v.center.x, v.center.y-dis);
//        }
//    }
//}

- (void)moveDownViews:(float)oY dis:(float)dis{
    NSLog(@"offset: %f",oY);
    for(UIView *v in self.myViews){
        float originY = v.frame.origin.y;
        NSLog(@"view offset: %f",originY);
        if (originY>=oY){
            v.center = CGPointMake(v.center.x, v.center.y+dis);
        }
    }
}


-(void)showViewInfo{
    unsigned index=0;
    for(UIView *v in self.myViews){
        NSLog(@"%u: %@",index, v);
        index++;
    }
}


-(UIView *)getBottomView{
    float maxOffset = 0;
    UIView *bottomView;
    for(UIView *v in self.myViews){
        if (v.frame.origin.y > maxOffset){
            bottomView = v;
        }else{
        }
    }
    if([bottomView isKindOfClass: [EZTextView class]]){
        bottomTextView = (EZTextView *)bottomView;
    }
    return bottomView;
}


-(void)resetBottonView{
    float maxOffset = 0;
    EZTextView *botView;
    for(UIView *v in self.myViews){
        if([v isKindOfClass: [EZTextView class]]){
            EZTextView *tv = (EZTextView *)v;
            tv.isBottomTextView = NO;
            if (v.frame.origin.y > maxOffset){
                botView = tv;
                maxOffset = tv.frame.origin.y;
            }else{
            }
        }
    }
    botView.isBottomTextView = YES;
    bottomTextView = botView;
}

-(void)scrollAfterInsert:(float)offset{
    NSLog(@"offset:%f",offset);
    float spaceToBottom = 100;
    float inset = self.scrollView.contentInset.top;
    float contentOffset = self.scrollView.contentOffset.y;

    if(offset > scrollViewHeight + contentOffset - inset - spaceToBottom){
//    if(1){
        float scrollTo = offset -scrollViewHeight + inset + spaceToBottom; //offset - scrollViewHeight;
        NSLog(@"scrollViewHeight:%f",scrollViewHeight);
        CGPoint scrollToPoint = CGPointMake(0, scrollTo);
//        [self.scrollView setContentOffset:scrollToPoint animated:YES];
        [UIView animateWithDuration:.5 animations:^{
            self.scrollView.contentOffset = scrollToPoint;
        }];
    }else{
        NSLog(@"Not scroll");
    }
}


//  ---------- Notification Handlers ------------------

-(void)imageButtonTouched:(NSNotification*)notification {
    unsigned rand = arc4random_uniform(3);
    
    
    
    NSString *imageName = [NSString stringWithFormat:@"test%u",rand+1];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    
//    UIView *imageView = [imageFactory createEZImageViewWithURL:nil];
    
    
    
    EZTextView *curV = currentTextView;
    [self splitTextView: curV];
    float insertOffset = curV.frame.size.height+curV.frame.origin.y;
    imageView.frame = CGRectMake(0, insertOffset, 300, 200);
    NSLog(@"insertOffset: %f", insertOffset);
    //    imageView.center = CGPointMake(scrollViewWidth/2, insertOffset);
    CGPoint newCenter = imageView.center;
    newCenter.x = scrollViewWidth/2;
    imageView.center = newCenter;
    [self moveDownViews:insertOffset dis:imageView.frame.size.height];
    [self.myViews addObject:imageView];
    [self.scrollView addSubview:imageView];
    [self resizeContent];
    
    
    [self scrollAfterInsert: imageView.frame.origin.y+imageView.frame.size.height];
//    CGPoint p3 = CGPointMake(0, imageView.frame.origin.y+imageView.frame.size.height-100);
    
    //    self.scrollView.contentOffset = p3;
    
    //    NSLog(@"count: %lu", (unsigned long)[self.myViews count]);
    //    [self showViewInfo];
}



-(void)keyboardButtonTouched:(NSNotification*)notification {
    [currentTextView resignFirstResponder];
}


-(void)audioButtonTouched:(NSNotification*)notification {
    
    
    //    unsigned rand = arc4random_uniform(3);
    //    NSString *imageName = [NSString stringWithFormat:@"test%u",rand+1];
    //    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    
    
    if(!isRecording){
        AudioView *av = [audioFactory createViewWithSettings];
        
        EZTextView *curV = currentTextView;
        [self splitTextView: curV];
        float insertOffset = curV.frame.size.height+curV.frame.origin.y;
        av.frame = CGRectMake(0, insertOffset, av.frame.size.width, av.frame.size.height);
        //NSLog(@"insertOffset: %f", insertOffset);
        //    imageView.center = CGPointMake(scrollViewWidth/2, insertOffset);
        CGPoint newCenter = av.center;
        newCenter.x = scrollViewWidth/2;
        av.center = newCenter;
        [self moveDownViews:insertOffset dis:av.frame.size.height];
        [self.myViews addObject:av];
        [self.scrollView addSubview:av];
        [self resizeContent];
        
        [self scrollAfterInsert: av.frame.origin.y+av.frame.size.height];
        
        [av startRecording];
        currentAudioView = av;
        [toolbar showRecording];
        isRecording = YES;
    }else{
        [currentAudioView stopRecording];
        [toolbar finishRecording];
        isRecording = NO;
    }
    
    //
    //
    //    AudioView *av = [audioFactory createViewWithSettings];
    //    av.center = CGPointMake(100, 200);
    //    self insertViewAtOffset:currentTextView offset:<#(float)#>
    //    [self.scrollView addSubview:av];
    //
    //    [av startRecording];
}


-(void)imageViewTouched:(NSNotification*)notification {
    UIImage *img = notification.userInfo[@"img"];
    EZImageScrollViewController *vc = [[EZImageScrollViewController alloc] initWithImage:img];
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)textViewHeightChanged:(NSNotification*)notification {
    NSLog(@"co off%f", self.scrollView.contentOffset.y);
    [self resizeContent];
    NSNumber *deltaHeight = notification.userInfo[@"deltaHeight"];
    //    NSLog(@"%f", [deltaHeight floatValue]);
    float offset = currentTextView.frame.origin.y+currentTextView.frame.size.height;
    float dis = [deltaHeight floatValue];
    [self moveDownViews:offset-dis dis:dis];
}

-(void)textViewFocused:(NSNotification*)notification {
    currentTextView = notification.object;
}



//
//-(void)textViewHeightChanged:(NSNotification*)notification {
//    [self resizeContent];
//}





// =============== Event Handler ==================

- (IBAction)clearButtonTouched:(id)sender {
    NSLog(@"Clear Button Touched");
    self.myViews = nil;
    [self getFirstTextView];
//    float inset = self.scrollView.contentInset.top;
//    float offset = self.scrollView.contentOffset.y;
//    float frame = self.scrollView.frame.origin.y;
//    float bound = self.scrollView.bounds.origin.y;
//    NSLog(@"Inset: %f Offset:%f frame:%f bound:%f", inset, offset, frame, bound);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
