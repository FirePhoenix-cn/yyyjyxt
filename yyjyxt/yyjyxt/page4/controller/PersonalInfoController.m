//
//  PersonalInfoViewController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/29.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "PersonalInfoController.h"
#import "CYRootController.h"
#import "UserInfoModel.h"
@interface PersonalInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImage *_image;
}
@property (weak, nonatomic) IBOutlet UIImageView *userFace;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UIButton *gendar;
@property (weak, nonatomic) IBOutlet UITextView *introduce;

@property (weak, nonatomic) IBOutlet UILabel *charNumberTip;

@end

@implementation PersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self initNavi];
    [self initViews];
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
-(void)initNavi{
    [self.navigationItem setLeftBarButtonItem:[self baseBackButtonItemWithSel:@selector(back) target:self]];
    [self.navigationItem setRightBarButtonItem:[self baseTitleButtonItemWithTitle:@"保存" Sel:@selector(saveInfo) target:self]];
}

-(void)initViews{
    _userFace.layer.cornerRadius = 40.f;
    _userFace.layer.masksToBounds = YES;

    if ([self.myRootController userinfoModel]) {
        _userFace.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.myRootController userinfoModel].userface]]];
    }
}
- (IBAction)clickUserface:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"修改头像" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册里选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
            [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerVC setAllowsEditing:YES];
            imagePickerVC.delegate=self;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
            [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePickerVC setAllowsEditing:YES];
            imagePickerVC.delegate=self;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [_userFace setImage:_image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickGendar:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"男"]) {
        [sender setTitle:@"女" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"男" forState:UIControlStateNormal];
    }
}

-(void)saveInfo{
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_introduce resignFirstResponder];
    [_nickName resignFirstResponder];
}
@end
