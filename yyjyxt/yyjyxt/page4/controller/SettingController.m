//
//  SettingViewController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/29.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "SettingController.h"
#import "PersonalInfoController.h"
#import "UserInfoModel.h"
#import "CYRootController.h"
#import "LoginController.h"

static NSInteger _sectionCount = 5;

@interface SettingController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSString *_newversion;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
    self.title = @"个人设置";
    [self.navigationItem setLeftBarButtonItem:[self baseBackButtonItemWithSel:@selector(back) target:self]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.translucent = YES;
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    if (indexPath.section == _sectionCount-1) {
        return 60;
    }
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5.f;
    }
    if (section == _sectionCount-1) {//退出账号
        return 30.f;
    }
    return 10.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.sectionHeaderHeight, tableView.frame.size.width)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIImageView *userface = [[UIImageView alloc] init];
            userface.frame = CGRectMake(10, 15, 50, 50);
            userface.clipsToBounds = YES;
            [userface.layer setCornerRadius:25];
            userface.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.myRootController userinfoModel].userface]]];
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 200, 21)];
            lbl.text = [self.myRootController userinfoModel].uname;
            [cell addSubview:userface];
            [cell addSubview:lbl];
        }
        return cell;
    }else if(indexPath.section == 1)
    {
        static NSString *identifier = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 14, 125, 22)];
            numberLbl.text = @"修改密码";
            [cell addSubview:numberLbl];
        }
        return cell;
    }else if (indexPath.section == 2)
    {
        static NSString *identifier = @"Cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 14, 125, 22)];
            numberLbl.text = @"清除缓存";
            [cell addSubview:numberLbl];
            //添加缓存大小的按钮
            NSString *onePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
            NSInteger oneSize = [self fileSizeWithPath:onePath];
            
            NSString *twoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
            NSInteger twoSize = [self fileSizeWithPath:twoPath];
            NSInteger totaiZise = oneSize+twoSize;
            
            UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 0, 100, 40)];
            if (totaiZise > 1000*1000*10) {
                //不保留小数
                sizeLabel.text = [NSString stringWithFormat:@"%.ldM",totaiZise / 1000 / 1000];
            }else if (totaiZise > 1000*1000){
                //保留一位小数
                sizeLabel.text = [NSString stringWithFormat:@"%.1fM",totaiZise / 1000.0 / 1000.0];
            }else if(totaiZise > 1000*10){
                //保留两位小数
                sizeLabel.text = [NSString stringWithFormat:@"%.2fM",totaiZise / 1000.0 / 1000.0];
            }else {
                sizeLabel.text = @"0M";
            }
            sizeLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:sizeLabel];
            
        }
        return cell;
        
    }else if(indexPath.section == 3){
        static NSString *identifier = @"Cell4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 14, self.view.frame.size.width/2-17, 22)];
            NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
            NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
            
            numberLbl.text = [NSString stringWithFormat:@"当前版本：%@",localVersion];
            [cell addSubview:numberLbl];
        }
        return cell;
    }
    if(indexPath.section == 4 && _sectionCount==6){
        static NSString *identifiers = @"Cells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiers];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifiers];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = _newversion;
            cell.detailTextLabel.text = @"点击更新";
        }
        return cell;
    }
    if (indexPath.section == _sectionCount-1) {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1];
            UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2+20, (60-21)/2, 100, 21)];
            numberLbl.textColor = [UIColor whiteColor];
            numberLbl.text = @"退出账号";
            [cell addSubview:numberLbl];
        }
        return cell;
    }
    
    return nil;
}


-(NSInteger)integerVersion:(NSString*)version{
    
    NSArray* strs = [version componentsSeparatedByString:@"."];
    NSInteger intVersion = 0;
    if (strs.count == 2) {
        intVersion = [strs[0] integerValue]*100 + [strs[1] integerValue]*10;
    }else if (strs.count ==3){
        intVersion = [strs[0] integerValue]*100 + [strs[1] integerValue]*10 + [strs[2] integerValue];
    }
    return intVersion;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([PersonalInfoController class])];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            
        }
            break;
        case 2:
        {
        

        }
            break;
            
        case 3:{
        }break;
            
        case 4:
        {
            if (_sectionCount==5) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"是否确定退出登录？" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.myRootController setUserInfo:nil];
                    LoginController *vc = [[LoginController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
            }else{
                NSString *str = @"https://itunes.apple.com/cn/app/id1329452618?l=en&mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
