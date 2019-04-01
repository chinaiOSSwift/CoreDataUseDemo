//
//  Student+CoreDataProperties.m
//  CoreDataProject
//
//  Created by KOCHIAEE6 on 2019/4/1.
//  Copyright © 2019 KOCHIAEE6. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic stuAge;
@dynamic stuId;
@dynamic stuName;

@end
