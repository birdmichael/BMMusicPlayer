//
//  NSString+BMExtension.m
//  Pods
//
//  Created by BirdMichael on 2018/10/2.
//

#import "NSString+BMExtension.h"
#import "UILabel+BMExtension.h"
#import <CommonCrypto/CommonDigest.h>


/** 节约性能，内建一个label计算（新建方法需要清空或者覆盖所有label属性） */

static UILabel *bmSizeLabel = nil;
@implementation NSString (BMExtension)

+ (void)load {
    bmSizeLabel = [UILabel new];
}

- (CGSize)bm_sizeWithFont:(UIFont *)font {
    @autoreleasepool {
        bmSizeLabel.text = self;
        bmSizeLabel.font = font;
        bmSizeLabel.numberOfLines = INT_MAX;
        return [bmSizeLabel bm_size];
    }
}

- (CGSize)bm_sizeWithMaxsize:(CGSize)size font:(UIFont *)font {
    @autoreleasepool {
        bmSizeLabel.text = self;
        bmSizeLabel.font = font;
        bmSizeLabel.numberOfLines = INT_MAX;
        return [bmSizeLabel bm_sizeWithMaxsize:size];
    }
}

- (CGSize)bm_sizeWithMaxsize:(CGSize)size font:(UIFont *)font limitedLine:(NSUInteger)limitedLine {
    @autoreleasepool {
        bmSizeLabel.text = self;
        bmSizeLabel.font = font;
        bmSizeLabel.numberOfLines = limitedLine;
        return [bmSizeLabel bm_sizeWithMaxsize:size];
    }
}

+ (NSString *)bm_md5String:(NSString *)str;
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
    
}

- (NSString *)bm_md5
{
    return [NSString bm_md5String:self];
}
+ (NSString *)bm_timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

- (BOOL)equalsString:(NSString *)str
{
    return (str != nil) && ([self length] == [str length]) && ([self rangeOfString:str options:NSCaseInsensitiveSearch].location == 0);
}
@end
