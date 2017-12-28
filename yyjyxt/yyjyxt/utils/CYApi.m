//
//  CYApi.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "CYApi.h"
#import <AFNetworking.h>
#import "PublicVarible.h"

#define BaseUrl @"ycjy.cqmxcx.cn:8012"
#define API_BASE_URL [NSString stringWithFormat:@"http://%@/index.php?app=api",BaseUrl]

@interface CYApi()
@property(nonatomic, strong)AFHTTPSessionManager *sessionManager;
@end

static CYApi *__privatecyapi = nil;


@implementation CYApi

+(CYApi*)SharedAPI{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __privatecyapi = [[CYApi alloc] init];
        AFHTTPSessionManager *_httpManger = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        _httpManger.responseSerializer = response;
        _httpManger.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_httpManger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _httpManger.requestSerializer.timeoutInterval = 10.f;
        [_httpManger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        __privatecyapi.sessionManager = _httpManger;
    });
    return __privatecyapi;
}

- (NSString *)urlStringWithMode:(NSString *)mod act:(NSString *)act
{
    return [API_BASE_URL stringByAppendingFormat:@"&mod=%@&act=%@",mod,act];
}

- (NSURLSessionDataTask *)LoginWithParameters:(id)parameters
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Login act:API_Mod_Login_login];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}

@end
