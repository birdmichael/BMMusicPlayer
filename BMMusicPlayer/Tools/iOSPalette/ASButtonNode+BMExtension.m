//
//  ASButtonNode+BMExtension.m
//  Calm
//
//  Created by BirdMichael on 2018/10/23.
//  Copyright © 2018 BirdMichael. All rights reserved.
//
//#if __has_include(<AsyncDisplayKit/ASButtonNode.h>)
#import "ASButtonNode+BMExtension.h"
@implementation ASButtonNode (BMExtension)
- (UIEdgeInsets)bm_touchAreaInsets
{
    return [objc_getAssociatedObject(self, @selector(bm_touchAreaInsets)) UIEdgeInsetsValue];
}
/**
 *  @brief  设置按钮额外热区
 */

- (void)setBm_touchAreaInsets:(UIEdgeInsets)bm_touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:bm_touchAreaInsets];
    objc_setAssociatedObject(self, @selector(bm_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.bm_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}
@end


