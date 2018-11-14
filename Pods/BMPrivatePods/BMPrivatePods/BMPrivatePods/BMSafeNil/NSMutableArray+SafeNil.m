//
//  NSMutableArray+SafeNil.m
//  Pods
//
//  Created by BirdMichael on 2018/9/25.
//

#import "NSMutableArray+SafeNil.h"
#import "BMMethodSwizzling.h"

#if DEBUG
#else

@implementation NSMutableArray (SafeNil)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BMExchangeClassMethods([self class], @selector(removeObject:), @selector(bm_removeObject:));
        BMExchangeInstanceMethods(NSClassFromString(@"__NSArrayM"), @selector(addObject:), @selector(bm_addObject:));
        BMExchangeInstanceMethods(NSClassFromString(@"__NSArrayM"), @selector(removeObjectAtIndex:), @selector(bm_removeObjectAtIndex:));
        BMExchangeInstanceMethods(NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:), @selector(bm_insertObject:atIndex:));
        BMExchangeInstanceMethods(NSClassFromString(@"__NSPlaceholderArray"), @selector(initWithObjects:count:), @selector(bm_initWithObjects:count:));
        BMExchangeInstanceMethods(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:), @selector(bm_objectAtIndex:));
    });
}

- (instancetype)bm_initWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    BOOL hasNilObject = NO;
    for (NSUInteger i = 0; i < cnt; i++) {
        if ([objects[i] isKindOfClass:[NSArray class]]) {
            NSLog(@"%@", objects[i]);
        }
        if (objects[i] == nil) {
            hasNilObject = YES;
            NSLog(@"%s object at index %lu is nil, it will be filtered", __FUNCTION__, (unsigned long)i);
            
#if DEBUG
            
            NSString *errorMsg = [NSString stringWithFormat:@"数组元素不能为nil，其index为: %lu", i];
            NSAssert(objects[i] != nil, errorMsg);
#endif
        }
    }
    
    // 过滤掉值为nil的元素
    if (hasNilObject) {
        id __unsafe_unretained newObjects[cnt];
        
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < cnt; ++i) {
            if (objects[i] != nil) {
                newObjects[index++] = objects[i];
            }
        }
        
        return [self bm_initWithObjects:newObjects count:index];
    }
    
    return [self bm_initWithObjects:objects count:cnt];
}

- (void)bm_removeObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s call -removeObject:, but argument obj is nil", __FUNCTION__);
        return;
    }
    
    [self bm_removeObject:obj];
}

- (void)bm_addObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s can add nil object into NSMutableArray", __FUNCTION__);
    } else {
        [self bm_addObject:obj];
    }
}

- (void)bm_removeObjectAtIndex:(NSUInteger)index {
    if (self.count <= 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return;
    }
    
    if (index >= self.count) {
        NSLog(@"%s index out of bound", __FUNCTION__);
        return;
    }
    
    [self bm_removeObjectAtIndex:index];
}

- (void)bm_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        NSLog(@"%s can't insert nil into NSMutableArray", __FUNCTION__);
    } else if (index > self.count) {
        NSLog(@"%s index is invalid", __FUNCTION__);
    } else {
        [self bm_insertObject:anObject atIndex:index];
    }
}

- (id)bm_objectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return nil;
    }
    
    if (index > self.count) {
        NSLog(@"%s index out of bounds in array", __FUNCTION__);
        return nil;
    }
    
    return [self bm_objectAtIndex:index];
}

@end

#endif
