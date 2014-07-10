//
//  KKModelManager.m
//  UseCoreData
//
//  Created by zhaokai on 14-7-6.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKModelManager.h"

#define kDBName @"name.sqlite"

@interface KKModelManager()

@property (nonatomic,copy)NSString* storeName;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;//
@property (strong, nonatomic) NSManagedObjectContext *backgroundObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end

@implementation KKModelManager

+ (instancetype)sharedInstance {
    static KKModelManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KKModelManager alloc]init];
        [_sharedInstance setupCoreDataWithStore];
    });
    
    return _sharedInstance;
}
#pragma mark - 
-(NSManagedObjectContext*)mainMOC
{
    return _managedObjectContext;
}
- (NSManagedObjectContext *)createPrivateQueueMOC
{
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [moc setParentContext:_managedObjectContext];
    
    return moc;
}

-(NSError*)save:(OptionBlock)handler
{
    NSError *error = nil;
    if ([_managedObjectContext hasChanges]) {
        [_managedObjectContext save:&error];
        [_backgroundObjectContext performBlock:^{
            __block NSError *inner_error = nil;
            [_backgroundObjectContext save:&inner_error];
            if (handler){
                [_managedObjectContext performBlock:^{
                    handler(error);
                }];
            }
        }];
    }
    return error;
}
#pragma mark - build
-(void)setupCoreDataWithStore
{
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _backgroundObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundObjectContext setPersistentStoreCoordinator:coordinator];
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setParentContext:_backgroundObjectContext];
    }
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator!=nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    NSError *err = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&err]) {
        NSLog(@" unsolved err:%@,%@",err,[err userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}
#pragma mark -
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSURL *)storePathURL
{
    return  [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kDBName];
}

@end
