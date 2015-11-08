//
//  UserModel.m
//  MySqlite3.0
//
//  Created by 陈勇 on 15/10/6.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(NSString *) description {
    return [NSString stringWithFormat:@"id:%@, name:%@, age:%ld", self.userID, self.userName, (long)self.userAge];
}

@end
