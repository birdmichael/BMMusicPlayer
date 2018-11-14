//
//  NSMutableDictionary+SafeNil.m
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/25.
//

#import "NSMutableDictionary+SafeNil.h"
#import "BMMethodSwizzling.h"

#if DEBUG
#else

@implementation NSMutableDictionary (SafeNil)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BMExchangeInstanceMethods(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(bm_setObject:forKey:));
        BMExchangeInstanceMethods(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(bm_setObject:forKeyedSubscript:));
    });
}

#pragma mark - Method swizzling

- (void)bm_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self bm_setObject:anObject forKey:aKey];
    }
}

- (void)bm_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (obj && key) {
        [self bm_setObject:obj forKeyedSubscript:key];
    }
}

@end

#endif
