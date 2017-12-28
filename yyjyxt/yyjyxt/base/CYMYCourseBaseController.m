//
//  CYMYCourseBaseController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "CYMYCourseBaseController.h"
#import "MycourseController.h"
@interface CYMYCourseBaseController ()

@end

@implementation CYMYCourseBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MyCourse" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MycourseController class])];
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
