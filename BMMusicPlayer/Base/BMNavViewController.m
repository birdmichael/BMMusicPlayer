//
//  BMNavViewController.m
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMNavViewController.h"
#import "BMFullScreenViewController.h"

@interface BMNavViewController ()<UINavigationControllerDelegate>

@end

@implementation BMNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = KBM_NAV_BACKGROUND_COLER;
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor bm_colorWithHex:0xffffff] forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
    //去掉下面的黑线,6.5需求改为dedede
    for (UIView *view in self.navigationBar.subviews) {
        for (UIView *v in view.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [(UIImageView *)v setBackgroundColor:BM_HEX_RGBA(0x000000, 1)];
            }
        }
    }
    self.navigationBar.translucent = NO;
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
