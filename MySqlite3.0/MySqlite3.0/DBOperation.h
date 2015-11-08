//
//  DBOperation.h
//  MySqlite3.0
//
//  Created by 陈勇 on 15/10/6.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface DBOperation : NSObject

-(BOOL) createTable;
-(BOOL) insertUser:(UserModel *)user;
-(NSArray *) queryUser;

@end
