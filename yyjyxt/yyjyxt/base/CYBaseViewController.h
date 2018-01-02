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
- (NSInteger)fileSizeWithPath:(NSString *)path;
-(UIBarButtonItem*)baseBackButtonItemWithSel:(SEL)sel target:(id)targert;
-(UIBarButtonItem*)baseTitleButtonItemWithTitle:(NSString*)title Sel:(SEL)sel target:(id)target;
@end
