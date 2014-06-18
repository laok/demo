//
//  ZonePopMenu.h
//  popmenu
//
//  Created by zhaokai on 14-6-17.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZonePopMenuItemSelectedBlock)(void);

@protocol ZonePopMenuDelegate <NSObject>

@required
-(void)closeMenu;

@end
@interface ZonePopMenu : UIView

@property (nonatomic,weak) id <ZonePopMenuDelegate> delegate;
+(UIImage*)createBgImage:(UIView*)view;

- (void)addMenuItemWithTitle:(NSString*)title
                  titleColor:(UIColor*)color
                      normal:(UIImage*)normalImage
                 highlighted:(UIImage*)highlightedImage
               selectedBlock:(ZonePopMenuItemSelectedBlock)block;

- (void)showMenu:(UIImage*)backgoundImage;//backgourndImage 为nil,用默认灰色背景
- (void)showMenu:(UIImage *)backgoundImage inView:(UIView*)view;
@end
