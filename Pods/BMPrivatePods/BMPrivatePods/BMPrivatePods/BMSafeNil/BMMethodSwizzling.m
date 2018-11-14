//
//  BMMethodSwizzling.m
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/25.
//

#import "BMMethodSwizzling.h"

extern BOOL BMExchangeInstanceMethods(Class class, SEL fromSelector, SEL toSelector) {
    Method origMethod = class_getInstanceMethod(class, fromSelector);
    Method altMethod = class_getInstanceMethod(class, toSelector);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(class,
                    fromSelector,
                    class_getMethodImplementation(class, fromSelector),
                    method_getTypeEncoding(origMethod));
    class_addMethod(class,
                    toSelector,
                    class_getMethodImplementation(class, toSelector),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(class, fromSelector),
                                   class_getInstanceMethod(class, toSelector));
    return YES;
}

extern BOOL BMExchangeClassMethods(Class class, SEL fromSelector, SEL toSelector) {
    return BMExchangeInstanceMethods(object_getClass((id)class), fromSelector, toSelector);
}

