//
//  CYRootController.h
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginStatus) {
    LoginStatusLoginDone=0,//已登录
    LoginStatusLoginNone,//未登录
    LoginStatusLoginTour,//游客登录
};

@interface CYRootController : UITabBarController

-(LoginStatus)LoginStatus;

@end
