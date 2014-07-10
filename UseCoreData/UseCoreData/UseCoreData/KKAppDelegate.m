//
//  KKAppDelegate.m
//  UseCoreData
//
//  Created by zhaokai on 14-7-6.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import "KKAppDelegate.h"
#import "Entity.h"

@implementation KKAppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self test];
    return YES;
}
-(void)test
{
    //test
    NSLog(@"test start");
    
 NSManagedObjectContext* context = self.managedObjectContext;
#if 0
    for (int i=0; i<20; i++) {
        Entity* newEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
        newEntity.title =@"tess2td";
        newEntity.task_id=@(1004+i);
        newEntity.detail = @"do 2some thing1";
        newEntity.done = @(YES);//[NSNumber numberWithBool:YES];
    }

    BOOL changes = [self.managedObjectContext hasChanges];
    if (changes) {
        [self.managedObjectContext save:nil];
    }
#endif
    
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Entity"];
    [request setReturnsObjectsAsFaults:NO];
    request.fetchLimit = 7;
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"task_id" ascending:YES]]];
    NSPredicate* predicate = [request predicate];
    NSError *error;
    NSArray *dataArray = [context executeFetchRequest:request error:&error];
    for (Entity* entity in dataArray) {
        NSLog(@"%d,%@",[entity.task_id integerValue],entity.title);
    }
    NSLog(@"new fetch:");
    request.fetchOffset =7;
    dataArray = [context executeFetchRequest:request error:&error];
    for (Entity* entity in dataArray) {
        NSLog(@"%d,%@",[entity.task_id integerValue],entity.title);
    }
    
    NSLog(@"test end");
}
#pragma mark - core data

-(NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
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
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
