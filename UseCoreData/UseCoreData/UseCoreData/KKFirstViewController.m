//
//  KKFirstViewController.m
//  UseCoreData
//
//  Created by zhaokai on 14-7-6.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKFirstViewController.h"
#import "KKCoreDataTestController.h"

@interface KKFirstViewController ()

@end

@implementation KKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"CoreData" forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
    button.frame = CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), 100, 50);
    [button addTarget:self action:@selector(openCoreDataController) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    
    [self.view addSubview:button];
}

-(void)openCoreDataController
{
    KKCoreDataTestController* control = [[KKCoreDataTestController alloc]init];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:control];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
