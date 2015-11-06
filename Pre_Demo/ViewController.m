//
//  ViewController.m
//  Pre_Demo
//
//  Created by 沈红榜 on 15/11/4.
//  Copyright © 2015年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <MagicalRecord/MagicalRecord.h>

@interface Model : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSString    *age;

@end

@implementation Model


@end

@interface ViewController ()

@end

@implementation ViewController {
    
    __weak IBOutlet UITextField *_name;
    
    __weak IBOutlet UITextField *_age;
    
    __weak IBOutlet UITextView *_textView;
    NSInteger       _page;
}

- (void)viewDidLoad {cloudStorePathComponent:
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSArray *array = @[
//                       @"1",
//                       @"2",
//                       @"3",
//                       @"4",
//                       @"5",
//                       @"6",
//                       @"7",
//                       @"8",
//                       @"9",
//                       @"10",
//                       @"11",
//                       ];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
//    for (int i = 0; i < 10; i++) {
////        [array addObject:[NSString stringWithFormat:@"%ld", (long)i]];
//        Model *temp = [[Model alloc] init];
//        temp.name = [NSString stringWithFormat:@"%d", i];
//        temp.age = [NSString stringWithFormat:@"%d", i * 3];
//        [array addObject:temp];
//    }
//    
//    
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.age = %@", @"9"];
//    NSArray *tempArray = [array filteredArrayUsingPredicate:pre];
//    NSLog(@"%@", tempArray);
//    
//    NSInteger num = [array indexOfObject:tempArray[0]];
//    NSLog(@"%ld", (long)num);
    
    _page = 0;
    
//    for (int i = 0; i < 100; i++) {
//        Person *boy = [Person MR_createEntity];
//        boy.name = [NSString stringWithFormat:@"name_%d", i];
//        boy.age = [NSString stringWithFormat:@"%d", i + 20];
//        [boy.managedObjectContext MR_saveToPersistentStoreAndWait];
//    }
    
    
    
}
- (IBAction)addData:(id)sender {
    if (!_name.text.length) {
        return;
    }
    Person *boy = [Person MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"name = %@", _name.text]];
    if (!boy) {
        boy = [Person MR_createEntity];
    }
    boy.name = _name.text;
    boy.age = _age.text;
    [boy.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    _textView.text = [NSString stringWithFormat:@"添加了： name = %@, age = %@", boy.name, boy.age];
}

- (IBAction)check:(id)sender {
    NSFetchRequest *request = [Person MR_requestAll];
    [request setFetchOffset:_page];
    [request setFetchLimit:3];
    
    _page += 3;
    
    NSArray *array = [Person MR_executeFetchRequest:request];
    NSArray *temp = [array valueForKeyPath:@"@unionOfObjects.name"];
    if (!temp.count) {
        _page = 0;
    }
    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
    [array enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *st = [NSString stringWithFormat:@"name = %@, age = %@", obj.name, obj.age];
        [ar addObject:st];
    }];
    NSString *k = [ar componentsJoinedByString:@"\r"];
    _textView.text = [NSString stringWithFormat:@"分页查询：\r%@", k];
}
- (IBAction)deleteAll:(id)sender {
    NSArray *array = [Person MR_findAll];
    [array enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj MR_deleteEntity];
    }];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    _textView.text = @"删除所有";
}
- (IBAction)findAll:(id)sender {
    NSArray *array = [Person MR_findAll];

    
    
    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
    [array enumerateObjectsUsingBlock:^(Person *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *st = [NSString stringWithFormat:@"name = %@, age = %@", obj.name, obj.age];
        [ar addObject:st];
    }];
    NSString *k = [ar componentsJoinedByString:@"\r"];
    _textView.text = [NSString stringWithFormat:@"显示所有：\r%@", k];
    
    
    NSLog(@"%@", array);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
