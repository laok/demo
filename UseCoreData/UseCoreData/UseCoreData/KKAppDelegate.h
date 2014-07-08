//
//  KKAppDelegate.h
//  UseCoreData
//
//  Created by zhaokai on 14-7-6.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly,strong, nonatomic) NSManagedObjectContext *managedObjectContext;//
@property (readonly,strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (readonly,strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end
