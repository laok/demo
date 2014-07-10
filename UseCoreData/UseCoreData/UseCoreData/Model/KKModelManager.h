//
//  KKModelManager.h
//  UseCoreData
//
//  Created by zhaokai on 14-7-6.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef void(^OptionBlock)(NSError* error);


@interface KKModelManager : NSManagedObjectContext

+ (instancetype)sharedInstance;

- (NSManagedObjectContext *)createPrivateQueueMOC;
-(NSManagedObjectContext*)mainMOC;
-(NSError*)save:(OptionBlock)handler;

@end
