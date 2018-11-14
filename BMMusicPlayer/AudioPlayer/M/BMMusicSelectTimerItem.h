//
//  BMMusicSelectTimerItem.h
//  Calm
//
//  Created by BirdMichael on 2018/10/22.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface BMMusicSelectTimerItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *value;

+ (NSMutableArray<BMMusicSelectTimerItem *> *)getData;
@end

NS_ASSUME_NONNULL_END
