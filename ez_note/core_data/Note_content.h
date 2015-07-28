//
//  Note_content.h
//  ez_note
//
//  Created by Fred Wu on 7/27/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Note_content : NSManagedObject

@property (nonatomic, retain) id content;
@property (nonatomic, retain) Note *note;

@end
