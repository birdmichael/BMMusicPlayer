//
//  UIColor+BMGradient.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/16.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BMGradientDirection) {
    BMGradientDirectionVertical,
    BMGradientDirectionHorizontal,
};

@interface UIColor (BMGradient)

/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param range  渐变距离（竖向为高度，横向为宽度）
 *
 *  @return 渐变颜色
 */
+ (UIColor*)bm_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withRange:(int)range;

/**
 *  @brief  渐变颜色
 *
 *  @param c1           开始颜色
 *  @param c2           结束颜色
 *  @param direction    渐变方向
 *  @param range        渐变距离（竖向为高度，横向为宽度）
 *
 *  @return 渐变颜色
 */
+ (UIColor*)bm_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 direction:(BMGradientDirection)direction withRange:(int)range;

@end
