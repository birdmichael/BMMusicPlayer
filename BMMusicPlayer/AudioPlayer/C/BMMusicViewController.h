//
//  BMMusicViewController.h
//  Calm
//
//  Created by BirdMichael on 2018/10/16.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMMusicBar.h"
#import "BMItemModel.h"
#import "BMMusicPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMMusicViewController : BMFullScreenViewController
@property (nonatomic, strong) BMMusicBar *musicBar;
@property (nonatomic, assign) BOOL musicIsPlaying;  // 外部显示（仅做是否播放（暂停也算播放中））
@property (nonatomic, strong) BMItemModel *isPlayIngModel;
@property (nonatomic, strong, readonly) BMMusicPlayer *player;

+ (instancetype)sharedInstance;

- (void)stopMusic;
- (void)updatePlaySelected:(BOOL)selected; // 控制暂停以及播放

- (void)updatePlayArray:(NSArray<BMItemModel *> *)playArray index:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
