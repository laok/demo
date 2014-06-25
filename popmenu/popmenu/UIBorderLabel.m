//
//  UIBorderLabel.m
//  popmenu
//
//  Created by zhaokai on 14-6-19.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "UIBorderLabel.h"

@implementation UIBorderLabel

- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets)];
}
@end
