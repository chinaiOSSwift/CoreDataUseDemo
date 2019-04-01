//
//  DBManager.m
//  CoreDataProject
//
//  Created by KOCHIAEE6 on 2019/3/29.
//  Copyright © 2019 KOCHIAEE6. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager


//单例
+(id)sharedInstance {
    static DBManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext:(NSString *)dbName{
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator:dbName];
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 将协调器设置给上下文, 从此上下文就拥有了权利(增删改查)
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator:(NSString *)dbName{
    //if (!_persistentStoreCoordinator) {
        NSString *DBName = [dbName stringByAppendingString:@"StudentCoreData.sqlite"];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DBName];
        //NSLog(@"存储路径:%@",storeURL);
        NSError *error = nil;
        // 持久化存储协调器 (让模型 和 数据库发生关系)
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        // 通过协调器设置数据的存储方法
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (error != nil) {
            NSLog(@"error--%@",error.localizedDescription);
        }
    //}
    return _persistentStoreCoordinator;
}
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    if (!_managedObjectModel) {
        //coreData 模型的路径
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StudentCoreData" withExtension:@"momd"];
        //// 通过路径加载coreData模型(可以映射到数据库里)
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
