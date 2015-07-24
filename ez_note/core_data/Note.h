//
//  Note.h
//  ez_note
//
//  Created by Fred Wu on 7/23/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notebook, Tag;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSSet *tag;
@property (nonatomic, retain) Notebook *notebook;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addTagObject:(Tag *)value;
- (void)removeTagObject:(Tag *)value;
- (void)addTag:(NSSet *)values;
- (void)removeTag:(NSSet *)values;

@end
