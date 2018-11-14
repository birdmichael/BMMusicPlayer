//
//  NSMutableArray+SafeNil.h
//  Pods
//
//  Created by BirdMichael on 2018/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#if DEBUG
#else

@interface NSMutableArray (SafeNil)

@end

#endif

NS_ASSUME_NONNULL_END
