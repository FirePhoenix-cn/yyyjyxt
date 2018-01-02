//
//  UIImage+Custom.h
//  ImageCocoa
//
//  Created by jinou on 16/9/9.
//  Copyright © 2016年 com.jinou.libBleLock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

typedef enum {
    
    //左上
    ImageWaterDirectTopLeft=0,
    
    //右上
    ImageWaterDirectTopRight,
    
    //左下
    ImageWaterDirectBottomLeft,
    
    //右下
    ImageWaterDirectBottomRight,
    
    //正中
    ImageWaterDirectCenter
    
}ImageWaterDirect;


@interface UIImage (Custom)

/**
 *  修正图片方向
 *
 *  @return 修改后的图片
 */
- (UIImage *)fixOrientation;

/**
 *  返回指定颜色生成的图片
 *
 *  @param color 颜色
 *  @param size  尺寸
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;


/**
 *  获取指定尺寸（50*50）的图片
 *
 *  @param color 图片颜色
 *  @param name  文本,居中显示
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color text:(NSString *)name;

/*
 *图片模糊
 */
+ (UIImage *)gaussianBlurImage:(UIImage *)image andInputRadius:(CGFloat)radius;

/*
 *蒙版模糊
 */
+ (UIImage *)gaussianBlurImageWithColor:(UIColor *)color andSize:(CGSize)size andInputRadius:(CGFloat)radius;

//UIImage等比例缩放
+(UIImage *)scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize;

//UIImage自定长宽缩放
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 *  图片剪切为圆形
 *
 *  @param originalImage 原始图片
 *
 *  @return 剪切后的圆形图片
 */
- (UIImage *)roundImage;

/*
 *  直接截屏
 */
+ (UIImage *)cutScreen;

/**
 *  从给定UIView中截图：UIView转UIImage
 */
+ (UIImage *)cutFromView:(UIView *)view;

/**
 *  文字水印
 *
 *  @param text      文字
 *  @param direction 文字方向
 *  @param fontColor 文字颜色
 *  @param fontPoint 字体
 *  @param marginXY  对齐点
 *  @return
 */

- (UIImage *)waterWithText:(NSString *)text
                 direction:(ImageWaterDirect)direction
                 fontColor:(UIColor *)fontColor
                 fontPoint:(CGFloat)fontPoint
                  marginXY:(CGPoint)marginXY;

/**
 *  绘制图片水印
 *
 *  @param waterImage 图片水印
 *  @param direction  方向
 *  @param waterSize  水印大小
 *  @param marginXY   对齐点
 *
 *  @return
 */
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage
                       direction:(ImageWaterDirect)direction
                       waterSize:(CGSize)waterSize
                        marginXY:(CGPoint)marginXY;

/**
 *  播放动画
 *
 *  @param data 源文件（图片源）
 *
 *  @return
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data;


/**
 *  播放gif动画
 *
 *  @param name 文件名
 *
 *  @return
 */
+ (UIImage *)animatedGIFNamed:(NSString *)name;

/**
 *  缩放动画
 *
 *  @param size 大小
 *
 *  @return
 */

- (UIImage *)animatedImageByScalingAndCroppingToSize:(CGSize)size;

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;


/**
 *  转成黑白图像
 *
 *  @param sourceImage 原图
 *
 *  @return 黑白图像
 */
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;


/*
 *图片旋转
 */
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

/*
 *单色图片
 */
-(UIImage*)rt_tintedImageWithColor:(UIColor*)color;


//view生成image
+ (UIImage *)makeImageWithView:(UIView *)view;

@end
