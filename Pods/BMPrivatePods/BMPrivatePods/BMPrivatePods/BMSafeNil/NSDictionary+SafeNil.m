//
//  NSDictionary+SafeNil.m
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/25.
//

#import "NSDictionary+SafeNil.h"
#import "BMMethodSwizzling.h"

#ifdef DEBUG
#else

@implementation NSDictionary (SafeNil)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BMExchangeClassMethods([self class], @selector(dictionaryWithObjects:forKeys:count:), @selector(bm_dictionaryWithObjects:forKeys:count:));
    });
}

+ (instancetype)bm_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    // 有值的键值对数量
    NSUInteger totalCount = 0;
    id safeKey[cnt];
    id safeObject[cnt];
    
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id object = objects[i];
        // 排除为空的 key 和 object
        if (key && object) {
            safeKey[totalCount] = key;
            safeObject[totalCount] = object;
            totalCount++;
        }
    }
    return [self bm_dictionaryWithObjects:safeObject forKeys:safeKey count:totalCount];
}

@end

#endif
