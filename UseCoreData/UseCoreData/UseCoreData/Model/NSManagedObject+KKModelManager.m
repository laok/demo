//
//  NSManagedObject+KKModelManager.m
//  UseCoreData
//
//  Created by zhaokai on 14-7-9.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "NSManagedObject+KKModelManager.h"

@implementation NSManagedObject (KKModelManager)

+(id)createNew{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[[KKModelManager sharedInstance] mainMOC]];
}

+(NSError*)save:(OptionBlock)handler{
    return [[KKModelManager sharedInstance] save:handler];
}

+(NSArray*)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit{
    
    NSManagedObjectContext *ctx = [[KKModelManager sharedInstance]mainMOC];
    NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:orders offset:offset limit:limit];
    
    NSError* error = nil;
    NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return @[];
    }
    return results;
}


+(NSFetchRequest*)makeRequest:(NSManagedObjectContext*)ctx predicate:(NSString*)predicate orderby:(NSArray*)orders offset:(int)offset limit:(int)limit{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:ctx]];
    if (predicate) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicate]];
    }
    NSMutableArray *orderArray = [[NSMutableArray alloc] init];
    if (orders!=nil) {
        for (NSString *order in orders) {
            NSSortDescriptor *orderDesc = nil;
            if ([[order substringToIndex:1] isEqualToString:@"-"]) {
                orderDesc = [[NSSortDescriptor alloc] initWithKey:[order substringFromIndex:1]
                                                        ascending:NO];
            }else{
                orderDesc = [[NSSortDescriptor alloc] initWithKey:order
                                                        ascending:YES];
            }
        }
        [fetchRequest setSortDescriptors:orderArray];
    }
    if (offset>0) {
        [fetchRequest setFetchOffset:offset];
    }
    if (limit>0) {
        [fetchRequest setFetchLimit:limit];
    }
    return fetchRequest;
}

+(void)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler{
    
    NSManagedObjectContext *ctx = [[KKModelManager sharedInstance] createPrivateQueueMOC];
    [ctx performBlock:^{
        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:orders offset:offset limit:limit];
        NSError* error = nil;
        NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"error: %@", error);
            [[[KKModelManager sharedInstance]mainMOC] performBlock:^{
                handler(@[], nil);
            }];
        }
        if ([results count]<1) {
            [[[KKModelManager sharedInstance] mainMOC] performBlock:^{
                handler(@[], nil);
            }];
        }
        NSMutableArray *result_ids = [[NSMutableArray alloc] init];
        for (NSManagedObject *item  in results) {
            [result_ids addObject:item.objectID];
        }
        [[[KKModelManager sharedInstance] mainMOC] performBlock:^{
            NSMutableArray *final_results = [[NSMutableArray alloc] init];
            for (NSManagedObjectID *oid in result_ids) {
                [final_results addObject:[[[KKModelManager sharedInstance] mainMOC] objectWithID:oid]];
            }
            handler(final_results, nil);
        }];
    }];
}


+(id)one:(NSString*)predicate{
    NSManagedObjectContext *ctx = [[KKModelManager sharedInstance] mainMOC];
    NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
    NSError* error = nil;
    NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
    if ([results count]!=1) {
        raise(1);
    }
    return results[0];
}

+(void)one:(NSString*)predicate on:(ObjectResult)handler{
    NSManagedObjectContext *ctx = [[KKModelManager sharedInstance] mainMOC];
    [ctx performBlock:^{
        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
        NSError* error = nil;
        NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"error: %@", error);
            [[[KKModelManager sharedInstance]mainMOC] performBlock:^{
                handler(@[], nil);
            }];
        }
        if ([results count]<1) {
            [[[KKModelManager sharedInstance]mainMOC] performBlock:^{
                handler(@[], nil);
            }];
        }
        NSManagedObjectID *objId = ((NSManagedObject*)results[0]).objectID;
        [[[KKModelManager sharedInstance]mainMOC] performBlock:^{
            handler([[[KKModelManager sharedInstance]mainMOC] objectWithID:objId], nil);
        }];
    }];
}


+(void)delobject:(id)object{
    [[[KKModelManager sharedInstance]mainMOC] deleteObject:object];
    
}

+(void)async:(AsyncProcess)processBlock result:(ListResult)resultBlock{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSManagedObjectContext *ctx = [[KKModelManager sharedInstance] createPrivateQueueMOC];
    [ctx performBlock:^{
        id resultList = processBlock(ctx, className);
        if (resultList) {
            if ([resultList isKindOfClass:[NSError class]]) {
                [[[KKModelManager sharedInstance]mainMOC] performBlock:^{
                    resultBlock(nil, resultList);
                }];
            }
            if ([resultList isKindOfClass:[NSArray class]]) {
                NSMutableArray *idArray = [[NSMutableArray alloc] init];
                for (NSManagedObject *obj in resultList) {
                    [idArray addObject:obj.objectID];
                }
                NSArray *objectIdArray = [idArray copy];
                [[[KKModelManager sharedInstance] mainMOC] performBlock:^{
                    NSMutableArray *objArray = [[NSMutableArray alloc] init];
                    for (NSManagedObjectID *robjId in objectIdArray) {
                        [objArray addObject:[[[KKModelManager sharedInstance]mainMOC] objectWithID:robjId]];
                    }
                    if (resultBlock) {
                        resultBlock([objArray copy], nil);
                    }
                }];
            }
            
        }else{
            resultBlock(nil, nil);
        }
    }];
}
@end
