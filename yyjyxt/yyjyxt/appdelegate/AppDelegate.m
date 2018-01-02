//
//  AppDelegate.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyBoardManager.h"
#import "ELAlertView.h"
#import "CYRootController.h"
#import <AVFoundation/AVFoundation.h>
#import "CYApi.h"
#import "UserInfoModel.h"
#import "LoginController.h"
@interface AppDelegate ()
{
    NSInteger _updateSystemTimeTimeoutCount;
    NSInteger _obtainAppVersionTimeoutCount;
    BOOL _canshowalert;
}
@property(strong, nonatomic) CYRootController *rootVC;
@property(nonatomic, strong) NSTimer *systemTimeUpdateTimer;
@property(nonatomic, strong) ELAlertView *alertView;
@end

@implementation AppDelegate
{
    NSTimeInterval _lastRecordTime;
}

+(AppDelegate *)delegate
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

-(void)showAlertWith:(NSString*)title Message:(NSString*)msg actions:(NSArray<ELAlertAction*>*)acts{
    // Create an instance
    if (_alertView) {
        [_alertView close];
    }
    _alertView = nil;
    _alertView = [[ELAlertView alloc] initWithStyle:ELAlertViewStyleDefault];
    _alertView.title   = title;
    _alertView.message = msg;
    
    // Custom your appearance
    _alertView.titleTopMargin = 17;
    _alertView.messageLeadingAndTrailingPadding = 20;
    _alertView.messageAlignment = NSTextAlignmentLeft;
    _alertView.messageHeight = 80;
    _alertView.alertViewBackgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    _alertView.titleColor = [UIColor whiteColor];
    _alertView.messageColor =[UIColor whiteColor];
    _alertView.buttonBottomMargin = 30;
    // Add alert actions
    for (ELAlertAction *act in acts) {
        [_alertView addAction:act];
    }
    // Show the alertView
    [_alertView show];
}

-(void)fuckTimeCrash
{
    if ((long)self.currentTime % 30 == 0) {
        [self syncUser];
    }
    self.currentTime += 1.0;
    if ((self.currentTime - _lastRecordTime) == 600.0) {
        [self getSeverSystemTime];
    }
}
-(void)syncUser{
    if ([_rootVC userinfoModel]) {
        NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
        NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *decodestring = [NSString stringWithFormat:@"uid:%@|systime:%li|edition:ios|version:%@",[_rootVC userinfoModel].uid,(long)_currentTime,localVersion];
        NSString *encodestring = [[decodestring dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        encodestring = [encodestring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [dic setValue:encodestring forKey:@"data"];
        [[CYApi SharedAPI] syncUserWithParameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

-(void)statusGetError{
    if (!_canshowalert) {
        return;
    }
    _canshowalert = NO;
    ELAlertAction *act = [ELAlertAction actionWithTitle:@"稍后再试" style:ELAlertActionStyleDestructive handler:^(ELAlertAction *action) {
        _canshowalert = YES;
    }];
    [self showAlertWith:@"出错啦" Message:@"抱歉，您的账号出错啦，请联系管理员！" actions:@[act]];
}

-(NSDictionary*)getDicData:(NSString*)codedStr
{
    NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:codedStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* strs = [string componentsSeparatedByString:@"|"];
    for (NSString *str in strs) {
        NSArray *arr = [str componentsSeparatedByString:@":"];
        [dicts setValue:arr[1] forKey:arr[0]];
    }
    return dicts.copy;
}

-(void)getSeverSystemTime//获取服务器时间
{
    __weak typeof(self) weakSelf = self;
    [[CYApi SharedAPI] getSystimeWithParameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![[responseObject objectForKey:@"data"] isKindOfClass:[NSString class]])
        {
            //失败
            if (_updateSystemTimeTimeoutCount != 0) {
                _updateSystemTimeTimeoutCount --;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf getSeverSystemTime];
                });
            }else{
                [weakSelf connectServerFailedWith:@"同步服务器失败" msg:@"您未能与服务器时间同步！"];
            }
        }else
        {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:[responseObject objectForKey:@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSTimeInterval newsystime = [str doubleValue];
            if (weakSelf.currentTime > 1) {
                //验证
                if (labs((long)(weakSelf.currentTime - newsystime)) > 600) {
                    //系统时间出错
                    [weakSelf.systemTimeUpdateTimer invalidate];
                    weakSelf.systemTimeUpdateTimer = nil;
                    [self errorSystemTimeHander];
                }else
                {
                    weakSelf.currentTime = newsystime;
                    _lastRecordTime = weakSelf.currentTime;
                    if (weakSelf.systemTimeUpdateTimer) {
                        [weakSelf.systemTimeUpdateTimer invalidate];
                        weakSelf.systemTimeUpdateTimer = nil;
                    }
                    weakSelf.systemTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fuckTimeCrash) userInfo:nil repeats:YES];
                    if ((long)weakSelf.currentTime % 30 != 0) {
                        [weakSelf syncUser];
                    }
                }
            }else
            {
                weakSelf.currentTime = newsystime;
                _lastRecordTime = weakSelf.currentTime;
                if (weakSelf.systemTimeUpdateTimer) {
                    [weakSelf.systemTimeUpdateTimer invalidate];
                    weakSelf.systemTimeUpdateTimer = nil;
                }
                weakSelf.systemTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fuckTimeCrash) userInfo:nil repeats:YES];
                if ((long)weakSelf.currentTime % 30 == 0) {
                    [weakSelf syncUser];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_updateSystemTimeTimeoutCount != 0) {
            _updateSystemTimeTimeoutCount --;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf getSeverSystemTime];
            });
            
        }else
        {
            [weakSelf connectServerFailedWith:@"同步服务器失败" msg:@"您似乎与服务器断开连接了，请检查网络后重试！"];
        }
    }];
}

-(BOOL)isLegalVersion:(NSString*)version{
    
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
    NSInteger intlocalVersion = [self integerVersion:localVersion];
    NSInteger intVersion = [self integerVersion:version];
    if (intlocalVersion < intVersion) {
        return NO;
    }
    return YES;
}

-(NSInteger)integerVersion:(NSString*)version{
    
    NSArray* strs = [version componentsSeparatedByString:@"."];
    NSInteger intVersion = 0;
    if (strs.count == 2) {
        intVersion = [strs[0] integerValue]*100 + [strs[1] integerValue]*10;
    }else if (strs.count ==3){
        intVersion = [strs[0] integerValue]*100 + [strs[1] integerValue]*10 + [strs[2] integerValue];
    }
    return intVersion;
}

-(void)getSysTemInfo
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@"ios" forKey:@"edition"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"])
    {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"] forKey:@"uid"];
    }
    [[CYApi SharedAPI] getVersionWithParameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicts = [weakSelf getDicData:[responseObject objectForKey:@"data"]];
        if ([dicts[@"isdel"] isEqualToString:@"1"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[responseObject objectForKey:@"msg"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LoginController *vc = [[LoginController alloc] init];
                    [_rootVC setUserInfo:nil];
                    [_rootVC presentViewController:vc animated:YES completion:nil];
                });
            }]];
            [self.rootVC presentViewController:alert animated:YES completion:nil];
        }else if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSString class]]) {
            if (![self isLegalVersion:dicts[@"version"]]) {
                [weakSelf lowVersionHander:@"版本过低" msg:@"为保证您正常使用，请前往升级应用！"];
            }
        }else
        {
            if (_obtainAppVersionTimeoutCount != 0) {
                _obtainAppVersionTimeoutCount --;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf getSysTemInfo];
                });
            }else
                [weakSelf connectServerFailedWith:@"同步服务器失败" msg:@"服务器未能检测到您应用的版本信息！"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (_obtainAppVersionTimeoutCount != 0) {
            _obtainAppVersionTimeoutCount --;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf getSysTemInfo];
            });
        }else{
            [weakSelf connectServerFailedWith:@"同步服务器失败" msg:@"您似乎与服务器断开连接了，请检查网络后重试！"];
        }
    }];
    
}

-(void)connectServerFailedWith:(NSString*)err msg:(NSString*)msg
{
    if (!_canshowalert) {
        return;
    }
    _canshowalert = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"systemErrorToSyopPlay" object:nil];
    ELAlertAction *act = [ELAlertAction actionWithTitle:@"重新连接" style:ELAlertActionStyleDestructive handler:^(ELAlertAction *action) {
        _canshowalert = YES;
        _obtainAppVersionTimeoutCount = 3;
        [self getSysTemInfo];
        _updateSystemTimeTimeoutCount = 3;
        [self getSeverSystemTime];
    }];
    [self showAlertWith:err Message:msg actions:@[act]];
}

-(void)lowVersionHander:(NSString*)err msg:(NSString*)msg
{
    if (!_canshowalert) {
        return;
    }
    _canshowalert = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"systemErrorToSyopPlay" object:nil];
    ELAlertAction *act = [ELAlertAction actionWithTitle:@"去升级" style:ELAlertActionStyleDestructive handler:^(ELAlertAction *action) {
        _canshowalert = YES;
        NSString *str = @"https://itunes.apple.com/cn/app/id1329452618?l=en&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [self showAlertWith:err Message:msg actions:@[act]];
}

//发现时间错误
-(void)errorSystemTimeHander
{
    if (!_canshowalert ) {
        return;
    }
    _canshowalert = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"systemErrorToSyopPlay" object:nil];
    ELAlertAction *act = [ELAlertAction actionWithTitle:@"重新获取" style:ELAlertActionStyleDestructive handler:^(ELAlertAction *action) {
        self.currentTime = 0;
        _canshowalert = YES;
        _updateSystemTimeTimeoutCount = 3;
        [self getSeverSystemTime];
    }];
    [self showAlertWith:@"系统发生错误" Message:@"您的系统时间与服务器时间相差太大，不能继续学习！" actions:@[act]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES;
    //[IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    _currentTime = [[NSDate date] timeIntervalSince1970];
    _rootVC = (CYRootController*)self.window.rootViewController;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status != AVAuthorizationStatusAuthorized){
        //获取权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
        }];
    }
    _updateSystemTimeTimeoutCount = 3;
    _obtainAppVersionTimeoutCount = 3;
    [self getSeverSystemTime];
    [self getSysTemInfo];
    _canshowalert = YES;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.systemTimeUpdateTimer invalidate];
    self.systemTimeUpdateTimer = nil;
    if (!_canshowalert) {
        [_alertView close];
        _canshowalert = YES;
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    _updateSystemTimeTimeoutCount = 3;
    _obtainAppVersionTimeoutCount = 3;
    self.currentTime = [[NSDate date] timeIntervalSince1970];
    [self getSeverSystemTime];
    [self getSysTemInfo];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
