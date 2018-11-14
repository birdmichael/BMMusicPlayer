//
//  UIColor+BMRandom.m
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/17.
//

#import "UIColor+BMRandom.h"

@implementation UIColor (BMRandom)

+ (UIColor *)bm_RandomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

@end
