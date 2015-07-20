//
//  EZImageViewFactory.h
//  EmptyApplication
//
//  Created by Ren Wan on 7/18/15.
//  Copyright (c) 2015 StudentName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZImageView.h"
#import "EZOptions.h"

@interface EZImageViewFactory : NSObject

@property EZOptions* options;

//- (EZImageView *) createEZImageView;
- (EZImageView *) createEZImageViewWithURL:(NSURL *)url;

@end
