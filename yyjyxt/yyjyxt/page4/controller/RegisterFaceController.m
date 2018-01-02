//
//  RegisterFaceController.m
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/29.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import "RegisterFaceController.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+ReByte.h"
#import "NSData+Base64.h"
#import "CYRootController.h"
#import "UserInfoModel.h"
#import "PureCamera.h"
#import "CYErrorType.h"
#import "PublicVarible.h"

@interface RegisterFaceController ()
{
    UIImage *_image;
    CGRect _imageViewFrame;
    CGFloat _maxImageHeight;
    NSString* _faceimageUrl;
}
@property(nonatomic, strong) UIImageView *imgVIew;
@property(nonatomic, strong) UIButton *takeAndSend;
@property(nonatomic, strong) MBProgressHUD *progressHud;
@end

@implementation RegisterFaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"人脸扫描";
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

-(void)initNavi{
    [self.navigationItem setLeftBarButtonItem:[self baseBackButtonItemWithSel:@selector(backPressed) target:self]];
    if (![[self.myRootController userinfoModel].face_id isEqualToString:@""]) {
        [self.navigationItem setRightBarButtonItem:[self baseTitleButtonItemWithTitle:@"重新注册" Sel:@selector(clickReTakeAndSend:) target:self]];
    }
    
}

-(void)initViews{
    CGFloat btnWidth = MainScreenWidth / 3.f;
    CGFloat btnHeight = 40.f;
    CGFloat mainviewheight = MainScreenHeight-64.f;
    CGFloat imgviewY = (MainScreenHeight-64.f-60.f-MainScreenWidth)*0.5f;
    _imgVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgviewY, MainScreenWidth, MainScreenWidth)];
    _imageViewFrame = _imgVIew.frame;
    _maxImageHeight = mainviewheight - 20 - 20 - 60;
    
    _takeAndSend = [UIButton buttonWithType:UIButtonTypeCustom];
    _takeAndSend.frame = CGRectMake((MainScreenWidth - btnWidth) / 2.0, mainviewheight - 60.f, btnWidth, btnHeight);
    _takeAndSend.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [_takeAndSend setTitle:@"拍照注册" forState:UIControlStateNormal];
    [_takeAndSend setTintColor:[UIColor whiteColor]];
    [_takeAndSend addTarget:self action:@selector(clickTakeAndSend:) forControlEvents:UIControlEventTouchUpInside];
    _takeAndSend.layer.cornerRadius = 5;
    _takeAndSend.layer.masksToBounds = YES;
    [self.view addSubview:_takeAndSend];
    
    if (![[self.myRootController userinfoModel].face_id isEqualToString:@""]) {
        NSString *url = [[NSString stringWithFormat:@"http://%@",BaseUrl] stringByAppendingString:[self.myRootController userinfoModel].face_img];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        [self fixImageViewFrameWithImage:img];
        _imgVIew.image = img;
        [_takeAndSend setTitle:@"已注册" forState:UIControlStateNormal];
        [_takeAndSend setUserInteractionEnabled:NO];
    }else{
        _imgVIew.image = [UIImage imageNamed:@"blank"];
    }
    [self.view addSubview:_imgVIew];
}

-(void)showProgressHud:(NSString*)text
{
    _progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _progressHud.dimBackground = YES;
    if (!text || [text isEqualToString:@""]) {
        _progressHud.labelText = @"正在注册...";
    }else
    {
        _progressHud.labelText = text;
    }
    
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.removeFromSuperViewOnHide = YES;
    [_progressHud hide:YES afterDelay:10];
}

-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickReTakeAndSend:(UIButton*)btn
{
    WEAKFY
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重新注册人脸" message:@"重新注册成功后将会删除之前注册的人脸，且一段时间内只能重新注册一次，是否继续？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            PureCamera *homec = [[PureCamera alloc] init];
            homec.fininshcapture = ^(UIImage *ss) {
                if (ss) {
                    _image = ss;
                    [weakself fixImageViewFrameWithImage:_image];
                    weakself.imgVIew.image = _image;
                    
                    [weakself reFace];
                    
                }
            };
            [weakself presentViewController:homec animated:NO completion:nil];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}

- (void)clickTakeAndSend:(UIButton*)btn
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PureCamera *homec = [[PureCamera alloc] init];
        WEAKFY
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                _image = ss;
                _image = [self fixOrientation:_image];
                _image = [self flipImage:_image];
                [weakself fixImageViewFrameWithImage:_image];
                weakself.imgVIew.image = _image;
                [weakself registerFace];
                
            }
        };
        [weakself presentViewController:homec animated:NO completion:nil];
    }
    
}


-(UIImage*)flipImage:(UIImage*)aImage
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
    transform = CGAffineTransformScale(transform, -1, 1);
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(void)fixImageViewFrameWithImage:(UIImage*)img
{
    CGSize size = img.size;
    _imgVIew.frame = _imageViewFrame;
    if (size.width != size.height) {
        CGRect frame = _imageViewFrame;
        frame.size.height = size.height;
        frame.size.width = size.width;
        if (frame.size.width > MainScreenSize.width) {
            
            frame.size.width = MainScreenSize.width;
            frame.size.height = size.height / size.width * frame.size.width;
        }
        if (frame.size.height > _maxImageHeight) {
            frame.size.height = _maxImageHeight;
            frame.size.width = size.width / size.height * frame.size.height;
        }
        
        frame.origin.x = (MainScreenSize.width - frame.size.width) / 2.0;
        frame.origin.y = 64 + (MainScreenSize.height - 64 - 60 - frame.size.height) / 2.0;
        _imgVIew.frame = frame;
    }
}

-(void)reFace
{
    if (!_image) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressHud:@"重新注册中..."];
    });
    WEAKFY
    NSData *imageData = [_image adaptionImgData];
    NSString *encodingString = [imageData base64String];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *decodestring = [NSString stringWithFormat:@"uid:%@|systime:%li|edition:ios",[weakself.myRootController userinfoModel].uid,(long)[AppDelegate delegate].currentTime];
    NSString *encodestring = [[decodestring dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    encodestring = [encodestring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [dic setValue:encodestring forKey:@"data"];
    [dic setValue:encodingString forKey:@"faceimg"];
    [self.api ReRegistFaceWithParameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakself.progressHud hide:YES];
        if ([[responseObject objectForKey:@"code"] integerValue] == -1) {
            [MBProgressHUD showError:responseObject[@"msg"] toView:weakself.view];
        }else{
            [weakself sendUserFace];
            [MBProgressHUD showSuccess:responseObject[@"msg"] toView:weakself.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakself.progressHud hide:YES];
        [MBProgressHUD showError:@"重新注册失败" toView:weakself.view];
    }];
}

-(void)registerFace
{
    if (!_image) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.takeAndSend.userInteractionEnabled = NO;
        [self.takeAndSend setTitle:@"注册中..." forState:UIControlStateNormal];
        [self showProgressHud:@""];
    });
    WEAKFY
    NSData *imageData = [_image adaptionImgData];
    NSString *encodingString = [imageData base64String];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *decodestring = [NSString stringWithFormat:@"uid:%@|systime:%li|edition:ios",[weakself.myRootController userinfoModel].uid,(long)((AppDelegate*)[UIApplication sharedApplication].delegate).currentTime];
    NSString *encodestring = [[decodestring dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    encodestring = [encodestring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [dic setValue:encodestring forKey:@"data"];
    [dic setValue:encodingString forKey:@"faceimg"];
    [self.api RegistFaceWithParameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakself.progressHud hide:YES];
        if ([[responseObject objectForKey:@"code"] integerValue] > 0) {
            [MBProgressHUD showError:@"注册失败" toView:weakself.view];
        }else{
            if ([[[[responseObject objectForKey:@"data"] objectForKey:@"errorcode"] stringValue] isEqualToString:@"0"]) {
                [weakself sendUserFace];
                [MBProgressHUD showSuccess:@"注册成功" toView:weakself.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakself.takeAndSend.userInteractionEnabled = NO;
                    [weakself.takeAndSend setTitle:@"已注册" forState:UIControlStateNormal];
                });
                
            }else
            {
                if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    [MBProgressHUD showSuccess:[CYErrorType errorDescriptionWithCode:[[[responseObject objectForKey:@"data"] objectForKey:@"errorcode"] stringValue]] toView:weakself.view];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakself.progressHud hide:YES];
        weakself.takeAndSend.userInteractionEnabled = YES;
        [MBProgressHUD showError:@"注册失败" toView:weakself.view];
    }];
}

-(void)sendUserFace
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[self.myRootController userinfoModel].oauth_token forKey:@"oauth_token"];
    [dic setObject:[self.myRootController userinfoModel].oauth_token_secret forKey:@"oauth_token_secret"];
    [dic setObject:[self.myRootController userinfoModel].uid forKey:@"user_id"];
    [self.api sendUserFace:dic constructing:^(id <AFMultipartFormData>formData) {
        NSData *dataImg=UIImageJPEGRepresentation(_image, 0.6);
        NSString *baseStr = [dataImg base64String];
        [formData appendPartWithFileData:dataImg name:baseStr fileName:[NSString stringWithFormat:@"%@.png",baseStr] mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
