//
//  KKTableViewCell.m
//  tableViewDemo
//
//  Created by kk on 14-3-21.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKTableViewCell.h"

@implementation KKTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
