                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    //
//  UIColor+SYColor.h
//  FreehandAreaGetTest
//
//  Created by zhsy on 16/10/21.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import <UIKit/UIKit.h>


/**  RGB 颜色创建  **/
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

/**  RGBA 颜色创建  **/
#define RGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

/**  16进制颜色创建  **/
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

/**  随机颜色创建  **/
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))



@interface UIColor (SYColor)

/**
 *  获取一个点的像素信息 效率问题不适合所有信息的获取
 */
+ (UIColor *)colorOfPoint:(CGPoint)point intView:(UIView *)view;


/**
 *  UIColor 转RGB(RGBA)
 */
- (void)getRGBComponents:(CGFloat [4])components;



//创建颜色
/**
 *  16进制转UIColor
 */
+ (UIColor *)colorWithHexString: (NSString *)color;



    
@end
