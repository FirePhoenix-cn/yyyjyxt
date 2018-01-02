//
//  LoginController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "LoginController.h"
#import "CYButton.h"
#import "MBProgressHUD+Add.h"
#import "RigisterController.h"
#import "PublicVarible.h"
#import "CYRootController.h"

@interface LoginController ()<UITextFieldDelegate>
@property (strong ,nonatomic)UITextField *NameField;
@property (strong ,nonatomic)UITextField *PassField;
@property (strong, nonatomic)MBProgressHUD *progressHud;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
    self.title = @"登录";
    
    [self initNaviItem];
    [self  initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.translucent = YES;
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

-(void)initNaviItem{

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 16.f, 16.f)];
    [btn setImage:[UIImage imageNamed:@"guanbifanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.navigationItem setRightBarButtonItem:[self baseTitleButtonItemWithTitle:@"注册" Sel:@selector(goRigisterPage) target:self]];
}

- (void)initViews {
    //添加输入文本框
    UITextField *NameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5.f, MainScreenWidth, 50.f)];
    NameField.placeholder = @"用户名/邮箱/手机";
    NameField.backgroundColor = [UIColor whiteColor];
    NameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
    NameField.leftViewMode = UITextFieldViewModeAlways;
    NameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserAccount];
    [self.view addSubview:NameField];
    _NameField = NameField;
    
    //添加输入图标
    UIButton *nameButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 21.f , 13, 18)];
    [nameButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shouji@2x"] forState:UIControlStateNormal];
    [self.view addSubview:nameButton];
    
    //添加密码文本框
    UITextField *PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 47.f, MainScreenWidth , 50)];
    PassField.placeholder = @"密码";
    PassField.backgroundColor = [UIColor whiteColor];
    PassField.secureTextEntry = YES;//密码形式
    PassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
    PassField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:PassField];
    _PassField = PassField;
    
    
    //添加密码图标
    UIButton *MMButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 63.f, 13, 18)];
    [MMButton setBackgroundImage:[UIImage imageNamed:@"iconfont-mima@2x"] forState:UIControlStateNormal];
    [self.view addSubview:MMButton];
    
    
    //添加登录按钮
    CYButton *DLButton = [CYButton buttonWithType:UIButtonTypeSystem];
    DLButton.frame = CGRectMake(20, 135.f, MainScreenWidth - 40, 45);
    [DLButton setTitle:@"登录" forState:UIControlStateNormal];
    [DLButton addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    DLButton.tag = 10;
    DLButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [DLButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DLButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    DLButton.layer.cornerRadius = 4;
    [self.view addSubview:DLButton];
    
    //添加忘记密码按钮
    UIButton *WJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, CGRectGetMaxY(DLButton.frame) + 30, 100, 20)];
    [WJButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    WJButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [WJButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [WJButton addTarget:self action:@selector(clickFindPwBtn:) forControlEvents:UIControlEventTouchUpInside];
    WJButton.tag = 20;
    [self.view addSubview:WJButton];
    
}

-(void)clickLoginBtn:(CYButton*)btn{
    if ([_NameField.text isEqual:@""] || _PassField.text.length < 6) {
        [MBProgressHUD showError:@"账号或密码不正确" toView:self.view];
        return;
    }
    [self.NameField resignFirstResponder];
    [self.PassField resignFirstResponder];
    [self LoginRequset];
}

-(void)clickFindPwBtn:(UIButton*)btn{
    //NSDictionary *dic = [self getLoginUserInfo];
    //NSLog(@"%@",dic);
}

- (void)LoginRequset {
    
    [self showProgressHud];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:self.NameField.text forKey:@"uname"];
    [dic setValue: self.PassField.text forKey:@"upwd"];
    [dic setValue:@"ios" forKey:@"edition"];
    WEAKFY
    [self.api LoginWithParameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakself.progressHud hide:YES];
        [weakself.myRootController setUserInfo:responseObject[@"data"]];
        [[NSUserDefaults standardUserDefaults] setObject:_NameField.text forKey:UserAccount];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakself back];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakself.progressHud hide:YES];
    }];
}



-(void)showProgressHud
{
    _progressHud = nil;
    _progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _progressHud.dimBackground = YES;
    _progressHud.labelText = @"正在登陆中...";
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.removeFromSuperViewOnHide = YES;
    [_progressHud hide:YES afterDelay:30];
}

-(void)back{
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.translucent = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goRigisterPage{
    RigisterController *vc = [[RigisterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
