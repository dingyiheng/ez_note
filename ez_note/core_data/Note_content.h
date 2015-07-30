//
//  Note_content.h
//  ez_note
//
//  Created by Fred Wu on 7/28/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Note_content : NSManagedObject

@property (nonatomic, retain) id content;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) Note *note;

@end
