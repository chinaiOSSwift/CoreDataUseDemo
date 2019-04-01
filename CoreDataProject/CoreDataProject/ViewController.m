//
//  ViewController.m
//  CoreDataProject
//
//  Created by KOCHIAEE6 on 2019/3/29.
//  Copyright © 2019 KOCHIAEE6. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "Student+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ViewController ()<NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSManagedObjectContext *context;
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (NSManagedObjectContext *)context{
    if (!_context) {
        _context = [[DBManager sharedInstance] managedObjectContext:@"123"];
    }
    return _context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  创建数据抓取请求
     */
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    /**
     *  创建排序规则
     */
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"stuName" ascending:YES];
    // NSSortDescriptor * sort1 = [NSSortDescriptor sortDescriptorWithKey:@"stuAge" ascending:YES];
    /**
     *  为数据请求添加排序规则
     */
    request.sortDescriptors = @[sort];
    /**
     *  参数1:数据请求
     参数2:托管上下文
     参数3:section分区名称
     参数4:缓存数据
     
     */
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"stuName" cacheName:nil];
    /**
     * fetchedResultsController只不过是一个控制器而已,他没有能力去coredata里面拿取数据.tableview还找fetchedResultsController找数据.这个时候就要用到fetchedResultsControllerDlegaet
     */
    self.fetchedResultsController.delegate = self;
    /**
     *  执行抓取
     */
    [self.fetchedResultsController performFetch:nil];
}

- (IBAction)addAction:(id)sender {
    
    Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
    stu.stuId = arc4random() % 122 + 1;;
    stu.stuAge = arc4random() % 99 + 1;
    stu.stuName = [NSString stringWithFormat:@"姓名(%d)",arc4random() % 50];
    if (self.context.hasChanges) {
        NSError *error = nil;
        [self.context save:&error];
        if (error == nil) {
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }
    }
}

- (IBAction)deleteAction:(id)sender {
    // 获取数据的请求对象，指明对实体进行删除操作，以Employee为例
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    // 通过创建谓词对象，然后过滤掉符合要求的对象，也就是要删除的对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stuName = %@", @"姓名(46)"];
    request.predicate = predicate;
    
    // 通过执行获取操作，找到要删除的对象即可
    NSError *error = nil;
    NSArray<Student *> *students = [self.context executeFetchRequest:request error:&error];
    
    // 开始真正操作，一一遍历，遍历符合删除要求的对象数组，执行删除操作
    __weak typeof(self)weakSelf = self;
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull stu, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.context deleteObject:stu];
    }];
    
    // 最后保存数据，保存上下文。
    if (self.context.hasChanges) {
        [self.context save:&error];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Delete Data Error : %@", error);
    }else{
        NSLog(@"删除成功");
    }
}
- (IBAction)updateAction:(id)sender {
    // 获取数据的请求对象，指明对实体进行修改操作，以Employee为例
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 创建谓词对象，设置过滤条件，找到要修改的对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stuName = %@", @"姓名(46)"]; // 这里要注意 例如:stuName 必须是表中
    request.predicate = predicate;
    
    // 通过执行获取请求，获取到符合要求的托管对象，修改即可
    NSError *error = nil;
    NSArray<Student *> *students = [self.context executeFetchRequest:request error:&error];
    [students enumerateObjectsUsingBlock:^(Student * _Nonnull stu, NSUInteger idx, BOOL * _Nonnull stop) {
        stu.stuAge = 1200;
        stu.stuId = 789;
    }];
    if (error) {
        NSLog(@"修改失败");
    }else{
        NSLog(@"1233567");
    }
    error = nil;
    // 通过调用save将上面的修改进行存储
    if (self.context.hasChanges) {
        [self.context save:&error];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Update Data Error : %@", error);
    }else{
        NSLog(@"修改成功");
    }
}
- (IBAction)findAction:(id)sender {
    //  获取数据的请求对象，指明对实体进行查询操作，以Employee为例
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray<Student *> *students = [self.context executeFetchRequest:request error:&error];
    for (Student *stu in students) {
        NSLog(@"stu.name--%@,stu.age--%d,stu.id-%d",stu.stuName,stu.stuAge,stu.stuId);
    }
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }else{
        NSLog(@"查询成功一共%ld条记录",students.count);
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray * sections = [self.fetchedResultsController sections];
    NSLog(@"section-%ld",sections.count);
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    NSLog(@"row:%ld",[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    Student * model = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = model.stuName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d 岁",model.stuAge];
    return cell;
}


// 指示条
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSArray * sections = [self.fetchedResultsController sections];
//    NSMutableArray * arr = [NSMutableArray array];
//    BOOL b = false;
//    for (id<NSFetchedResultsSectionInfo> sectionInfo in sections) {
//        if ([[sectionInfo name]isEqualToString:@"a"]) {
//            b = YES;
//        }
//        [arr addObject:[sectionInfo name]];
//    }
//    if (b) {
//        [arr addObject:@"#"];
//    }
//    return arr;
//}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Student * model = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.context deleteObject:model];
    [self.context save:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Student * model = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"name:%@ -%ld - %ld",model.stuName,model.stuAge,model.stuId);
}



#pragma mark - 以下代码直接Ctr + C

//当CoreData的数据将要发生改变时，FRC产生的回调
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

//分区改变状况
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
            
            
    }
}

//数据改变状况，这里如果从官方文档中复制过来的，要求改一个地方
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            //让tableView在newIndexPath位置插入一个cell
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //让tableView刷新indexPath位置上的cell
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //            [self.searchDisplayController.searchResultsTableView reloadData];
            //            [self.searchDisplayController.searchResultsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

//整个数据完成了，结束更新
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
}
@end




























