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


- (EZImageView *) createEZImageView:(UIImage *)img{
    return [[EZImageView alloc] initWithImage:nil Image:img];
}



- (EZImageView *) createEZImageViewWithURL:(NSURL *)url
{
    if(!url){
        return [[EZImageView alloc] initWithImage:nil Image:[UIImage imageNamed:@"test1"]];
    }else{
        NSData *data =[NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        return [[EZImageView alloc] initWithImage:nil Image:img];
    }
}


@end
