//
//  LoginController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "LoginController.h"
#import "CYButton.h"
#import "PublicVarible.h"
#import "MBProgressHUD+Add.h"
#import "UserInfoModel.h"


@interface LoginController ()
@property (strong ,nonatomic)UITextField *NameField;
@property (strong ,nonatomic)UITextField *PassField;
@property (strong, nonatomic)MBProgressHUD *progressHud;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"guanbifanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationController.navigationItem.leftBarButtonItem = leftBackBtn;
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
    [self  initViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.translucent = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSDictionary *dic = [self getAllCacheWithPath:UserInfoModelCachePath name:UserInfoModelCacheName];
    NSLog(@"%@",dic);
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
        [weakself addCache:responseObject[@"data"] path:UserInfoModelCachePath name:UserInfoModelCacheName];
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakself.progressHud hide:YES];
    }];
    /*[self.api userLogin:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[(UIButton*)[self.view viewWithTag:10] setTitle:@"登录" forState:UIControlStateNormal];
        [_progressHud hide:YES];
        base = [BaseClass modelObjectWithDictionary:responseObject];
        if ([[responseObject objectForKey:@"data"] count]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.NameField.text forKey:CYUSERACCOUNTCACHENAME];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.kh_company_id forKey:@"kh_cpmpany_id"];
            if (![base.data.companyid isEqualToString:@"0"]) {
                [[NSUserDefaults standardUserDefaults] setObject:base.data.companyid forKey:@"companyid"];
            }
            if (![base.data.faceId isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults]setObject:base.data.faceId forKey:CYHadFaceIdentifier];
            }
            if (![base.data.faceImg isEqualToString:@""]) {
                NSString *imgurl = [NSString stringWithFormat:@"http://%@",EDULINEURLLOCAL];
                [[NSUserDefaults standardUserDefaults]setObject:[imgurl stringByAppendingString:base.data.faceImg] forKey:CYFACEIMAGEURL];
            }
        }
        
        if (base.code == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMainPage" object:nil];
            
            //在登录成功的地方将数据保存下来
            [[NSUserDefaults standardUserDefaults] setObject:self.NameField.text forKey:@"uname"];
            [[NSUserDefaults standardUserDefaults] setObject:self.PassField.text forKey:@"upwd"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.typeStr isEqualToString:@"123"]) {//从设置页面过来
                    MyViewController *myVC = [[MyViewController alloc] init];
                    [self.navigationController pushViewController:myVC animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserPage" object:nil];
                } else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserPage" object:nil];
                }
            });
            
        }else
        {
            [_progressHud hide:YES];
            //[(UIButton*)[self.view viewWithTag:10] setTitle:@"登录" forState:UIControlStateNormal];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:base.msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_progressHud hide:YES];
        //[(UIButton*)[self.view viewWithTag:10] setTitle:@"登录" forState:UIControlStateNormal];
    }];*/
    
    
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

-(void)addCache:(NSDictionary*)dic path:(NSString*)CachePath name:(NSString*)CacheName{
    NSString *tempes = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *path = [tempes stringByAppendingPathComponent:CachePath];
    YYCache *cache = [YYCache cacheWithPath:path];
    if (![cache containsObjectForKey:CacheName]) {
        UserInfoModel *info = [UserInfoModel yy_modelWithDictionary:dic];
        [cache setObject:info forKey:CacheName];
    }else{
        [cache removeObjectForKey:CacheName];
        UserInfoModel *info = [UserInfoModel yy_modelWithDictionary:dic];
        [cache setObject:info forKey:CacheName];
    }
}

-(NSDictionary*)getAllCacheWithPath:(NSString*)CachePath name:(NSString*)CacheName{
    NSString *tempes = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *path = [tempes stringByAppendingPathComponent:CachePath];
    YYCache *cache = [YYCache cacheWithPath:path];
    if ([cache containsObjectForKey:CacheName]) {
        UserInfoModel *cls = (UserInfoModel*)[cache objectForKey:CacheName];
        NSDictionary *dic = [cls yy_modelToJSONObject];
        return dic;
    }
    return nil;
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
