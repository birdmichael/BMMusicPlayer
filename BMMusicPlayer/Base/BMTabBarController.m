//
//  BMTabBarController.m
//  Calm
//
//  Created by BirdMichael on 2018/10/15.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMTabBarController.h"
#import <Lottie/Lottie.h>
#import "BMTabBar.h"

@interface BMTabBarController ()
@property (nonatomic,strong) LOTAnimationView *animation;

@end

@implementation BMTabBarController


- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.tabBar.barStyle = UIBarStyleBlackOpaque;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BMTabBar *tabbar = [[BMTabBar alloc] init];
    [self setValue:tabbar forKey:@"tabBar"];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.tabBar.frame;
    frame.origin.y = kBMSCREEN_HEIGHT - kBMTabBarHeight;
    self.tabBar.frame = frame;
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSArray * sss = self.tabBar.subviews;
    NSMutableArray *tabbatButtonArray = [@[] mutableCopy];
    for (UIView *view in sss) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbatButtonArray addObject:view];
        }
    }
    
    for (UIView *view in [tabbatButtonArray[item.tag] subviews]) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            [self.animation removeFromSuperview];
            NSString * name = item.title;
            LOTAnimationView *animation = [LOTAnimationView animationNamed:name];
            [view addSubview:animation];
            animation.bounds = CGRectMake(0, 0,view.bounds.size.width,view.bounds.size.width);
            animation.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
            [animation playWithCompletion:^(BOOL animationFinished) {
                // Do Something
            }];
            self.animation = animation;
        }
    }
}


+ (UIImage *)ssimageNamed:(NSString *)name
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    name = 3.0 == scale ? [NSString stringWithFormat:@"%@@3x.png", name] : [NSString stringWithFormat:@"%@@2x.png", name];
    UIImage *image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]];
    return image;
}

#pragma mark - Rotate

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
