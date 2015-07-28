//
//  Note.h
//  ez_note
//
//  Created by Fred Wu on 7/27/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note_content, Notebook, Tag;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * html_content;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSString * text_content;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Notebook *notebook;
@property (nonatomic, retain) NSSet *tag;
@property (nonatomic, retain) NSSet *content;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addTagObject:(Tag *)value;
- (void)removeTagObject:(Tag *)value;
- (void)addTag:(NSSet *)values;
- (void)removeTag:(NSSet *)values;

- (void)addContentObject:(Note_content *)value;
- (void)removeContentObject:(Note_content *)value;
- (void)addContent:(NSSet *)values;
- (void)removeContent:(NSSet *)values;

@end
