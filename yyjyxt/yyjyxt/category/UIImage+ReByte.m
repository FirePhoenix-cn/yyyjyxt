//
//  UIImage+ReByte.m
//  ChuYouYun
//
//  Created by 钱程远 on 2017/6/8.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "UIImage+ReByte.h"

@implementation UIImage (ReByte)
-(NSData *)adaptionImgData{
    UIImage *resultImage = [self adaptionImageSize];
    
    return  UIImageJPEGRepresentation(resultImage, 0.5f);
}

-(UIImage*)adaptionImageSize{
    if (fabs(self.size.width-self.size.height)<2.0f) {
        CGFloat maxsize = 640.0f;
        if (self.size.width<maxsize) {
            UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.width));
            [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.width)];
        }else{
            UIGraphicsBeginImageContext(CGSizeMake(maxsize, maxsize));
            [self drawInRect:CGRectMake(0, 0, maxsize, maxsize)];
        }
    }else{
        UIGraphicsBeginImageContext(CGSizeMake(270, 480));
        [self drawInRect:CGRectMake(0, 0, 270, 480)];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  resultImage;
}

@end
