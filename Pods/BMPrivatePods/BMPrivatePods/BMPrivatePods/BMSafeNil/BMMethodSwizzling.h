//
//  BMMethodSwizzling.h
//  BMPrivatePods
//
//  Created by BirdMichael on 2018/9/25.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern BOOL BMExchangeInstanceMethods(Class class, SEL fromSelector, SEL toSelector);
extern BOOL BMExchangeClassMethods(Class class, SEL fromSelector, SEL toSelector);
