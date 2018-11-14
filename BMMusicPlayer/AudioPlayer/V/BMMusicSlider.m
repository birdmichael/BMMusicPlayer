//
//  BMMusicSlider.m
//  Calm
//
//  Created by BirdMichael on 2018/10/21.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMMusicSlider.h"

@implementation BMMusicSlider

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImage *thumbImage = [UIImage imageNamed:@"progressBar_icon"];
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    self.maximumTrackTintColor = BM_HEX_RGBA(0xffffff, 0.5);
    self.contentMode = UIViewContentModeLeft;
    self.minimumTrackTintColor = [UIColor bm_gradientFromColor:BM_HEX_RGB(0xCB39E1) toColor:BM_HEX_RGB(0x7142E9) direction:BMGradientDirectionHorizontal withRange:10];
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x  ;
    rect.size.width = rect.size.width ;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 0 , 0);
}
- (CGRect)trackRectForBounds:(CGRect)bounds{
    bounds = [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 3);
}

@end
