//
//  UserModel.h
//  MySqlite3.0
//
//  Created by 陈勇 on 15/10/6.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger userAge;

@end
