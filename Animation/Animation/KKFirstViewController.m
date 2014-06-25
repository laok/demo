//
//  KKFirstViewController.m
//  Animation
//
//  Created by zhaokai on 14-6-25.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKFirstViewController.h"

@interface KKFirstViewController ()

@end

@implementation KKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton* digButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"digupicon_textpage"];
    [digButton setImage:image forState:UIControlStateNormal];
    [digButton setImage:[UIImage imageNamed:@"digupicon_textpage_press"] forState:UIControlStateHighlighted];
    [digButton addTarget:self action:@selector(digAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(self.view.center.x-40, self.view.center.y, image.size.width, image.size.height);
    digButton.frame = CGRectInset(frame, 0, 0);
    digButton.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
    
    [self.view addSubview:digButton];
    
    UIButton *buryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* buryImage = [UIImage imageNamed:@"digdownicon_textpage"];
    [buryButton setImage:buryImage forState:UIControlStateNormal];
    [buryButton setImage:[UIImage imageNamed:@"digdownicon_textpage_press"] forState:UIControlStateHighlighted];
    [buryButton addTarget:self action:@selector(buryAction:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = CGRectMake(self.view.center.x+40, self.view.center.y, image.size.width, image.size.height);
    buryButton.frame = CGRectInset(frame, 0, 0);
    buryButton.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:buryButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
-(void)buryAction:(id)sender
{
    UIButton *targetView = (UIButton*)sender;
    /*
     UIView *motionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"digupicon"]];
     motionView.center = CGPointMake(targetView.frame.size.width/2, targetView.frame.size.height/8);
     UIWindow * applicationWindow = [[[UIApplication sharedApplication] delegate] window];
     motionView.center = [applicationWindow convertPoint:motionView.center fromView:targetView];
     [applicationWindow addSubview:motionView];
     
     float storedAlpha = motionView.alpha;
     motionView.alpha = 1.f;
     motionView.transform = CGAffineTransformMakeScale(1.f, 1.f);
     
     [UIView animateWithDuration:0.5f animations:^{
     motionView.transform = CGAffineTransformMakeScale(1.5, 1.5);
     } completion:^(BOOL finished) {
     motionView.alpha = 0.f;
     
     [motionView removeFromSuperview];
     }];
     */
    double durationTime = 0.13;//0.13秒
    double stayTime = 0.13;//动画过程中暂时呆停时间
    double fadeTime = 0.52;//下滑消失动画
    CGPoint anchorPoint = CGPointMake(0, 0.66);//中心点 (32-11)/32 = 0.656=0.66
    CGFloat originheight = 30.f;
    CGFloat vibrationHeight = 4.f;
    double  angle = M_PI_4 *0.333;//15度
    
    UIImage * digImage = [UIImage imageNamed:@"digdownicon"];
    
    UIView *motionView = [[UIImageView alloc] initWithImage:digImage];
    motionView.center = CGPointMake(0, targetView.frame.size.height/8-originheight/2);
    UIWindow * applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    motionView.center = [applicationWindow convertPoint:motionView.center fromView:targetView];
    
    [applicationWindow addSubview:motionView];
    
    
    [UIView animateWithDuration:durationTime animations:^{
        CGAffineTransform t1 = CGAffineTransformMakeRotation(angle);
        CGAffineTransform t= CGAffineTransformMakeTranslation(0,vibrationHeight);
        motionView.layer.anchorPoint = anchorPoint;
        t = CGAffineTransformConcat(t, t1);
        motionView.transform = t;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:durationTime animations:^{
            CGAffineTransform t1 = CGAffineTransformIdentity;
            CGAffineTransform t= CGAffineTransformMakeTranslation(0,-vibrationHeight);
            motionView.layer.anchorPoint = anchorPoint;
            t = CGAffineTransformConcat(t, t1);
            motionView.transform = t;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:durationTime animations:^{
                CGAffineTransform t1 = CGAffineTransformMakeRotation(angle);
                CGAffineTransform t= CGAffineTransformMakeTranslation(0,vibrationHeight);
                motionView.layer.anchorPoint = anchorPoint;
                t = CGAffineTransformConcat(t, t1);
                motionView.transform = t;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:durationTime animations:^{
                    CGAffineTransform t1 = CGAffineTransformIdentity;
                    CGAffineTransform t= CGAffineTransformMakeTranslation(0,-vibrationHeight);
                    motionView.layer.anchorPoint = anchorPoint;
                    t = CGAffineTransformConcat(t, t1);
                    motionView.transform = t;
                    
                } completion:^(BOOL finished) {
                    CGRect endFrame = CGRectOffset(motionView.frame, 0, originheight);
                    [UIView animateWithDuration:fadeTime delay:stayTime options:0 animations:^{
                        motionView.frame = endFrame;
                        motionView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [motionView removeFromSuperview];
                    }];
                    
                }];
                
            }];
            
        }];
        
    }];
}

-(void)digAction:(id)sender
{
    UIButton *targetView = (UIButton*)sender;

    
    double durationTime = 0.13;//0.13秒
    double stayTime = 0.13;//动画过程中暂时呆停时间
    double fadeTime = 0.52;//下滑消失动画
    CGPoint anchorPoint = CGPointMake(0, 1);//中心点
    CGFloat originheight = 30.f;
    CGFloat vibrationHeight = 4.f;
    double  angle = M_PI_4 *0.333;//15度
    
    UIImage * digImage = [UIImage imageNamed:@"digupicon"];

    UIView *motionView = [[UIImageView alloc] initWithImage:digImage];
    motionView.center = CGPointMake(0, targetView.frame.size.height/8-originheight/2);
    UIWindow * applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    motionView.center = [applicationWindow convertPoint:motionView.center fromView:targetView];
    
    [applicationWindow addSubview:motionView];
    

    [UIView animateWithDuration:durationTime animations:^{
        CGAffineTransform t1 = CGAffineTransformMakeRotation(angle);
        CGAffineTransform t= CGAffineTransformMakeTranslation(0,vibrationHeight);
        motionView.layer.anchorPoint = anchorPoint;
        t = CGAffineTransformConcat(t, t1);
        motionView.transform = t;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:durationTime animations:^{
            CGAffineTransform t1 = CGAffineTransformIdentity;
            CGAffineTransform t= CGAffineTransformMakeTranslation(0,-vibrationHeight);
            motionView.layer.anchorPoint = anchorPoint;
            t = CGAffineTransformConcat(t, t1);
            motionView.transform = t;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:durationTime animations:^{
                CGAffineTransform t1 = CGAffineTransformMakeRotation(angle);
                CGAffineTransform t= CGAffineTransformMakeTranslation(0,vibrationHeight);
                motionView.layer.anchorPoint = anchorPoint;
                t = CGAffineTransformConcat(t, t1);
                motionView.transform = t;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:durationTime animations:^{
                    CGAffineTransform t1 = CGAffineTransformIdentity;
                    CGAffineTransform t= CGAffineTransformMakeTranslation(0,-vibrationHeight);
                    motionView.layer.anchorPoint = anchorPoint;
                    t = CGAffineTransformConcat(t, t1);
                    motionView.transform = t;
                    
                } completion:^(BOOL finished) {
                    CGRect endFrame = CGRectOffset(motionView.frame, 0, originheight);
                    [UIView animateWithDuration:fadeTime delay:stayTime options:0 animations:^{
                        motionView.frame = endFrame;
                        motionView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [motionView removeFromSuperview];
                    }];
                    
                }];
                
            }];
            
        }];
 
    }];
}

#pragma mark - earthquake
- (void)earthquake:(UIView*)itemView
{
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue])
    {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}
@end
