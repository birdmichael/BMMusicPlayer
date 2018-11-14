//
//  BMDataTypesFunctionC.h
//  Pods
//
//  Created by BirdMichael on 2018/10/2.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * BMString(id avg1, ...) NS_REQUIRES_NIL_TERMINATION;
FOUNDATION_EXPORT NSString * BMStrFormat(NSString *f, ...) NS_FORMAT_FUNCTION(1, 2) NS_NO_TAIL_CALL;

FOUNDATION_EXPORT BOOL BMStringNil(id obj);
FOUNDATION_EXPORT BOOL BMAttributedStringNil(id obj);
FOUNDATION_EXPORT BOOL BMDictionaryNil(id obj);
FOUNDATION_EXPORT BOOL BMArrayNil(id obj);
FOUNDATION_EXPORT BOOL BMSetNil(id obj);
FOUNDATION_EXPORT BOOL BMNil(id obj);
FOUNDATION_EXPORT NSString *BMDefultString(id string, NSString *def);
