//
//  BMHttpManager.h
//  Calm
//
//  Created by BirdMichael on 2018/10/26.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMSleepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMHttpManager : NSObject

+ (BMHttpManager *) sharedInstance;

// 获取Seelp模型
- (void)getSleep:(void(^)(BMSleepModel *model))completion;
- (void)getASMR:(void(^)(NSArray<BMItemModel *> *modelArray))completion;
@end

NS_ASSUME_NONNULL_END
