//
//  CYApi.h
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

@class AFHTTPSessionManager;

@interface CYApi : NSObject
+(CYApi*)SharedAPI;
-(NSURLSessionDataTask *)sendUserFace:(NSDictionary *)params
                         constructing:(void (^)(id <AFMultipartFormData> formData))block
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)LoginWithParameters:(id)parameters
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)RegistWithParameters:(id)parameters
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)RegistFaceWithParameters:(id)parameters
                                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)ReRegistFaceWithParameters:(id)parameters
                                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)syncUserWithParameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)getSystimeWithParameters:(id)parameters
                                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)getVersionWithParameters:(id)parameters
                                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
