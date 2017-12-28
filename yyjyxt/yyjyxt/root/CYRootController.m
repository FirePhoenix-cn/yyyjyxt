//
//  CYRootController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "CYRootController.h"
#import "PublicVarible.h"


@interface CYRootController ()
@property(nonatomic,assign)LoginStatus loginStatus;
@end

@implementation CYRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.f, 40.f)];
    [[UINavigationBar appearance] setBarTintColor:NaviColor];
    [self SyncUserStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SyncUserStatus{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if([userdefault objectForKey:UserIdKey]){
        _loginStatus = LoginStatusLoginDone;
    }else{
        _loginStatus = LoginStatusLoginNone;
    }
}

-(LoginStatus)LoginStatus{
    return _loginStatus;
}

@end
