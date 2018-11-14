//
//  BMDateUtil.m
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/11/12.
//

#import "BMDateUtil.h"

@implementation BMDateUtil

static NSDateFormatter *dayFormatter = nil;
static NSDateFormatter *jsonHttpParamFormatter = nil;

+(NSDate *)generateDay:(NSUInteger)day{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval newTimeInterval = now - (day * 24 * 60 * 60);
    return [NSDate dateWithTimeIntervalSince1970:newTimeInterval];
}

+(NSString *)timeFormat:(NSDate *)date{
    if(dayFormatter == nil){
        dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dayFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dayFormatter setDateFormat:@"yyyy.MM.dd"];
    }
    return [dayFormatter stringFromDate:date];
}

+(NSString *)timeFormatLine:(NSDate *)date{
    if(dayFormatter == nil){
        dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dayFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dayFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dayFormatter stringFromDate:date];
}

+(NSDate *)dateFromJsonString:(NSString *)jsonStr{
    if(jsonHttpParamFormatter == nil){
        jsonHttpParamFormatter = [[NSDateFormatter alloc] init];
        [jsonHttpParamFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if ([jsonStr hasSuffix:@".0"]) {
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    return [jsonHttpParamFormatter dateFromString:jsonStr];
}

+(NSString *)stringDateForJson:(NSDate *)date{
    if(jsonHttpParamFormatter == nil){
        jsonHttpParamFormatter = [[NSDateFormatter alloc] init];
        [jsonHttpParamFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [jsonHttpParamFormatter stringFromDate:date];
}

+(NSString *)dateIntelligentFormat:(NSDate *)date{
    NSInteger interval = fabs([date timeIntervalSinceNow]);
    if(interval < 60){
        return [NSString stringWithFormat:@"%ld秒前", (long)interval];
    }else if(interval < 60*60){
        NSInteger time = interval/60;
        return [NSString stringWithFormat:@"%ld分钟前",(long)time];
    }else if(interval < 24*60*60){
        NSInteger time = interval/60/60;
        return [NSString stringWithFormat:@"%ld小时前",(long)time];
    }else if(interval < 30*24*60*60){
        NSInteger time = interval/24/60/60;
        return [NSString stringWithFormat:@"%ld天前",(long)time];
    }else if(interval < 12*30*24*60*60){
        NSInteger time = interval/30/24/60/60;
        return [NSString stringWithFormat:@"%ld月前",(long)time];
    }else{
        NSInteger time = interval/12/30/24/60/60;
        return [NSString stringWithFormat:@"%ld年前",(long)time];
    }
}

@end
