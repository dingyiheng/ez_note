//
//  ViewController.m
//  EZNote
//
//  Created by Fred Wu on 7/19/15.
//  Copyright (c) 2015 Fred. All rights reserved.
//


#import "AppDelegate.h"
#import "ViewController.h"

#import "AudioView.h"
#import "AudioFactory.h"


#import "EZImageViewFactory.h"
#import "EZImageScrollViewController.h"

#import "TextViewFactory.h"
#import "EZTextView.h"

#import "ToolBarView.h"

#import "Note.h"

@interface ViewController (){
    
    ToolBarView *toolbar;
    EZTextView *currentTextView;
    EZTextView *bottomTextView;
    
    AudioView *currentAudioView;
    AudioFactory *audioFactory;
    
    EZImageViewFactory *imageFactory;
    
    UIImagePickerController *imagePicker;
    
    
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



-(void)loadViewsFromJSON:(NSData *)json{
    NSLog(@"Load data from json");
    NSData *data=[NSData dataWithData:json];
    NSError *error=nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"array: %@", array);
    NSLog(@"views count: %lu", [array count]);
    
    float offset = 0;
    
    for(NSDictionary *d in array){
        NSString *classStr = d[@"class"];
        if ([classStr  isEqualToString: @"EZTextView"]){
            EZTextView *v = (EZTextView *)[textViewFactory createTextView];
            v.textView.text = d[@"content"];
            CGRect frame =  CGRectMake(0, offset, [d[@"width"] floatValue], [d[@"height"] floatValue]);
            v.frame = frame;
            offset += [d[@"height"] floatValue];
            [self.scrollView addSubview: v];
            [self.myViews addObject:v];
        }else if ([classStr  isEqualToString: @"EZImageView"]){
            
        }else if ([classStr  isEqualToString: @"AudioView"]){
            
        }
    }
    
    
    [self showViewInfo];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if(self.isNewDocument){
        NSLog(@"New Document");
    }
    
    
    NSLog(@"Context: %@", self.managedObjectContext);
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraButtonTouched:) name:@"cameraButtonTouched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageButtonTouched:) name:@"imageButtonTouched" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioButtonTouched:) name:@"audioButtonTouched" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewHeightChanged:) name:@"textViewHeightChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewFocused:) name:@"textViewFocused" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewTouched:) name:@"imageViewTouched" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTaped:) name:@"imageTaped" object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    
    
}



-(void)resizeContent{
    CGSize size = CGSizeMake(scrollViewWidth, [self getContentHeight]);
    self.scrollView.contentSize = size;
    NSLog(@"Resize to %f",self.scrollView.contentSize.height);
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
    
    v.textView.inputAccessoryView = toolbar;
    v.isBottomTextView = YES;
    currentTextView = v;
    bottomTextView = v;
    [self.scrollView addSubview: v];
    [self resizeContent];
    
}




-(void)splitTextView:(EZTextView *)v{
    
    NSMutableAttributedString *beforeAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString: v.textView.attributedText];
    NSMutableAttributedString *afterAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString: v.textView.attributedText];
    
//    NSLog(@"length: %lu", afterAttributedString.length);
    
   
    
    long beforeStringEndAt = v.textView.selectedRange.location;
    long afterStringStartAt = v.textView.selectedRange.location+v.textView.selectedRange.length;
    long stringLength = v.textView.text.length;
    
    NSLog(@"text length: %lu", stringLength);
    
    [beforeAttributedString replaceCharactersInRange: NSMakeRange(afterStringStartAt, stringLength-afterStringStartAt) withString:@""];
    [afterAttributedString replaceCharactersInRange: NSMakeRange(0, beforeStringEndAt) withString:@""];
    
    
    
//    NSString *remainingStr = [v.text substringFromIndex: v.selectedRange.location+v.selectedRange.length];
//    NSString *topString =[v.text substringToIndex: v.selectedRange.location];
//    NSLog(@"topStr: %@", topString);
//    v.text = topString;
    v.textView.attributedText = beforeAttributedString;
    
    
    
    CGFloat fixedWidth = v.frame.size.width;
    CGSize newSize = [v.textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = v.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    v.textView.contentSize = newSize;
    
    
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
    if ([v.textView.text hasPrefix:@"\n"]){
        v.textView.text = [v.textView.text substringFromIndex:1];
    }
//    v2.text = remainingStr;
    v2.textView.attributedText = afterAttributedString;
    
    
    CGFloat fixedWidth2 = v2.frame.size.width;
    CGSize newSize2 = [v2.textView sizeThatFits:CGSizeMake(fixedWidth2, MAXFLOAT)];
    CGRect newFrame2 = v2.frame;
    newFrame2.size = CGSizeMake(fmaxf(newSize2.width, fixedWidth2), newSize2.height);
    
    v2.textView.contentSize = newSize;
    
    
    NSLog(@"v2:offset:%f", v.frame.origin.y+v.frame.size.height);
    v2.frame = CGRectMake(0,v.frame.origin.y+v.frame.size.height, fixedWidth2, newSize2.height);
    NSLog(@"v2 height:%f", v2.textView.contentSize.height);
    
    
    //check if the second part of the splitted textview is the bottom view, if true, set extra blank for it
    if(v2 == [self getBottomView]){
        
        NSLog(@"new text view is bottom view");
        //        bottomTextView.isBottomTextView = NO;
        //        v2.isBottomTextView = YES;
        //        bottomTextView = v2;
        v2.frame = CGRectMake(0,v2.frame.origin.y, v2.frame.size.width, v2.frame.size.height+textViewFactory.bottomBlankHeight);
    }
    [self resetBottonView];
    v2.textView.inputAccessoryView = toolbar;
    [v2 becomeFirstResponder];
    v2.textView.selectedRange = NSMakeRange(0, 0);
    
    
    float moveDownDis = v2.frame.size.height;
    NSLog(@"insert: move down %f", moveDownDis);
    [self moveDownViewsExcept:v2.frame.origin.y dis:moveDownDis except:v2];
    
    
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
//    NSLog(@"offset: %f",oY);
    for(UIView *v in self.myViews){
        float originY = v.frame.origin.y;
//        NSLog(@"view offset: %f",originY);
        if (originY>=oY){
            v.center = CGPointMake(v.center.x, v.center.y+dis);
        }
    }
}

- (void)moveDownViewsExcept:(float)oY dis:(float)dis except:(UIView *)exV{
    for(UIView *v in self.myViews){
        if(v == exV){
            continue;
        }
        float originY = v.frame.origin.y;
        if (originY>=oY){
            v.center = CGPointMake(v.center.x, v.center.y+dis);
        }
    }
}



-(void)showViewInfo{
    NSLog(@"Show View Info:");
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
            maxOffset = v.frame.origin.y;
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



-(NSArray *)sortViews{
    id sortByPosition = ^(UIView * v1, UIView * v2){
        return v1.frame.origin.y >= v2.frame.origin.y;
    };
    
    NSArray * sortedMyViews = [self.myViews sortedArrayUsingComparator:sortByPosition];
    
    NSLog(@"%@",sortedMyViews);
    return sortedMyViews;
    
}


-(NSArray *)viewToDictArray: (NSArray *)views{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity: [views count]];
    for(EZView *v in self.myViews){
        NSMutableDictionary *tempDict= [[NSMutableDictionary alloc]init];
        [tempDict setObject: NSStringFromClass([v class]) forKey:@"class"];
        [tempDict setObject:[NSNumber numberWithFloat:v.frame.size.height] forKey:@"height"];
        [tempDict setObject:[NSNumber numberWithFloat:v.frame.size.width] forKey:@"width"];
        [tempDict setObject:[v getOutput] forKey:@"content"];
        [array addObject:tempDict];
    }

    
    for(NSDictionary *d in array){
        NSLog(@"%@",d);
    }
    
    return array;
}


-(void)getOutput{
    NSArray *sortedViews = [self sortViews];
//    [self viewToDict:sortedViews];
}

-(void)saveNote{
    Note *note = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    note.title = @"TestTitle";
    NSArray *array = [self viewToDictArray:[self sortViews]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"json: %@", jsonString);
    note.content = jsonData;
    note.create_time = [NSDate date];
    note.tag = [[NSSet alloc]init];
    if([context save: &error]){
        NSLog(@"Saved");
    }else{
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}


- (void)addImage:(UIImage *)img{
    UIView *imageView = [imageFactory createEZImageView:img];
    
    
    
    EZTextView *curV = currentTextView;
    [self splitTextView: curV];
    float insertOffset = curV.frame.size.height+curV.frame.origin.y;
    imageView.frame = CGRectMake(0, insertOffset, imageView.frame.size.width, imageView.frame.size.height);
    CGPoint newCenter = imageView.center;
    newCenter.x = scrollViewWidth/2;
    imageView.center = newCenter;
    float moveDownDis = imageView.frame.size.height;
    NSLog(@"move down %f", moveDownDis);
    [self moveDownViews:insertOffset dis:moveDownDis];
    [self.myViews addObject:imageView];
    [self.scrollView addSubview:imageView];
    [self resizeContent];
    [self scrollAfterInsert: imageView.frame.origin.y+imageView.frame.size.height];
    [self showViewInfo];
}


//  ---------- Notification Handlers ------------------

-(void)imageButtonTouched:(NSNotification*)notification {
    
    
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
    
    
    
    /*
    unsigned rand = arc4random_uniform(3);
    NSString *imageName = [NSString stringWithFormat:@"test%u",rand+1];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    
//    UIView *imageView = [imageFactory createEZImageViewWithURL:nil];
    
    
    
    EZTextView *curV = currentTextView;
    [self splitTextView: curV];
    float insertOffset = curV.frame.size.height+curV.frame.origin.y;
    imageView.frame = CGRectMake(0, insertOffset, 300, 200);
//    NSLog(@"insertOffset: %f", insertOffset);
    //    imageView.center = CGPointMake(scrollViewWidth/2, insertOffset);
    CGPoint newCenter = imageView.center;
    newCenter.x = scrollViewWidth/2;
    imageView.center = newCenter;
    float moveDownDis = imageView.frame.size.height;
    NSLog(@"move down %f", moveDownDis);
    [self moveDownViews:insertOffset dis:moveDownDis];
    [self.myViews addObject:imageView];
    [self.scrollView addSubview:imageView];
    [self resizeContent];
    
    
    [self scrollAfterInsert: imageView.frame.origin.y+imageView.frame.size.height];
//    CGPoint p3 = CGPointMake(0, imageView.frame.origin.y+imageView.frame.size.height-100);
    
    //    self.scrollView.contentOffset = p3;
    
    //    NSLog(@"count: %lu", (unsigned long)[self.myViews count]);
        [self showViewInfo];
     */
}



-(void)keyboardButtonTouched:(NSNotification*)notification {
    [currentTextView.textView resignFirstResponder];
}


-(void)cameraButtonTouched:(NSNotification*)notification {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
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

-(void)imageTaped:(NSNotification*)notification {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)textViewHeightChanged:(NSNotification*)notification {
    NSLog(@"Text View Height Changed");
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
    NSLog(@"Current is:%@", currentTextView);
//    NSArray * exclude = [NSArray arrayWithObjects:@"doctype",
//                         @"html",
//                         @"head",
//                         @"body",
//                         @"xml",
//                         nil
//                         ];
    
    
//    NSDictionary * htmlAtt = [NSDictionary dictionaryWithObjectsAndKeys: NSHTMLTextDocumentType, NSDocumentTypeDocumentAttribute, nil];
//    NSError * error;
//    NSData * htmlData = [currentTextView.attributedText dataFromRange:NSMakeRange(0, [currentTextView.attributedText length])
//                               documentAttributes:htmlAtt error:&error
//                         ];
//    NSString * htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",htmlString);
}



-(void)keyboardWasShown:(NSNotification*)notification{
    
    NSDictionary* info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"Keyboard was shown");
    CGPoint cursorPosition = [currentTextView.textView caretRectForPosition:currentTextView.textView.selectedTextRange.start].origin;
    NSLog(@"cursor position: %f %f", cursorPosition.x, cursorPosition.y);
    float currentViewOffset = currentTextView.frame.origin.y;
    NSLog(@"current view offset:%f", currentViewOffset);
    NSLog(@"scroll view offset:%f", self.scrollView.contentOffset.y);
    NSLog(@"keyboard size: %f", kbSize.height);
    NSLog(@"scroll view size: %f", scrollViewHeight);
    NSLog(@"%f",self.scrollView.contentOffset.y - currentViewOffset + cursorPosition.y + kbSize.height);
    if( currentViewOffset - self.scrollView.contentOffset.y + cursorPosition.y + kbSize.height > scrollViewHeight){
        float scrollTo = self.scrollView.contentOffset.y + kbSize.height;
        CGPoint scrollToPoint = CGPointMake(0, scrollTo);
        [UIView animateWithDuration:.3 animations:^{
            self.scrollView.contentOffset = scrollToPoint;
        }];
    }
//    if ( self.scrollView.contentOffset.ycurrentViewOffset+)
//    [self.scrollView scrollRectToVisible:currentTextView.textView.frame animated:YES];

}


-(void)keyboardWillBeHidden:(NSNotification*)notification{
    NSLog(@"Keyboard will be hidden");
}






// -------------- Delegates ---------------------



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * img = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self addImage:img];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}







// =============== Event Handler ==================

- (IBAction)clearButtonTouched:(id)sender {
    NSLog(@"Clear Button Touched");
    [self showViewInfo];
    
    [self saveNote];
    
    
//    NSLog(@"------------------");
//    [self getOutput];
//    NSLog(@"%@", currentTextView);
    
//    self.myViews = nil;
//    [self getFirstTextView];
//    
//    [self sortViews];
//    

//    float inset = self.scrollView.contentInset.top;
//    float offset = self.scrollView.contentOffset.y;
//    float frame = self.scrollView.frame.origin.y;
//    float bound = self.scrollView.bounds.origin.y;
//    NSLog(@"Inset: %f Offset:%f frame:%f bound:%f", inset, offset, frame, bound);
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
