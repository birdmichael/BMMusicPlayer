//
//  BMMusicSelectTimerItem.m
//  Calm
//
//  Created by BirdMichael on 2018/10/22.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMMusicSelectTimerItem.h"
#import "MJExtension.h"

@implementation BMMusicSelectTimerItem

+ (NSMutableArray<BMMusicSelectTimerItem *> *)getData {
    NSMutableArray *array = [@[] mutableCopy];
    BMMusicSelectTimerItem *cancelItem = [[BMMusicSelectTimerItem alloc] init];
    cancelItem.title = @"Cancel";
    cancelItem.value = @(0);
    [array addObject:cancelItem];
    
    NSArray *values = @[@10,@20,@30,@40,@50,@60,@70,@80,@90];
    for (int i = 0; i<values.count; i++) {
        [array addObject:@{
                           @"title":BMString(values[i],@"min", nil),
                           @"value":values[i]
                           }];
    }
    NSMutableArray *modeArray = [BMMusicSelectTimerItem mj_objectArrayWithKeyValuesArray:array];
    return modeArray;
}
@end
