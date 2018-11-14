//
//  BMSleepModel.h
//  Calm
//
//  Created by BirdMichael on 2018/10/30.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMSleepModel : NSObject

@property (nonatomic, strong) NSMutableArray<BMItemModel *> *hypnosisData;
@property (nonatomic, strong) NSMutableArray<BMItemModel *> *storiesData;
@property (nonatomic, strong) NSMutableArray<BMItemModel *> *musicData;

@end

NS_ASSUME_NONNULL_END
