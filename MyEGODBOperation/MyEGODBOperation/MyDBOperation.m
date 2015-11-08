//
//  MyDBOperation.m
//  MyEGODBOperation
//
//  Created by 陈勇 on 15/11/8.
//  Copyright © 2015年 陈勇. All rights reserved.
//

/*
 创建数据库中表的方法有两种：
 1.可以使用sqlite语句来进行。
 2.把数据库文件先建好，将工程所有要用到的表都建好，然后把定义好的数据库添加到项目中。因为程序包中的文件不能修改，将程序包中的数据库文件copy到沙盒路径下。
 */


#import "MyDBOperation.h"
#import "EGODatabase.h"

#define DBFILEPATH [NSHomeDirectory() stringByAppendingString:@"/Documents/userDB.rdb"]

@implementation MyDBOperation

//同步添加数据
+ (void)addUser:(UserModel *)user {
    
    //1.打开数据库
    EGODatabase *database = [[EGODatabase alloc] initWithPath:DBFILEPATH];
    NSLog(@"%@", DBFILEPATH);
    
    [database open];
    
    //2.构造sql语句
    NSString *insertSQL = @"INSERT INTO user(user_id,user_name,user_age) VALUES(?,?,?)";
    
    //3.执行sql语句
    NSArray *params = @[user.userID,
                        user.userName,
                        @(user.userAge)
                        ];
    [database executeUpdate:insertSQL parameters:params];
    
    //4.关闭数据库
    [database close];
    
}

//异步查询数据
+ (void)queryUser:(void (^)(NSArray *))completionBlock {
    
    //1.打开数据库
    EGODatabase *database = [[EGODatabase alloc] initWithPath:DBFILEPATH];
    
    [database open];
    
    //2.定义sql语句
    NSString *sql = @"SELECT * FROM user";
    
    //3.异步查询请求对象
    EGODatabaseRequest *request = [database requestWithQuery:sql];
    
    [request setCompletion:^(EGODatabaseRequest *request, EGODatabaseResult *result, NSError *error) {
        if (error) {
            //关闭数据库
            [database close];
            
            return;
            
        }
        
        NSMutableArray *usrArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < result.count; i++) {
            
            //获取行数据
            EGODatabaseRow *row = result.rows[i];
            
            //创建Model对象
            UserModel *user = [[UserModel alloc] init];
            //获取列数据
            user.userID = [row stringForColumn:@"user_id"];
            user.userName = [row stringForColumnAtIndex:1];
            user.userAge = [row intForColumnAtIndex:2];
            
            [usrArray addObject:user];
        }
        
        //回调block，把查询结果返回给调用者
        completionBlock(usrArray);
        
        [database close];
        
    }];
    
    //4.将异步查询任务添加到队列中执行
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
    
    
}


@end
