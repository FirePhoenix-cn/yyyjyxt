//
//  CYBaseViewController.h
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYApi.h"
@class CYRootController;
@interface CYBaseViewController : UIViewController
@property(nonatomic,strong)CYRootController *myRootController;
@property(nonatomic, strong)CYApi *api;
-(void)addCache:(NSDictionary*)dic path:(NSString*)CachePath name:(NSString*)CacheName;
-(NSDictionary*)getAllCacheWithPath:(NSString*)CachePath name:(NSString*)CacheName;
@end
