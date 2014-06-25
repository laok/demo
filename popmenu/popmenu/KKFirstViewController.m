//
//  KKFirstViewController.m
//  popmenu
//
//  Created by zhaokai on 14-6-17.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKFirstViewController.h"
#import "ZonePopMenu.h"
#import "UIBorderLabel.h"

@interface KKFirstViewController ()
- (IBAction)openMenu:(id)sender;

@end

@implementation KKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
#if 0
    UIImageView* bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image=[UIImage imageNamed:@"temp"];
    [self.view addSubview:bgImageView];
    
    UIButton* openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.frame = CGRectMake(200, 200, 60, 60);
    [openButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton];
    [openButton setTitle:@"open" forState:UIControlStateNormal];
    openButton.backgroundColor = [UIColor blackColor];
#else
    UIBorderLabel *myBorderLabel = [[UIBorderLabel alloc] initWithFrame:CGRectMake(0, 200, 320, 22)];
    [self.view addSubview:myBorderLabel];
    myBorderLabel.text=@"345";
    myBorderLabel.textAlignment = NSTextAlignmentRight;
    myBorderLabel.font =[UIFont systemFontOfSize:12.f];
    myBorderLabel.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.4];
    myBorderLabel.contentEdgeInsets =UIEdgeInsetsMake(5, 0, 5, 15);
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openMenu:(id)sender {
    ZonePopMenu* menu = [[ZonePopMenu alloc]initWithFrame:self.view.bounds];
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
    
    UIImage* bgImage = [ZonePopMenu createBgImage:self.view];
    [menu showMenu:bgImage];
}

-(void)backAction
{

}
@end
