//
//  ZoneSendTypeSelectViewController.m
//  popmenu
//
//  Created by zhaokai on 14-6-18.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "ZoneSendTypeSelectViewController.h"
#import "ZonePopMenu.h"
@interface ZoneSendTypeSelectViewController ()<ZonePopMenuDelegate>
@property (nonatomic,strong)UIImage* bgImage;
@end

@implementation ZoneSendTypeSelectViewController

#pragma mark - delegate
-(void)closeMenu
{
    [self backAction];
}
#pragma mark - init
- (id)initWithBgImage:(UIImage*)image;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.bgImage = image;
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backAction
{
    if (self.navigationController && [self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.presentingViewController)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
//        self.parentViewController.view.alpha = 0.0;
//        [UIView animateWithDuration:1.25
//                         animations:^{self.parentViewController.view.alpha  = 1.0;}];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZonePopMenu* menu = [[ZonePopMenu alloc]initWithFrame:self.view.bounds];
    menu.delegate = self;
    menu.backgroundColor=[[UIColor redColor]colorWithAlphaComponent:0.4];
    NSInteger itemCount = random()%3+1;
    //    NSLog(@"%d",itemCount);
    //    [self.view addSubview:menu];
#if 0
    if (itemCount) {
        itemCount--;
        [menu addMenuItemWithTitle:@"QQ" titleColor:[UIColor redColor] andIcon:[UIImage imageNamed:@"qq_popover"] andSelectedBlock:^{
            NSLog(@"QQ click");
        }];
    }
    
    if (itemCount) {
        itemCount--;
        [menu addMenuItemWithTitle:@"人人" titleColor:[UIColor greenColor] andIcon:[UIImage imageNamed:@"renren_popover"] andSelectedBlock:^{
            NSLog(@"renren click");
        }];
    }
    
    if (itemCount) {
        itemCount--;
        [menu addMenuItemWithTitle:@"推特" titleColor:[UIColor blueColor] andIcon:[UIImage imageNamed:@"twitter_popover"] andSelectedBlock:^{
            NSLog(@"twitter");
        }];
    }
#else
    //ff5384
    [menu addMenuItemWithTitle:@"文字" titleColor:[UIColor colorWithRed:1 green:0.325 blue:0.518 alpha:1] /*#ff5384*/ normal:[UIImage imageNamed:@"textbutton_selecttype"] highlighted:[UIImage imageNamed:@"textbutton_selecttype_press"] selectedBlock:^{
        NSLog(@"文字");
    }];
    
    //ff7d6f
    [menu addMenuItemWithTitle:@"图文" titleColor:[UIColor colorWithRed:1 green:0.49 blue:0.435 alpha:1] /*#ff7d6f*/ normal:[UIImage imageNamed:@"picturebutton_selecttype"] highlighted:[UIImage imageNamed:@"picturebutton_selecttype_press"] selectedBlock:^{
        NSLog(@"图文");
    }];
    
    //43c0f6
    [menu addMenuItemWithTitle:@"视频" titleColor:[UIColor colorWithRed:0.263 green:0.753 blue:0.965 alpha:1] /*#43c0f6*/ normal:[UIImage imageNamed:@"videobutton_selecttype"] highlighted:[UIImage imageNamed:@"videobutton_selecttype_press"] selectedBlock:^{
        NSLog(@"视频");
    }];
    //
    //18c9b1
    [menu addMenuItemWithTitle:@"GIF" titleColor:[UIColor colorWithRed:0.094 green:0.788 blue:0.694 alpha:1] /*#18c9b1*/ normal:[UIImage imageNamed:@"gifbutton_selecttype"] highlighted:[UIImage imageNamed:@"gifbutton_selecttype_press"] selectedBlock:^{
        NSLog(@"GIF");
    }];
#endif
    
    UIImage* bgImage = self.bgImage;//[ZonePopMenu createBgImage:self.view];
//    [menu showMenu:bgImage];
    [menu showMenu:bgImage inView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
