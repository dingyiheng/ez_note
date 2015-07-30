//
//  NoteCell.h
//  ez_note
//
//  Created by Fred Wu on 7/29/15.
//  Copyright (c) 2015 Yiheng Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
