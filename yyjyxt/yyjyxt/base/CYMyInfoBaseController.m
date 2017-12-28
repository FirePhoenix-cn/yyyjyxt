//
//  CYMyInfoBaseController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "CYMyInfoBaseController.h"
#import "MineController.h"
@interface CYMyInfoBaseController ()

@end

@implementation CYMyInfoBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MineController class])];
    self.viewControllers = @[vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
