//
//  UIColor+BMHEX.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/16.
//

#import <UIKit/UIKit.h>

@interface UIColor (BMHEX)

+ (UIColor *)bm_colorWithHex:(UInt32)hex;
+ (UIColor *)bm_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)bm_colorWithHexString:(NSString *)hexString;
- (NSString *)bm_HEXString;

/**
 *  @brief  数组形式创建颜色
 *
 *  @param RGBArray     颜色数字数组,不需要除以255.0（like：@[@(111),@(111),@(111)]）
 *  @param alpha        透明度
 *
 *  @return 生成颜色
 */
+ (UIColor *)bm_colorWithWholeRGBArray:(NSArray<NSNumber *> *)RGBArray alpha:(CGFloat)alpha;

/**
 *  @brief  数组形式创建颜色
 *
 *  @param RGBArray     颜色数字数组,不需要除以255.0（like：@[@(111),@(111),@(111)]）
 *
 *  @return 生成颜色
 */
+ (UIColor *)bm_colorWithWholeRGBArray:(NSArray<NSNumber *> *)RGBArray;

@end
