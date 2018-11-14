//
//  BMBaseViewController.m
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMBaseViewController.h"
#import "BMMusicViewController.h"

@interface BMBaseViewController ()
@property (nonatomic, copy) NSArray<Class> *ignoreBarVc; // 忽视bar的控制器

@end

@implementation BMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BM_HEX_RGB(0x121112);
    _ignoreBarVc = @[[BMMusicViewController class]];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    if (self.navigationController.viewControllers.count>=1) {
        self.navigationItem.leftBarButtonItem = item;
    }
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL ignore = NO;
    for (Class class in self.ignoreBarVc) {
        if ([self isKindOfClass:class]) {
            ignore = YES;
        }
    }
    if (!ignore && [BMMusicViewController sharedInstance].musicIsPlaying) {
        [self addMusicBar];
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)addMusicBar {
    BMMusicBar *musicBar = [BMMusicViewController sharedInstance].musicBar;
    [self.view addSubview:musicBar];
//    self.musicBar = musicBar;
    [musicBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo(BM_FitW(120));
        make.left.mas_equalTo(kBMAppPageMargins);
        make.right.mas_equalTo(-kBMAppPageMargins);
    }];
    if (self.tabBarController.tabBar.isHidden ||!self.tabBarController) {
        [musicBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-10 - kMSafeBottomHeight);
        }];
    }
    [self.view bringSubviewToFront:musicBar];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
