//
//  UILabel+BMExtension.m
//  Pods
//
//  Created by BirdMichael on 2018/10/2.
//

#import "UILabel+BMExtension.h"

@implementation UILabel (BMExtension)
- (CGSize)bm_size {
    CGSize result = [self textRectForBounds:[UIScreen mainScreen].bounds limitedToNumberOfLines:1].size;
    return CGSizeMake(ceil(result.width), ceil(result.height));
}

- (CGSize)bm_sizeWithMaxsize:(CGSize)size {
    NSUInteger limitedLine = self.numberOfLines;
    CGSize result = [self textRectForBounds:CGRectMake(0, 0, size.width, size.height) limitedToNumberOfLines:limitedLine ].size;
    return CGSizeMake(ceil(result.width), ceil(result.height));
}
@end
