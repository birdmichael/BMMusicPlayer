//
//  AppDelegate.m
//  BMMusicPlayer
//
//  Created by BirdMichael on 2018/11/15.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "AppDelegate.h"
#import "BMTabBarController.h"
#import "BMTabBarItem.h"
#import "BMNavViewController.h"
#import "BMHelpSleepViewController.h"
#import "BMASMRViewController.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 配置全局界面
    [self setupMainTab];
    [self initAppearance];
    return YES;
}

- (void)setupMainTab {
    //init tab
    BMTabBarController *tabBarController = [[BMTabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.tabBar.contentMode = UIViewContentModeScaleAspectFill;
    NSMutableArray *controllers = [NSMutableArray array];
    
    // 自定义
    NSArray *tabBarKey = @[@"name",@"ControllerClass"];
    NSArray *tabBarValues = @[@{tabBarKey[0]:@"Home",tabBarKey[1]:[BMHelpSleepViewController class]},
                              @{tabBarKey[0]:@"Sleep",tabBarKey[1]:[BMASMRViewController class]},
                              @{tabBarKey[0]:@"Meditate",tabBarKey[1]:[BMHelpSleepViewController class]},
                              @{tabBarKey[0]:@"ASMR",tabBarKey[1]:[BMASMRViewController class]},
                              @{tabBarKey[0]:@"Video",tabBarKey[1]:[BMHelpSleepViewController class]},
                              ];
    for (NSDictionary *barValue in tabBarValues) {
        Class class = [barValue valueForKey:tabBarKey[1]]?:[UIViewController class];
        UIViewController *vc = [[class  alloc]init];
        BMTabBarItem *item = [[BMTabBarItem alloc] init];
        item.tag = [tabBarValues indexOfObject:barValue];
        vc.tabBarItem = item;
        vc.tabBarItem.image = [UIImage imageNamed:barValue[tabBarKey[0]]];
        vc.tabBarItem.title = barValue[tabBarKey[0]];
        BMNavViewController * vcNav = [[BMNavViewController alloc]initWithRootViewController:vc];
        
        [controllers addObject:vcNav];
    }
    
    
    //config tab
    tabBarController.viewControllers = controllers;
    tabBarController.customizableViewControllers = controllers;
    tabBarController.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
    tabBarController.selectedIndex = 0;
    
    self.window.rootViewController = tabBarController;
}

-(void)initAppearance {
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.window.backgroundColor = KBM_CLAM_BACKGROUND_COLER;
    [self.window makeKeyAndVisible];
    //搜索取消字体颜色
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
