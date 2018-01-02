//
//  Header.h
//  yyjyxt
//
//  Created by 钱程远 on 2017/12/28.
//  Copyright © 2017年 钱程远. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define UserIdKey @"user_id"
#define UserAccount @"user_account"
#define UserPassword @"user_password"

//cache
#define UserInfoModelCachePath @"userinfopath"
#define UserInfoModelCacheName @"userinfoname"


//api

#define BaseUrl @"ycjy.cqmxcx.cn:8012"
#define API_BASE_URL [NSString stringWithFormat:@"http://%@/index.php?app=api",BaseUrl]

#define API_Mod_Login @"Login"

#define API_Mod_Login_login @"login"
#define API_Mod_Login_regist @"app_regist"


#define API_Mod_Youtu @"Youtu"
#define API_Mod_Youtu_reFace @"reFace"
#define API_Mod_Youtu_newperson @"newperson"
#define API_Mod_Youtu_syncUser @"syncUser"
#define API_Mod_Youtu_getTime @"getTime"
#define API_Mod_Youtu_version @"version"

#endif /* Header_h */
