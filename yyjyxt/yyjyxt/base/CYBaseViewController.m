//
//  CYBaseViewController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "CYBaseViewController.h"
#import "CYRootController.h"


@interface CYBaseViewController ()

@end

@implementation CYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myRootController = (CYRootController*)self.tabBarController;
    _api = [CYApi SharedAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
