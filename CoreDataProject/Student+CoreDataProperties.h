//
//  Student+CoreDataProperties.h
//  CoreDataProject
//
//  Created by KOCHIAEE6 on 2019/4/1.
//  Copyright © 2019 KOCHIAEE6. All rights reserved.
//
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nonatomic) int16_t stuAge;
@property (nonatomic) int32_t stuId;
@property (nullable, nonatomic, copy) NSString *stuName;

@end

NS_ASSUME_NONNULL_END
