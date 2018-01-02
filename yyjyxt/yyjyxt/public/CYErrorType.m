//
//  CYErrorType.m
//  ChuYouYun
//
//  Created by 钱程远 on 2017/4/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "CYErrorType.h"

static NSDictionary *dict;

@implementation CYErrorType

+(NSString *)errorDescriptionWithCode:(NSString *)errorcode
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{@"-1100":@"人脸不匹配",//相似度错误
                 @"-1101":@"人脸检测失败",
                 @"-1102":@"图片解码失败",
                 @"-1300":@"操作失败",//图片为空
                 @"-1301":@"操作失败",//参数为空
                 @"-1302":@"不能重复注册",//个体已存在
                 @"-1303":@"尚未注册",//个体不存在
                 @"-5001":@"视频无效，无法正常读取",
                 @"-5002":@"唇语验证失败",
                 @"-5005":@"无法从视频中提取合规的人脸照片",
                 @"-5007":@"视频没有声音",
                 @"-5008":@"语音识别失败",
                 @"-5009":@"视频人脸检测失败，没有嘴或者脸",
                 @"-5010":@"唇动失败,没有检测到嘴巴动",
                 @"-5011":@"活体检测失败,不是活体",
                 @"-5012":@"视频中噪声太大",
                 @"-5013":@"视频里的声音太小",
                 @"-5015":@"视频像素太低，最小270*480",
                 };
    });
    NSString *str = dict[errorcode];
    if (!str) {
        str = [NSString stringWithFormat:@"操作失败：%@",errorcode];
        return str;
    }
    return dict[errorcode];
}

@end
