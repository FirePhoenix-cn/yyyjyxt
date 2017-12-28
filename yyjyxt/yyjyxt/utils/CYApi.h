//
//  CYApi.h
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

@interface CYApi : NSObject
+(CYApi*)SharedAPI;

- (NSURLSessionDataTask *)LoginWithParameters:(id)parameters
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
