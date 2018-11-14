//
//  BMFullScreenViewController.m
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMFullScreenViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface BMFullScreenViewController ()

@end

@implementation BMFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
