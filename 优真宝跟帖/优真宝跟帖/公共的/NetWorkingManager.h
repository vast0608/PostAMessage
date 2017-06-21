//
//  NetWorkingManager.h
//  Transaction
//
//  Created by 张敏华 on 2016/11/28.
//  Copyright © 2016年 张敏华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkingManager : NSObject
+(id)GETSessionURLSplice:(NSString *)urlSplice UserID:(NSString *)userID UserToken:(NSString *)userToken Parameters:(NSString *)parameters HTTPHeaderKey:(NSArray *)httpHeaderKey HTTPHeaderValue:(NSArray *)httpHeaderValue
       completionHandler:(void (^)(id responseObjectmodel ,NSError *error))completionHandler;


//GET请求
+(id)GETURLSplice:(NSString *)urlSplice UserID:(NSString *)userID UserToken:(NSString *)userToken Parameters:(NSString *)parameters HTTPHeaderKey:(NSArray *)httpHeaderKey HTTPHeaderValue:(NSArray *)httpHeaderValue
     completionHandler:(void (^)(id responseObjectmodel ,NSError *error))completionHandler;

//POST请求
+(id)POSTURLSplice:(NSString *)urlSplice UserID:(NSString *)userID UserToken:(NSString *)userToken Parameters:(NSString *)parameters BodysTextKey:(NSArray *)bodysTextKey BodysTextValue:(NSArray *)bodysTextValue BodysImageKey:(NSString *)bodysImageKey BodysImageValue:(NSArray *)bodysImageValue completionHandler:(void (^)(id responseObjectmodel ,NSError *error))completionHandler;
@end
