//
//  NSDictionary+SafeNil.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#else

@interface NSDictionary (SafeNil)

@end

#endif

NS_ASSUME_NONNULL_END
