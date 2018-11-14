//
//  BMTabBar.m
//  Calm
//
//  Created by BirdMichael on 2018/10/30.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

// 解决iphoneX push后偏移
// https://stackoverflow.com/questions/46232929/why-page-push-animation-tabbar-moving-up-in-the-iphone-x/47225653#47225653

#import "BMTabBar.h"

@implementation BMTabBar {
    UIEdgeInsets _oldSafeAreaInsets;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _oldSafeAreaInsets = UIEdgeInsetsZero;
        
        self.barStyle = UIBarStyleBlack;
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = BM_HEX_RGB(0xc676ff);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _oldSafeAreaInsets = UIEdgeInsetsZero;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    
    if (!UIEdgeInsetsEqualToEdgeInsets(_oldSafeAreaInsets, self.safeAreaInsets)) {
        [self invalidateIntrinsicContentSize];
        
        if (self.superview) {
            [self.superview setNeedsLayout];
            [self.superview layoutSubviews];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    if (@available(iOS 11.0, *)) {
        float bottomInset = self.safeAreaInsets.bottom;
        if (bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90)) {
            size.height += bottomInset;
        }
    }
    return size;
}


- (void)setFrame:(CGRect)frame {
    if (self.superview) {
        if (frame.origin.y + frame.size.height != self.superview.frame.size.height) {
            frame.origin.y = self.superview.frame.size.height - frame.size.height;
        }
    }
    [super setFrame:frame];
}


@end
