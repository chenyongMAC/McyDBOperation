//
//  DBOperation.m
//  MySqlite3.0
//
//  Created by 陈勇 on 15/10/6.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import "DBOperation.h"
#import <sqlite3.h>
#import "UserModel.h"

@implementation DBOperation

-(NSString *) dataBasePath {
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"userDB.rdb"];
//    NSLog(@"%@", filePath); //测试
    return filePath;
}

-(BOOL) createTable {
    //1.打开数据库文件
    NSString *filePath = [self dataBasePath];
    
    sqlite3 *DBhandle = NULL;
    int result = sqlite3_open([filePath UTF8String], &DBhandle);
    if (result != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    //2.构造一个SQL语句
    NSString *createSQL = @"create table user(user_id text, user_name text, user_age integer)";
    //3.执行SQL语句. DDL和DML中不需要使用到callBack
    char *error = NULL;
    result = sqlite3_exec(DBhandle, [createSQL UTF8String], NULL, NULL, &error);
    if (result != SQLITE_OK) {
        NSLog(@"创建列表失败");
        return NO;
    }
    //4.关闭数据库
    sqlite3_close(DBhandle);
    
    return YES;
}

-(BOOL) insertUser:(UserModel *)user {
    //1.打开数据库软件
    NSString *filePath = [self dataBasePath];
    NSLog(@"%@", filePath);
    
    sqlite3 *DBHandle = NULL;
    int result = sqlite3_open([filePath UTF8String], &DBHandle);
    if (result != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    //2.构造sqlite语句
    /* 预编译SQL语句中，可以包含多种占位符形式(具体使用可查询)
     
     * ?
     * ?NNN
     * :VVV
     * @VVV
     * $VVV
     */
    NSString *insertSQL = @"insert into user(user_id, user_name, user_age) values(?, ?, ?)";
    
    //3.预编译SQL语句
    /*
     db：sqlite3的数据库句柄
     zSql：将要执行的SQL语句
     nByte：要执行的语句在zSql中的最大长度。如果设置为-1，则需要根据实际的长度计算
     ppStmt：预编译之后的数据库句柄
     pzTail：预编译之后剩下的字符串，通常没什么用
     */
    sqlite3_stmt *stmt = NULL;
    result = sqlite3_prepare_v2(DBHandle, [insertSQL UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"预编译失败");
        //关闭数据库，因为之前打开成功了
        sqlite3_close(DBHandle);
        return NO;
    }
    
    //4.向占位符上填充数据（绑定预编译字段的值，不同的数据类型对应不同的方法）
    sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [user.userName UTF8String], -1, NULL);
    sqlite3_bind_int64(stmt, 3, user.userAge);
    
    //5.执行sql语句
    result = sqlite3_step(stmt);
    if (result != SQLITE_DONE) {
        NSLog(@"插入数据失败");
        
        //关闭数据库句柄
        sqlite3_finalize(stmt);
        sqlite3_close(DBHandle);
        
        return NO;
    }
    
    //6.重置预编译语句
    sqlite3_reset(stmt);
    
    //7.销毁资源，关闭数据库句柄
    sqlite3_finalize(stmt);
    sqlite3_close(DBHandle);
    
    return YES;
}

-(NSArray *) queryUser {
    //1.打开数据库
    NSString *filePath = [self dataBasePath];
    NSLog(@"%@", filePath);
    
    sqlite3 *DBHandle = NULL;
    int result = sqlite3_open([filePath UTF8String], &DBHandle);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return nil;
    }
    
    //2.构造Sql语句
    NSString *querySql = @"select * from user where user_age>?";
    
    //3.预编译
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(DBHandle, [querySql UTF8String], -1, &stmt, NULL);
    
    //4.向占位符上绑定数据
    int age = 10;
    sqlite3_bind_int(stmt, 1, age);
    
    //5.执行数据库操作
    NSMutableArray *array = [NSMutableArray array];
    int hasData = sqlite3_step(stmt);
    while (hasData == SQLITE_ROW) {
        //查询到所需数据
        //取出游标指向的行数据
        const unsigned char *user_id = sqlite3_column_text(stmt, 0);
        const unsigned char *user_name = sqlite3_column_text(stmt, 1);
        int user_age = sqlite3_column_int(stmt, 2);
        
        //将取出的数据赋值给UserModel
        UserModel *userModel = [[UserModel alloc] init];
        userModel.userID = [NSString stringWithCString:(const char*)user_id encoding:NSUTF8StringEncoding];
        userModel.userName = [NSString stringWithCString:(const char*)user_name encoding:NSUTF8StringEncoding];
        userModel.userAge = user_age;
        [array addObject:userModel];
        
        //继续下一轮查找
        hasData = sqlite3_step(stmt);
    }
    
    return array;
}

@end



