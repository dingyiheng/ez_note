//
//  EZImageViewFactory.m
//  EmptyApplication
//
//  Created by Ren Wan on 7/18/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import "EZImageViewFactory.h"

@implementation EZImageViewFactory

- (id) initWithOptions:(EZOptions*) opt
{
    self = [super init];
    if(self) {
        self.options = opt;
    }
    return self;
}

- (EZImageView *) createEZImageView
{
    return [[EZImageView alloc] initWithImage:nil Image:[UIImage imageNamed:@"FOB_small.png"]];
}


@end
