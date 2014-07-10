//
//  NSManagedObject+KKModelManager.h
//  UseCoreData
//
//  Created by zhaokai on 14-7-9.
//  Copyright (c) 2014年 kk. All rights reserved.
//

typedef void(^ListResult)(NSArray* result, NSError *error);
typedef void(^ObjectResult)(id result, NSError *error);
typedef id(^AsyncProcess)(NSManagedObjectContext *ctx, NSString *className);

#import <CoreData/CoreData.h>
#import "KKModelManager.h"

@interface NSManagedObject (KKModelManager)

+(id)createNew;

+(NSError*)save:(OptionBlock)handler;

+(NSArray*)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit;

+(void)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler;

+(id)one:(NSString*)predicate;

+(void)one:(NSString*)predicate on:(ObjectResult)handler;

+(void)delobject:(id)object;

+(void)async:(AsyncProcess)processBlock result:(ListResult)resultBlock;
@end