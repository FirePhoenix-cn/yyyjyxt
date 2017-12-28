//
//  UserInfoModel.h
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "YYCache.h"

@interface UserInfoModel : NSObject<NSCoding,NSCopying,YYModel>
@property (nonatomic, strong) NSString *allow_id;
@property (nonatomic, strong) NSString *api_key;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *bj_face_status;
@property (nonatomic, strong) NSString *bj_false_count;
@property (nonatomic, strong) NSString *bj_identify_code;
@property (nonatomic, strong) NSString *bj_identify_status;
@property (nonatomic, assign) NSString *bj_sideface_status;
@property (nonatomic, strong) NSString *bj_verify_status;
@property (nonatomic, strong) NSString *canliveverifytime;
@property (nonatomic, assign) NSString *chargeback_time;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *edition;
@property (nonatomic, assign) NSString *face_id;
@property (nonatomic, strong) NSString *face_img;
@property (nonatomic, strong) NSString *face_or;
@property (nonatomic, strong) NSString *face_reg_time;
@property (nonatomic, strong) NSString *find_study_level;
@property (nonatomic, strong) NSString *first_letter;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, assign) NSString *is_active;
@property (nonatomic, strong) NSString *is_audit;
@property (nonatomic, strong) NSString *is_del;
@property (nonatomic, strong) NSString *is_init;
@property (nonatomic, strong) NSString *is_start;
@property (nonatomic, strong) NSString *kh_company_id;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *last_feed_id;
@property (nonatomic, strong) NSString *last_login_time;
@property (nonatomic, strong) NSString *last_post_time;
@property (nonatomic, strong) NSString *latest_login_time;
@property (nonatomic, strong) NSString *live_played_interval;
@property (nonatomic, assign) NSString *liveverifytime;
@property (nonatomic, assign) NSString *login;
@property (nonatomic, strong) NSString *mail_activate;
@property (nonatomic, strong) NSString *month_fourstr;
@property (nonatomic, strong) NSString *my_college;
@property (nonatomic, strong) NSString *my_study_level;
@property (nonatomic, strong) NSString *next_reface_time;
@property (nonatomic, strong) NSString *next_save_time;
@property (nonatomic, strong) NSString *oauth_token;
@property (nonatomic, strong) NSString *oauth_token_secret;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) NSString *phone_activate;
@property (nonatomic, assign) NSString *province;
@property (nonatomic, strong) NSString *purchase_status;
@property (nonatomic, strong) NSString *reg_ip;
@property (nonatomic, strong) NSString *search_key;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *signup_college;
@property (nonatomic, strong) NSString *study_phase;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSString *total_false_count;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *userface;
@end
