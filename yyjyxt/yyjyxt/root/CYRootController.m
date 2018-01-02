//
//  CYRootController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "CYRootController.h"
#import "PublicVarible.h"
#import "UserInfoModel.h"

static NSDictionary *__userinfo = nil;
static UserInfoModel *__userinfomodel=nil;

@interface CYRootController ()
@property(nonatomic,assign)LoginStatus loginStatus;
@end

@implementation CYRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.f, 40.f)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:NaviColor];
    [self SyncUserStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUserInfo:(NSDictionary*)json{
    __userinfo = json;
    if (json==nil) {
        __userinfomodel = nil;
        [self delCacheWithPath:UserInfoModelCachePath name:UserInfoModelCacheName];
        return;
    }
    [self addCache:json path:UserInfoModelCachePath name:UserInfoModelCacheName];
}

-(NSDictionary*)getUserInfo{
    if (__userinfo) {
        return __userinfo;
    }
    __userinfo = [self getAllCacheWithPath:UserInfoModelCachePath name:UserInfoModelCacheName];
    return __userinfo;
}

-(void)SyncUserStatus{
    
    if([self userinfoModel]){
        _loginStatus = LoginStatusLoginDone;
    }else{
        _loginStatus = LoginStatusLoginNone;
    }
}

-(LoginStatus)LoginStatus{
    [self SyncUserStatus];
    return _loginStatus;
}

-(void)addCache:(NSDictionary*)dic path:(NSString*)CachePath name:(NSString*)CacheName{
    NSString *tempes = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *path = [tempes stringByAppendingPathComponent:CachePath];
    YYCache *cache = [YYCache cacheWithPath:path];
    if (![cache containsObjectForKey:CacheName]) {
        UserInfoModel *info = [UserInfoModel yy_modelWithDictionary:dic];
        [cache setObject:info forKey:CacheName];
    }else{
        [cache removeObjectForKey:CacheName];
        UserInfoModel *info = [UserInfoModel yy_modelWithDictionary:dic];
        [cache setObject:info forKey:CacheName];
    }
}

-(void)delCacheWithPath:(NSString*)CachePath name:(NSString*)CacheName{
    NSString *tempes = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *path = [tempes stringByAppendingPathComponent:CachePath];
    YYCache *cache = [YYCache cacheWithPath:path];
    if ([cache containsObjectForKey:CacheName]) {
        [cache removeObjectForKey:CacheName];
    }
}

-(NSDictionary*)getAllCacheWithPath:(NSString*)CachePath name:(NSString*)CacheName{
    NSString *tempes = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *path = [tempes stringByAppendingPathComponent:CachePath];
    YYCache *cache = [YYCache cacheWithPath:path];
    if ([cache containsObjectForKey:CacheName]) {
        UserInfoModel *cls = (UserInfoModel*)[cache objectForKey:CacheName];
        NSDictionary *dic = [cls yy_modelToJSONObject];
        return dic;
    }
    return nil;
}

-(UserInfoModel*)userinfoModel{
    if (__userinfomodel) {
        return __userinfomodel;
    }
    NSString *tempes = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *path = [tempes stringByAppendingPathComponent:UserInfoModelCachePath];
    YYCache *cache = [YYCache cacheWithPath:path];
    if ([cache containsObjectForKey:UserInfoModelCacheName]) {
        UserInfoModel *cls = (UserInfoModel*)[cache objectForKey:UserInfoModelCacheName];
        __userinfomodel = cls;
    }
    return __userinfomodel;
}

@end
