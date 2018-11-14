//
//  BMDateUtil.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMDateUtil : NSObject

/**
 *  生成前几天的时间（不过滤时分秒）
 *
 *  @param day 天数
 *
 *  @return 生成后的NSDate
 */
+(NSDate *)generateDay:(NSUInteger)day;

//以字符串形式输出给定的日期(eg:2016.01.26)
+(NSString *)timeFormat:(NSDate *)date;

//以字符串形式输出给定的日期(eg:2016-01-26)
+(NSString *)timeFormatLine:(NSDate *)date;

/**
 *  json中的date只是string，需要转化成真正的date对象
 *
 *  @param jsonStr jsond是string
 *
 *  @return 转换后的NSDate
 */
+(NSDate *)dateFromJsonString:(NSString *)jsonStr;

/**
 *  把NSDate，需要转化为string
 */
+(NSString *)stringDateForJson:(NSDate *)date;

/**
 *  智能格式化时间，比如几秒前，几分钟前
 */
+(NSString *)dateIntelligentFormat:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
