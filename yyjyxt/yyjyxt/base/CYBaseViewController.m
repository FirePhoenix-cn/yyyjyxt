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

- (NSInteger)fileSizeWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *subPaths = [manager subpathsAtPath:path];
    NSInteger totalBySize = 0;
    for (NSString *subPath in subPaths) {
        NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
        BOOL dir = NO;//判断是否为文件
        [manager fileExistsAtPath:fullSubPath isDirectory:&dir];
        
        if (dir == NO) {//文件
            totalBySize += [[manager attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
        }
    }
    
    return totalBySize;
}

-(UIBarButtonItem*)baseTitleButtonItemWithTitle:(NSString*)title Sel:(SEL)sel target:(id)target{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 30.f)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *baseItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return baseItem;
}

-(UIBarButtonItem*)baseBackButtonItemWithSel:(SEL)sel target:(id)targert{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
    [btn setImage:[UIImage imageNamed:@"baseback"] forState:UIControlStateNormal];
    [btn addTarget:targert action:sel forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    return backItem;
}

@end
