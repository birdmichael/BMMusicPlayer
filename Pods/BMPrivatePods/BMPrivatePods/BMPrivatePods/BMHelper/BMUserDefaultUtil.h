//
//  BMUtil.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMUserDefaultUtil : NSObject
/**
 *  用于只执行一次的需求，在此封装为一个方法(包括用户更新程序，除非用户删除应用)
 *
 *  @param key 需要表示该次操作的字符串
 *
 *  @return 当第一次执行该方法时返回YES，否则返回NO
 */
+ (BOOL)executeOnlyOnce:(NSString *)key;
/**
 *  用于只执行count的需求，在此封装为一个方法(包括用户更新程序，除非用户删除应用)
 *
 *  @param key 需要表示该次操作的字符串
 *
 *  @return 当还有机会执行该方法时返回YES，否则返回NO
 */
+ (BOOL)executeOnlyInCount:(NSInteger)count withKey:(NSString *)key;

/**
 *  用于第多少次才需要执行的需求，比如第3次打开APP执行。
 *
 *  @param key 需要表示该次操作的字符串
 *
 *  @return 需要执行返回YES，否则返回NO
 */
+ (BOOL)executeOnlyInTimes:(NSInteger)times withKey:(NSString *)key;

/**
 *  每天首次执行
 */
+ (BOOL)everyDayFirstExecute:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
