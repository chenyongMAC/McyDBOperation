//
//  ViewController.m
//  MySqlite3.0
//
//  Created by 陈勇 on 15/10/6.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import "ViewController.h"
#import "DBOperation.h"
#import "UserModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DBOperation *dataBase = [[DBOperation alloc] init];
    
    //创建表
//    [dataBase createTable];
    
    //插入表
//    NSMutableArray *array = [NSMutableArray array];
//    
//    for (NSInteger i=0; i<20; i++) {
//        UserModel *userModel = [[UserModel alloc] init];
//        userModel.userID = [NSString stringWithFormat:@"%ld", 1000+i];
//        userModel.userName = [NSString stringWithFormat:@"Mcy%ld", (long)i];
//        userModel.userAge = 20;
//        
//        [array addObject:userModel];
//    }
//    
//    for (UserModel *user in array) {
//        [dataBase insertUser:user];
//    }
    
    //查询表
    NSArray *array = [dataBase queryUser];
    for (UserModel *userModel in array) {
        //在UserModel类中复写了description方法
        NSLog(@"%@", userModel);
    }
}



@end
