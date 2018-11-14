//
//  BMTabBarItem.m
//  Calm
//
//  Created by BirdMichael on 2018/10/29.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMTabBarItem.h"

@implementation BMTabBarItem
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    self.selectedImage = [self.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:  BM_HEX_RGB(0xc676ff)} forState:UIControlStateSelected];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:  BM_HEX_RGBA(0xFFFFFF, 0.5)} forState:UIControlStateNormal];
}
@end
