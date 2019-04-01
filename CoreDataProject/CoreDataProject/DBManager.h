//
//  DBManager.h
//  CoreDataProject
//
//  Created by KOCHIAEE6 on 2019/3/29.
//  Copyright © 2019 KOCHIAEE6. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

/**管理对象，上下文，持久性存储模型对象*/
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
/**被管理的数据模型(通过路径加载coreData模型,可以映射到数据库里)，数据结构*/
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
/** 连接数据库的(持久化存储协调器  让 模型 和 数据库发生关系)*/
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  单例
 *
 */
+(id)sharedInstance;
- (NSManagedObjectContext *)managedObjectContext:(NSString *)dbName;

@end

NS_ASSUME_NONNULL_END
