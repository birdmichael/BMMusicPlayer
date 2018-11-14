//
//  UIFont+BMFItSize.m
//  Pods
//
//  Created by BirdMichael on 2018/10/3.
//

#import "UIFont+BMFItSize.h"
#import "BMMethodSwizzling.h"

#ifndef BMFItSizeAllowred

static const CGFloat kFontSizeAugmenterWithIphone6 = 1.0;
static const CGFloat kFontSizeAugmenterWithIphonePlus = 1.5;
@implementation UIFont (BMFItSize)


/**
 *  使用运行时将字体默认的两个方法，systemFontOfSize，boldSystemFontOfSize与bm_swizzleMethod_systemFontOfSize，bm_swizzleMethod_boldSystemFontOfSize的实现分别互换，
 *  来达到根据屏幕尺寸调节字体大小的效果，且不用更改其他地方的调用方法
 */

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BMExchangeClassMethods([self class], @selector(systemFontOfSize:), @selector(bm_swizzleMethod_systemFontOfSize:));
        BMExchangeClassMethods([self class], @selector(boldSystemFontOfSize:), @selector(bm_swizzleMethod_boldSystemFontOfSize:));
    });
    
}

+ (UIFont *) bm_swizzleMethod_systemFontOfSize:(CGFloat )fontSize {
    if([UIScreen mainScreen].bounds.size.width <= 320){
        return [self bm_swizzleMethod_systemFontOfSize:fontSize];
    }else if ([UIScreen mainScreen].bounds.size.width > 320 &&
              [UIScreen mainScreen].bounds.size.width <= 375){
        return [self bm_swizzleMethod_systemFontOfSize:fontSize + kFontSizeAugmenterWithIphone6];
    }else{
        return [self bm_swizzleMethod_systemFontOfSize:fontSize + kFontSizeAugmenterWithIphonePlus];
    }
    
}

+ (UIFont *) bm_swizzleMethod_boldSystemFontOfSize:(CGFloat) fontSize {
    if([UIScreen mainScreen].bounds.size.width <= 320){
        return [self bm_swizzleMethod_boldSystemFontOfSize:fontSize];
    }else if ([UIScreen mainScreen].bounds.size.width > 320 &&
              [UIScreen mainScreen].bounds.size.width <= 375){
        return [self bm_swizzleMethod_boldSystemFontOfSize:fontSize + kFontSizeAugmenterWithIphone6];
    }else{
        return [self bm_swizzleMethod_boldSystemFontOfSize:fontSize + kFontSizeAugmenterWithIphonePlus];
    }
}

@end

#endif
