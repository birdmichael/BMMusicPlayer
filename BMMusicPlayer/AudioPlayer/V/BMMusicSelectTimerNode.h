//
//  BMMusicSelectTimerNode.h
//  Calm
//
//  Created by BirdMichael on 2018/10/22.
//  Copyright © 2018 BirdMichael. All rights reserved.
//  播放器定时器选择定时页面 涵盖全屏Cover

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BMMusicSelectTimerItem.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^BMMusicSelectTimerNodeSelectItem)(BMMusicSelectTimerItem *item);

@interface BMMusicSelectTimerNode : ASDisplayNode

@property (nonatomic, copy) BMMusicSelectTimerNodeSelectItem selectBlock;
@property (nonatomic, assign) BOOL isTiming; // 正在计时

@end

NS_ASSUME_NONNULL_END
