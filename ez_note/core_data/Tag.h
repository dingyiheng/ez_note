//
//  Tag.h
//  ez_note
//
//  Created by Fred Wu on 7/27/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *note;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addNoteObject:(Note *)value;
- (void)removeNoteObject:(Note *)value;
- (void)addNote:(NSSet *)values;
- (void)removeNote:(NSSet *)values;

@end
