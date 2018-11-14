//
//  BMTimer.h
//  Pods
//
//  Created by BirdMichael on 2018/11/2.
//

#import <Foundation/Foundation.h>

typedef void (^BMTimerBlock)(id userInfo);
NS_ASSUME_NONNULL_BEGIN
@interface BMTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                     target:(id)target
                                   selector:(SEL)selector
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                      block:(BMTimerBlock)block
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
