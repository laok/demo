//
//  KKTableViewCell.h
//  tableViewDemo
//
//  Created by kk on 14-3-21.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tlImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end
