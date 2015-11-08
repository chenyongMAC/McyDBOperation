//
//  MyDBOperation.h
//  MyEGODBOperation
//
//  Created by 陈勇 on 15/11/8.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface MyDBOperation : NSObject

+ (void)addUser:(UserModel *)user;

+ (void)queryUser:(void(^)(NSArray *))completionBlock;

@end
