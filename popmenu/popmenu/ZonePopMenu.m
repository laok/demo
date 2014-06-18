//
//  ZonePopMenu.m
//  popmenu
//
//  Created by zhaokai on 14-6-17.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "ZonePopMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

#define ZonePopMenuViewTag 1999
#define ZonePopMenuViewImageHeight  72
#define ZonePopMenuViewTitleHeight  36 //fontHeight+topPad+bottomPad (16+10+10)
#define ZonePopMenuViewTitleFontSize    16.0f

#define ZonePopMenuViewVerticalPadding 40
#define ZonePopMenuViewHorizontalMargin3 20 //一行放3个
#define ZonePopMenuViewHorizontalMargin2 58 //一行放2个

#define ZonePopMenuViewRriseAnimationID @"ZonePopMenuViewRriseAnimationID"
#define ZonePopMenuViewDismissAnimationID @"ZonePopMenuViewDismissAnimationID"
#define ZonePopMenuViewAnimationTime 0.25
#define ZonePopMenuViewAnimationInterval (ZonePopMenuViewAnimationTime / 5)

#define ZonePopMenuViewDefaultBgColor [UIColor grayColor]

@interface UIView (pop_screenshot)
- (UIImage *)screenshot;
@end

@interface UIImage (pop_blurrEffect)
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
@end
#pragma mark - Button
@interface ZonePopMenuItemButton : UIButton
+ (id)menuItemButtonWithTitle:(NSString*)title
                   titleColor:(UIColor*)color
                       normal:(UIImage*)normalImage
                  highlighted:(UIImage*)highlightedImage
                selectedBlock:(ZonePopMenuItemSelectedBlock)block;
@property(nonatomic,copy)ZonePopMenuItemSelectedBlock selectedBlock;
@end

@implementation ZonePopMenuItemButton

+ (id)menuItemButtonWithTitle:(NSString*)title
                   titleColor:(UIColor*)color
                       normal:(UIImage*)normalImage
                  highlighted:(UIImage*)highlightedImage
             selectedBlock:(ZonePopMenuItemSelectedBlock)block
{
    ZonePopMenuItemButton *button = [ZonePopMenuItemButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font =[UIFont systemFontOfSize:ZonePopMenuViewTitleFontSize];
    
    button.selectedBlock = block;
    
    return button;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, ZonePopMenuViewImageHeight, ZonePopMenuViewImageHeight);
    self.titleLabel.frame = CGRectMake(0, ZonePopMenuViewImageHeight, ZonePopMenuViewImageHeight, ZonePopMenuViewTitleHeight);
}
@end

#pragma mark - ZonePopMenu
@interface ZonePopMenu()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIImageView *bgImagView;
@property (nonatomic,strong)NSMutableArray *buttonsArray;
@end
@implementation ZonePopMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //退出手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
//        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu)];
//        panGes.delegate = self;
//        [self addGestureRecognizer:panGes];
        //背景
        self.backgroundColor=[UIColor clearColor];
        _bgImagView = [[UIImageView alloc]initWithFrame:frame];
        _bgImagView.backgroundColor = ZonePopMenuViewDefaultBgColor ;
        _bgImagView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _bgImagView.userInteractionEnabled = NO;
        [self addSubview:_bgImagView];
        //退出按钮
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* normalImage = [UIImage imageNamed:@"closeicon_selecttype"];
        [closeButton setImage:normalImage forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"closeicon_selecttype_press"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
        CGSize imgSize = normalImage.size;
        closeButton.frame = CGRectMake(CGRectGetMaxX(self.frame)-imgSize.width, CGRectGetMinY(self.frame)+20, imgSize.width, imgSize.height);
        [self addSubview:closeButton];
        //
        _buttonsArray = [NSMutableArray arrayWithCapacity:6];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)addMenuItemWithTitle:(NSString*)title
                  titleColor:(UIColor*)color
                      normal:(UIImage*)normalImage
                 highlighted:(UIImage*)highlightedImage
               selectedBlock:(ZonePopMenuItemSelectedBlock)block
{
    ZonePopMenuItemButton *button = [ZonePopMenuItemButton menuItemButtonWithTitle:title
                                                                        titleColor:color
                                                                            normal:normalImage
                                                                       highlighted:highlightedImage
                                                                     selectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [self.buttonsArray addObject:button];
}

- (CGRect)frameForButtonAtIndex:(NSUInteger)index buttonsCount:(NSUInteger)count
{
    NSInteger horizontalMargin = ZonePopMenuViewHorizontalMargin3;
    NSUInteger columnCount = 3;
    
    CGFloat verticalPadding = (self.bounds.size.width - horizontalMargin * 2 - ZonePopMenuViewImageHeight * columnCount) / 2.0;
    
    if (count == 4) {
        columnCount = 2;
        horizontalMargin = ZonePopMenuViewHorizontalMargin2;
        verticalPadding = (self.bounds.size.width - horizontalMargin * 2 - ZonePopMenuViewImageHeight * columnCount);
    }
    
    
    CGFloat offsetX = horizontalMargin;
    
    NSUInteger rowCount = self.buttonsArray.count / columnCount + (self.buttonsArray.count%columnCount>0?1:0);
    NSUInteger rowIndex = index / columnCount;
    
    CGFloat itemHeight = (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight) * rowCount + (rowCount > 1?(rowCount - 1) * horizontalMargin:0);
    
    CGFloat offsetY = (self.bounds.size.height - itemHeight) / 2.0;
    

    NSUInteger columnIndex =  index % columnCount;
    
    offsetX += (ZonePopMenuViewImageHeight+ verticalPadding) * columnIndex;
    offsetY += (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight + ZonePopMenuViewVerticalPadding) * rowIndex;
    
    return CGRectMake(offsetX, offsetY, ZonePopMenuViewImageHeight, (ZonePopMenuViewImageHeight+ZonePopMenuViewTitleHeight));
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.buttonsArray.count;
    for (NSUInteger i = 0; i < count; i++) {
        ZonePopMenuItemButton *button = [self.buttonsArray objectAtIndex:i];
        button.frame = [self frameForButtonAtIndex:i buttonsCount:count];
        NSLog(@"index[%d],%@",i,NSStringFromCGRect(button.frame));
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[ZonePopMenuItemButton class]]) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    for (UIView* subview in self.buttonsArray) {
        if (CGRectContainsPoint(subview.frame, location)) {
            return NO;
        }
    }
    
    return YES;
}

-(void)closeMenu
{
    [self dropAnimation];
    double delayInSeconds = ZonePopMenuViewAnimationTime  + ZonePopMenuViewAnimationInterval * (self.buttonsArray.count + 1);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeMenu)]) {
            [self.delegate closeMenu];
        }
    });
}

- (void)buttonTapped:(ZonePopMenuItemButton*)btn
{
    [self closeMenu];
    double delayInSeconds = ZonePopMenuViewAnimationTime  + ZonePopMenuViewAnimationInterval * (self.buttonsArray.count + 1);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        btn.selectedBlock();
        
    });
}


- (void)riseAnimation
{
    NSUInteger columnCount = 3;
    NSUInteger rowCount = self.buttonsArray.count / columnCount + (self.buttonsArray.count%columnCount>0?1:0);
    NSUInteger buttonsCount = self.buttonsArray.count;
    
    for (NSUInteger index = 0; index < buttonsCount; index++) {
        ZonePopMenuItemButton *button = [self.buttonsArray objectAtIndex:index];
        button.layer.opacity = 0;
        CGRect frame = [self frameForButtonAtIndex:index buttonsCount:buttonsCount];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
//        NSLog(@"rowIndex:%lu,columnIndex:%lu,name:%@",rowIndex,columnIndex,button.titleLabel.text);
        CGPoint fromPosition = CGPointMake(frame.origin.x + ZonePopMenuViewImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight) / 2.0);
        
        CGPoint toPosition = CGPointMake(frame.origin.x + ZonePopMenuViewImageHeight / 2.0,frame.origin.y + (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * ZonePopMenuViewAnimationInterval;
#if 1
        if (rowCount-1 == rowIndex) {
//            if (!columnIndex) {
//                delayInSeconds += ZonePopMenuViewAnimationInterval;
//            }
//            else if(columnIndex == 2) {
                delayInSeconds += ZonePopMenuViewAnimationInterval * columnIndex;
//            }
        }else
        {
            if (!columnIndex) {
                delayInSeconds += ZonePopMenuViewAnimationInterval;
            }
            else if(columnIndex == 2) {
                delayInSeconds += ZonePopMenuViewAnimationInterval * 2;
            }
        }
#else
        if (!columnIndex) {
            delayInSeconds += ZonePopMenuViewAnimationInterval;
        }
        else if(columnIndex == 2) {
            delayInSeconds += ZonePopMenuViewAnimationInterval * 2;
        }
#endif

        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = ZonePopMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        double tempBeginTime = positionAnimation.beginTime;
//        NSLog(@"%f",tempBeginTime);
        NSLog(@"rowIndex:%d,columnIndex:%d,%f,name:%@",rowIndex,columnIndex,tempBeginTime,button.titleLabel.text);
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:ZonePopMenuViewRriseAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
    }
}

- (void)dropAnimation
{
    NSUInteger columnCount = 3;
    NSUInteger buttonsCount = self.buttonsArray.count;
    for (NSUInteger index = 0; index < self.buttonsArray.count; index++) {
        ZonePopMenuItemButton *button = [self.buttonsArray objectAtIndex:index];
        CGRect frame = [self frameForButtonAtIndex:index buttonsCount:buttonsCount];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
        
        CGPoint toPosition = CGPointMake(frame.origin.x + ZonePopMenuViewImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight) / 2.0);
        
        CGPoint fromPosition = CGPointMake(frame.origin.x + ZonePopMenuViewImageHeight / 2.0,frame.origin.y + (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * ZonePopMenuViewAnimationInterval;
        if (!columnIndex) {
            delayInSeconds += ZonePopMenuViewAnimationInterval;
        }
        else if(columnIndex == 2) {
            delayInSeconds += ZonePopMenuViewAnimationInterval * 2;
        }
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5f :1.0f :1.0f];
        positionAnimation.duration = ZonePopMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:ZonePopMenuViewDismissAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
        
    }
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSUInteger columnCount = 3;
    NSUInteger buttonsCount = self.buttonsArray.count;
    
    if([anim valueForKey:ZonePopMenuViewRriseAnimationID]) {
        NSUInteger index = [[anim valueForKey:ZonePopMenuViewRriseAnimationID] unsignedIntegerValue];
        UIView *view = [self.buttonsArray objectAtIndex:index];
        CGRect frame = [self frameForButtonAtIndex:index buttonsCount:buttonsCount];
        CGPoint toPosition = CGPointMake(frame.origin.x + ZonePopMenuViewImageHeight / 2.0,frame.origin.y + (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight) / 2.0);
        CGFloat toAlpha = 1.0;
        
        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
        
    }
    else if([anim valueForKey:ZonePopMenuViewDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:ZonePopMenuViewDismissAnimationID] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;
        
        UIView *view = [self.buttonsArray objectAtIndex:index];
        CGRect frame = [self frameForButtonAtIndex:index buttonsCount:buttonsCount
                        ];
        CGPoint toPosition = CGPointMake(frame.origin.x + ZonePopMenuViewImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (ZonePopMenuViewImageHeight + ZonePopMenuViewTitleHeight) / 2.0);
        
        view.layer.position = toPosition;
    }
}

-(void)showMenu:(UIImage*)backgoundImage
{

    //
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    
    
    appRootViewController = window.rootViewController;
    
    
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:ZonePopMenuViewTag]) {
        [[topViewController.view viewWithTag:ZonePopMenuViewTag] removeFromSuperview];
    }
    
    self.frame = topViewController.view.bounds;
    
    //
    self.bgImagView.frame=self.bounds;
    [self.bgImagView setImage:backgoundImage];
    //
    [topViewController.view addSubview:self];
    
    [self riseAnimation];
}

-(void)showMenu:(UIImage *)backgoundImage inView:(UIView*)view
{
    if (!view) {
        [self showMenu:backgoundImage];
    }else
    {
        self.frame = view.bounds;
        self.bgImagView.frame=self.bounds;
//        self.bgImagView.frame =CGRectOffset(self.bounds, 0, -20);
        [self.bgImagView setImage:backgoundImage];
        [view addSubview:self];
        [self riseAnimation];
    }
}
#pragma mark -
+(UIImage*)createBgImage:(UIView*)view
{
    if (!view) {
        return nil;
    }
    UIImage * image = [view screenshot];
    UIColor *tintColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1] /*#f8f8f8*/;
//    tintColor = nil;
    image = [image blurredImageWithRadius:15.0f iterations:5  tintColor:tintColor];
    return image;
}
@end

#pragma mark - Category 
@implementation UIView (pop_screenshot)
-(UIImage *)screenshot
{
    UIGraphicsBeginImageContext(self.bounds.size);
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //压缩
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

@end

@implementation UIImage (pop_blurrEffect)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    //    UIImage *image = [[UIImage alloc]init];
    return image;
}

@end
