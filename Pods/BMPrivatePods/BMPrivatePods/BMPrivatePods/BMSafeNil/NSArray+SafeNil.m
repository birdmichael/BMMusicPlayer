//
//  NSArray+SafeNil.m
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/25.
//

#import "NSArray+SafeNil.h"
#import "BMMethodSwizzling.h"

#ifdef DEBUG
#else

@implementation NSArray (SafeNil)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BMExchangeInstanceMethods(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:), @selector(bm_objectAtIndexI:));
        BMExchangeInstanceMethods(NSClassFromString(@"__NSArrayI"), @selector(arrayWithObjects:count:), @selector(bm_arrayWithObjects:count:));
    });
}

- (id)bm_objectAtIndexI:(NSUInteger)index {
    if (index >= self.count) {
        NSLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        return nil;
    }
    
    return [self bm_objectAtIndexI:index];
}

+ (id)bm_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id validObjects[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i]) {
            validObjects[count] = objects[i];
            count++;
        }
        else {
            NSLog(@"[%@ %@] NIL object at index {%lu}",
                  NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  (unsigned long)i);
            
        }
    }
    
    return [self bm_arrayWithObjects:validObjects count:count];
}

@end

#endif
