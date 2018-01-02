//
//  RigisterController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/29.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "RigisterController.h"
#import "MBProgressHUD+Add.h"
#import "CYButton.h"

@interface RigisterController ()<UITextFieldDelegate>

@property (strong ,nonatomic)UITextField *EmailField;

@property (strong ,nonatomic)UITextField *PassField;

@property (strong ,nonatomic)UITextField *IDField;

@property(nonatomic, strong) MBProgressHUD *progressHud1;

@property(nonatomic, strong) MBProgressHUD *progressHud2;
@end

@implementation RigisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
    self.title = @"注册";
    
    [self.navigationItem setLeftBarButtonItem:[self baseBackButtonItemWithSel:@selector(back) target:self]];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViews{

    //添加邮箱
    _EmailField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 5.f, MainScreenWidth, 50.f)];
    _EmailField.placeholder = @"手机号";
    _EmailField.delegate = self;
    UILabel *leftemail = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 50.f)];
    leftemail.text = @"*";
    leftemail.textAlignment = NSTextAlignmentCenter;
    leftemail.textColor = [UIColor redColor];
    _EmailField.leftView = leftemail;
    _EmailField.leftViewMode = UITextFieldViewModeAlways;
    _EmailField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_EmailField];
    
    //添加密码
    _PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 56.f, MainScreenWidth, 50)];
    _PassField.placeholder = @"密码";
    UILabel *leftpw = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _PassField.leftView = leftpw;
    leftpw.text = @"*";
    leftpw.textAlignment = NSTextAlignmentCenter;
    leftpw.textColor = [UIColor redColor];
    _PassField.leftViewMode = UITextFieldViewModeAlways;
    _PassField.backgroundColor = [UIColor whiteColor];
    _PassField.secureTextEntry = YES;//密码形式
    _PassField.delegate = self;
    [self.view addSubview:_PassField];
    
    _IDField = [[UITextField alloc] initWithFrame:CGRectMake(0, 107.f, MainScreenWidth, 50)];
    _IDField.placeholder = @"注册码(从管理员处获取的验证码)";
    UILabel *leftid = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    leftid.text = @"*";
    leftid.textAlignment = NSTextAlignmentCenter;
    leftid.textColor = [UIColor redColor];
    _IDField.leftView = leftid;
    _IDField.leftViewMode = UITextFieldViewModeAlways;
    _IDField.backgroundColor = [UIColor whiteColor];
    _IDField.returnKeyType = UIReturnKeyDone;
    _IDField.delegate = self;
    [self.view addSubview:_IDField];
    
    
    //添加按钮
    
    CYButton *TJButton = [[CYButton alloc] initWithFrame:CGRectMake(20, 209.f, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    TJButton.backgroundColor = NaviColor;
    TJButton.layer.cornerRadius = 4;
    TJButton.tag = 10086;
    [self.view addSubview:TJButton];
}

-(void)clickRegisterBtn:(CYButton*)btn{
    
    [_EmailField resignFirstResponder];
    [_PassField resignFirstResponder];
    [_IDField resignFirstResponder];
    [self showProgressHud1];
    WEAKFY
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:self.EmailField.text forKey:@"login"];
    [dic setValue:self.EmailField.text forKey:@"uname"];
    [dic setValue:self.PassField.text forKey:@"password"];
    [dic setValue:self.IDField.text forKey:@"idcard"];
    [dic setValue:@"2" forKey:@"type"];
    [dic setValue:@"ios" forKey:@"edition"];
    [self.api RegistWithParameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakself.progressHud1 hide:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakself.progressHud1 hide:YES];
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showProgressHud1
{
    _progressHud1 = nil;
    _progressHud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _progressHud1.dimBackground = YES;
    _progressHud1.labelText = @"正在注册中...";
    _progressHud1.mode = MBProgressHUDModeIndeterminate;
    _progressHud1.removeFromSuperViewOnHide = YES;
    [_progressHud1 hide:YES afterDelay:20];
}

-(void)showProgressHud2
{
    _progressHud2 = nil;
    _progressHud2 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _progressHud2.dimBackground = YES;
    _progressHud2.labelText = @"正在登陆中...";
    _progressHud2.mode = MBProgressHUDModeIndeterminate;
    _progressHud2.removeFromSuperViewOnHide = YES;
    [_progressHud2 hide:YES afterDelay:30];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqual:@""]) {
        [MBProgressHUD showError:@"用户信息不能为空" toView:self.view];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
