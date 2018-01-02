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

-(NSURLSessionDataTask *)sendUserFace:(NSDictionary *)params
       constructing:(void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Login act:API_Mod_Login_login];
    return [_sessionManager POST:scheme parameters:params constructingBodyWithBlock:block progress:nil success:success failure:failure];
}
- (NSURLSessionDataTask *)LoginWithParameters:(id)parameters
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Login act:API_Mod_Login_login];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)RegistWithParameters:(id)parameters
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Login act:API_Mod_Login_regist];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}
- (NSURLSessionDataTask *)RegistFaceWithParameters:(id)parameters
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Youtu act:API_Mod_Youtu_newperson];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}
- (NSURLSessionDataTask *)ReRegistFaceWithParameters:(id)parameters
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Youtu act:API_Mod_Youtu_reFace];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}
- (NSURLSessionDataTask *)syncUserWithParameters:(id)parameters
                                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Youtu act:API_Mod_Youtu_syncUser];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}
- (NSURLSessionDataTask *)getSystimeWithParameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Youtu act:API_Mod_Youtu_getTime];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}
- (NSURLSessionDataTask *)getVersionWithParameters:(id)parameters
                                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *scheme = [self urlStringWithMode:API_Mod_Youtu act:API_Mod_Youtu_version];
    return [_sessionManager POST:scheme parameters:parameters progress:nil success:success failure:failure];
}
@end
