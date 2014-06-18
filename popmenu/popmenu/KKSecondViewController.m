//
//  KKSecondViewController.m
//  popmenu
//
//  Created by zhaokai on 14-6-17.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKSecondViewController.h"
#import "ZoneSendTypeSelectViewController.h"
@interface KKSecondViewController ()

@end

@implementation KKSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView* bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image=[UIImage imageNamed:@"temp"];
    [self.view addSubview:bgImageView];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIButton* openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openButton.frame = CGRectMake(200, 200, 60, 60);
    [openButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton];
    [openButton setTitle:@"打开" forState:UIControlStateNormal];
    openButton.backgroundColor = [UIColor blackColor];
}

-(void)openMenu:(id)sender
{
    ZoneSendTypeSelectViewController *selectViewController = [[ZoneSendTypeSelectViewController alloc]initWithBgImage:[ZonePopMenu createBgImage:self.view]];
#if 1
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectViewController];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:NO completion:nil];
#else
    UIViewController *sourceViewController = self;//selectViewController;//self.sourceViewController;
    UIViewController *destinationViewController = selectViewController;//self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    // Transformation start scale
    destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    // Store original centre point of the destination view
    CGPoint originalCenter = destinationViewController.view.center;
    // Set center to start point of the button
//    destinationViewController.view.center = self.originatingPoint;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow!
                         destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         destinationViewController.view.center = originalCenter;
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC
                     }];
#endif
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
