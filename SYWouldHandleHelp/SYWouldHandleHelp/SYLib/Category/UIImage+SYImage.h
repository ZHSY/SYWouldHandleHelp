//
//  UIImage+SYImage.h
//  FreehandAreaGetTest
//
//  Created by zhsy on 16/10/21.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SYImage)


#pragma mark - 创建

/**
 *  通过颜色来生成一个纯色图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

/**
 *  通过颜色来生成一个纯色图片
 */
+ (UIImage *)imageFromImage:(UIImage *)image color:(UIColor *)color;


#pragma mark * 截图

/**
 *  屏幕截图
 */
+ (UIImage *)imageWithScreenContents;

/**
 *  view截图（只截取view及其subView内容 覆盖其上的同级view不会截取）
 */
+ (instancetype)imageForView:(UIView *)shotView;

/**
 *  view 部分截图（只截取view及其subView内容 覆盖其上的同级view不会截取）
 */
+ (instancetype)imageForView:(UIView *)shotView shotFrame:(CGRect)frame;




#pragma mark - 处理

/**
 *  灰色图片转化
 */
- (UIImage *)getGrayImage;

/**
 *  获取图片的所有像素信息  pointRGBAList: *[]数组 内容为：p[4] 数组指针
 */
- (void)getAllImageRGBData:(int *[])pointRGBAList;

/**
 *  获取一个点的像素信息 不适合所有信息的获取
 */
- (UIColor *)colorOfPoint:(CGPoint)point;

/**
 *  匹配点的颜色,返回信息数组， 符合YES 不符合NO
 */
- (NSArray *)fixColor:(UIColor *)color;

/**
 *  对比获取对应颜色区域得大小
 *
 *  @return [@{@"pointIndex":@(0),@"color":color}]
 */
- (NSInteger)pointCountForColor:(UIColor *)color;



/**
 *  返回一张图片 除points 中下标为YES的点外 其余点均置为baseColor（baseColor 目前可能无效 默认为白色）
 */
- (UIImage *)extrudePoints:(NSArray *)points baseColor:(UIColor *)baseColor;

/**
 *  返回一张图片 除points 中下标为YES的点外 其余点均置为baseColor（baseColor 目前可能无效 默认为白色）
 */
- (UIImage *)extrudeWithComponent:(void (^)(uint8_t * pointABGR))component;




@end
