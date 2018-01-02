//
//  MineController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "MineController.h"
#import "CYRootController.h"
#import "LoginController.h"
#import "UserInfoModel.h"
#import "SettingController.h"
#import "RegisterFaceController.h"
#import "PersonalInfoController.h"

@interface MineController ()
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userface;
@property (weak, nonatomic) IBOutlet UIImageView *topBackgroud;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.translucent = NO;
    [super viewWillAppear:animated];
    [self SyncLoginStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initViews{
    _userface.layer.cornerRadius = _userface.frame.size.height * 0.5f;
    _userface.layer.borderWidth = 1.f;
    _userface.layer.borderColor = [[UIColor whiteColor] CGColor];
    _userface.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5.f;
    _loginBtn.layer.masksToBounds = YES;
    [self addButtons];
    [self SyncLoginStatus];
}

-(void)SyncLoginStatus{
    switch ([self.myRootController LoginStatus]) {
        case LoginStatusLoginDone:
        {
            _loginBtn.hidden = YES;
            _settingBtn.hidden = NO;
            _userName.hidden = NO;
            _userName.text = [self.myRootController userinfoModel].uname;
            _userface.image = [UIImage imageNamed:@"defaultuserface.jpg"];
            _userface.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.myRootController userinfoModel].userface]]];
        }
            break;
            
        case LoginStatusLoginNone:
        {
            _loginBtn.hidden = NO;
            _settingBtn.hidden = YES;
            _userName.hidden = YES;
            _userface.image = [UIImage imageNamed:@"defaultuserface.jpg"];
        }
            break;
        default:
            break;
    }
}

- (void)addButtons{
    
    //添加整个View
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    SYGView.backgroundColor = [UIColor colorWithRed:245.f / 255 green:246.f / 255 blue:247.f / 255 alpha:1];
    SYGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:SYGView];
    SYGView.userInteractionEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    CGFloat Bwidth = 35;
    CGFloat width = MainScreenWidth / 3 ;
    CGFloat spare = (MainScreenWidth / 3 - Bwidth) / 2;
    NSArray *SYGArray = @[@"全部问答",@"我的笔记",@"我的收藏",@"我的问答",@"学习记录",@"我的试卷",@"人脸扫描"/*,@"考试安排",@"我要上船"*/];
    NSArray *TBArray = @[@"qbwd",@"wdbj",@"wdsc",@"wdwd",@"xxjl",@"wdsj",@"rlsm"/*,@"ksap",@"wysc"*/];
    for (int i = 0 ; i < SYGArray.count ; i ++) {
        UIButton *TBButton = [[UIButton alloc] initWithFrame:CGRectMake(spare +MainScreenWidth / 3 * (i % 3) , 130 * (i / 3) + 20 , Bwidth, Bwidth)];
        [TBButton setBackgroundImage:[UIImage imageNamed:TBArray[i]] forState:UIControlStateNormal];
        [SYGView addSubview:TBButton];
        //添加文字
        UILabel *WZLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * (i % 3) ,50 + 20 + (i / 3) * 130 ,width,20)];
        WZLabel.text = SYGArray[i];
        WZLabel.textAlignment = NSTextAlignmentCenter;
        WZLabel.font = [UIFont systemFontOfSize:12];
        [SYGView addSubview:WZLabel];
        //添加透明的按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * (i % 3), 130 * (i / 3), width, 130)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+1;
        [button addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        [SYGView addSubview:button];
    }
    UIButton *lastbtn = [SYGView viewWithTag:7];
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(lastbtn.frame)+30);
}

- (void)clickbutton:(UIButton *)button {
    //判断是否登录
    if ([self.myRootController LoginStatus]==LoginStatusLoginNone) {//没有登录的情况下
        
    }else {//已经登录
        /*if (button.tag == 0) {//说明是直
         MyLiveViewController *ZJVC = [[MyLiveViewController alloc] init];
         [self.navigationController pushViewController:ZJVC animated:YES];
         }*/
        if (button.tag == 1) {//说明是课程
            //KCViewController *KCVC = [[KCViewController alloc] init];
            //[self.navigationController pushViewController:KCVC animated:YES];
            
        }
        if (button.tag == 2) {//说明是笔记
            
        }
        if (button.tag == 3) {//说明是收藏
           
        }
        /*if (button.tag == 4) {//说明是购物车
         JYJLViewController *JYJLVC =  [[JYJLViewController alloc] init];
         [self.navigationController pushViewController:JYJLVC animated:YES];
         }*/
        if (button.tag == 4) {//说明是问答
            
        }
        if (button.tag == 5) {//学习记录
            
        }
        if (button.tag == 6) {
            
        }
        if (button.tag == 7) {
            RegisterFaceController *vc = [[RegisterFaceController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (IBAction)clickUserface:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([PersonalInfoController class])];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickLoginBtn:(UIButton *)sender {
    LoginController *vc = [LoginController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
