//
//  NetWorkingManager.m
//  Transaction
//
//  Created by 张敏华 on 2016/11/28.
//  Copyright © 2016年 张敏华. All rights reserved.
//

#import "NetWorkingManager.h"
#import "AFNetworking.h"
#import "PlaceOrderErrorTipModel.h"
#import<CommonCrypto/CommonDigest.h>
#define App_Key  @""
#define App_Secret  @""

@implementation NetWorkingManager

+(id)GETSessionURLSplice:(NSString *)urlSplice UserID:(NSString *)userID UserToken:(NSString *)userToken Parameters:(NSString *)parameters HTTPHeaderKey:(NSArray *)httpHeaderKey HTTPHeaderValue:(NSArray *)httpHeaderValue
completionHandler:(void (^)(id responseObjectmodel ,NSError *error))completionHandler{

    NSString *string;
    NSString *BundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([BundleID isEqualToString:@"com.shyl.posts"]) {
        string = [NSString stringWithFormat:@"https://api.uzhenbao.com%@",urlSplice];
    }else {
        string = [NSString stringWithFormat:@"http://dev-api.uzhenbao.com%@",urlSplice];
    }
    NSString *apiVersion;
    if ([parameters isEqualToString:@"2"]) {
        apiVersion = @"2";
    }else{
        apiVersion = @"1";
    }
    //请求头
    NSString *strq = [NSString stringWithFormat:@"%@%@%@%.0f%@%@",@"GET",string,apiVersion,[[NSDate date] timeIntervalSince1970],@"0",App_Secret];
    NSDictionary *headers = @{@"user-id":userID,
                              @"access-token":userToken,
                              @"api-version":apiVersion,
                              @"app-key":App_Key,
                              @"timestamp":[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],
                              @"debug":@"true",
                              @"sign":[self sha1:strq]
                              };
    //以免有中文进行UTF编码
    NSString *UTFPathURL = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //请求路径
    NSURL *url = [NSURL URLWithString:UTFPathURL];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    //设置请求超时
    request.timeoutInterval = 20;
    //创建session配置对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //创建session对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //添加网络任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        completionHandler(data,error);
    }];
    //开始任务
    [task resume];
    
    return task;
}



//GET请求
+(id)GETURLSplice:(NSString *)urlSplice UserID:(NSString *)userID UserToken:(NSString *)userToken Parameters:(NSString *)parameters HTTPHeaderKey:(NSArray *)httpHeaderKey HTTPHeaderValue:(NSArray *)httpHeaderValue
          completionHandler:(void (^)(id responseObjectmodel ,NSError *error))completionHandler{
    NSString *url;
    NSString *BundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([BundleID isEqualToString:@"com.shyl.posts"]) {
        url = [NSString stringWithFormat:@"https://api.uzhenbao.com%@",urlSplice];
    }else {
        url = [NSString stringWithFormat:@"http://dev-api.uzhenbao.com%@",urlSplice];
    }
    NSString *apiVersion;
    if ([parameters isEqualToString:@"2"]) {
        apiVersion = @"2";
    }else{
        apiVersion = @"1";
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //过滤NULL
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    //设置返回数据的格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //循环收到的请求头
    for (int i=0; i<httpHeaderKey.count; i++) {
        [manager.requestSerializer setValue:httpHeaderKey[i] forHTTPHeaderField:httpHeaderKey[i]];
    }
    //请求头
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"access-token"];
    [manager.requestSerializer setValue:apiVersion forHTTPHeaderField:@"api-version"];
    [manager.requestSerializer setValue:userID forHTTPHeaderField:@"user-id"];
    [manager.requestSerializer setValue:App_Key forHTTPHeaderField:@"app-key"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forHTTPHeaderField:@"timestamp"];
    //[manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"info"];
    [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"debug"];

    NSString *strq = [NSString stringWithFormat:@"%@%@%@%.0f%@%@",@"GET",url,apiVersion,[[NSDate date] timeIntervalSince1970],@"0",App_Secret];
    [manager.requestSerializer setValue:[self sha1:strq] forHTTPHeaderField:@"sign"];

    return [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        completionHandler(responseObject,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        completionHandler(nil,error);
        
    }];
}
//POST请求
+(id)POSTURLSplice:(NSString *)urlSplice UserID:(NSString *)userID UserToken:(NSString *)userToken Parameters:(NSString *)parameters BodysTextKey:(NSArray *)bodysTextKey BodysTextValue:(NSArray *)bodysTextValue BodysImageKey:(NSString *)bodysImageKey BodysImageValue:(NSArray *)bodysImageValue completionHandler:(void (^)(id responseObjectmodel ,NSError *error))completionHandler{
    NSString *url;
    NSString *BundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([BundleID isEqualToString:@"com.shyl.posts"]) {
        url = [NSString stringWithFormat:@"https://api.uzhenbao.com%@",urlSplice];
    }else {
        url = [NSString stringWithFormat:@"http://dev-api.uzhenbao.com%@",urlSplice];
    }
    NSString *apiVersion;
    if ([parameters isEqualToString:@"2"]) {
        apiVersion = @"2";
    }else{
        apiVersion = @"1";
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:1 timeoutInterval:30];
    
    request.HTTPMethod = @"POST";
    request.timeoutInterval=30.0;//设置请求超时
    
    [request setValue:userID forHTTPHeaderField:@"user-id"];
    [request setValue:userToken forHTTPHeaderField:@"access-token"];
    [request setValue:apiVersion forHTTPHeaderField:@"api-version"];
    [request setValue:App_Key forHTTPHeaderField:@"app-key"];
    [request setValue:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forHTTPHeaderField:@"timestamp"];
    //[request setValue:@"true" forHTTPHeaderField:@"info"];
    //[request setValue:@"true" forHTTPHeaderField:@"debug"];
    //(4)请求头
    // Build the request body
    NSString *boundary = @"SportuondoFormBoundary";
    //upload task不会在请求头里添加content-type(上传数据类型)字段
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;charset=utf-8;boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

    //(5)设置请求体
    NSMutableData *body = [NSMutableData data];
    for (int i=0; i<bodysTextKey.count; i++) {
        // Body part for "deviceId" parameter. This is a string.
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", bodysTextKey[i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", bodysTextValue[i]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //NSLog(@"----%@---",body);
    for (int i=0; i<bodysImageValue.count; i++) {

        if (bodysImageValue[i]) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            if ([bodysImageKey isEqualToString:@"image"]||[bodysImageKey isEqualToString:@"avatar"]) {//image--单个图片
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", [NSString stringWithFormat:@"%@",bodysImageKey]] dataUsingEncoding:NSUTF8StringEncoding]];
            }else{//images--多个图片
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", [NSString stringWithFormat:@"%@[%d]",bodysImageKey,i]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:bodysImageValue[i]];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = body;
    
    NSString *stra = [NSString stringWithFormat:@"%@%@%@%.0f%lu%@",@"POST",url,apiVersion,[[NSDate date] timeIntervalSince1970],request.HTTPBody.length,App_Secret];
    [request setValue:[self sha1:stra] forHTTPHeaderField:@"sign"];

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        completionHandler(result,error);
    }];
    [task resume];
    return task;
}


//sha1加密方式
+ (NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
@end
