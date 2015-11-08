//
//  ViewController.m
//  MyEGODBOperation
//
//  Created by 陈勇 on 15/11/8.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import "ViewController.h"
#import "MyDBOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //*** 此处使用的表是事先创建好导入到工程中的，操作表时直接查找目录并且修改。这样的好处是省去了创建table的代码，而是使用更方便快捷的手动创建
    
    //添加数据
//    for (NSInteger i = 0; i < 20; i++) {
//
//        UserModel *user = [[UserModel alloc] init];
//        user.userID = [NSString stringWithFormat:@"%li", 2000+i];
//        user.userName = [NSString stringWithFormat:@"Mcy%li", i];
//        user.userAge = 20+i;
//
//
//        [MyDBOperation addUser:user];
//
//    }
    
    [MyDBOperation queryUser:^(NSArray *users) {
        
        for (UserModel *user in users) {
            NSLog(@"%@", user);
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
