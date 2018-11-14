//
//  BMDataTypesFunctionC.m
//  Pods
//
//  Created by BirdMichael on 2018/10/2.
//

#import "BMDataTypesFunctionC.h"

NSString * BMString(id avg1, ...) {
    va_list list;
    va_start(list, avg1);
    NSMutableString *formatter = [NSMutableString new];
    for (id obj = avg1; obj; obj = va_arg(list, id)) {
        [formatter appendFormat:@"%@", obj];
    }
    va_end(list);
    return [formatter copy];
}

NSString * BMStrFormat(NSString *format, ...) {
    va_list list;
    va_start(list, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:list];
    va_end(list);
    return string;
}

BOOL BMStringNil(id obj) {
    if (!obj) return YES;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)obj;
        
        if (string.length == 0
            || [string compare:@"null" options:NSCaseInsensitiveSearch] == NSOrderedSame
            || [string compare:@"<null>" options:NSCaseInsensitiveSearch] == NSOrderedSame
            || [string compare:@"nil" options:NSCaseInsensitiveSearch] == NSOrderedSame
            || [string compare:@"<nil>" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return YES;
        }
        return NO;
    }
    return YES;
}

BOOL BMAttributedStringNil(id obj) {
    if (!obj) return YES;
    if ([obj isKindOfClass:[NSAttributedString class]]) {
        NSString *string = [(NSAttributedString *)obj string];
        if (string.length == 0
            || [string compare:@"null" options:NSCaseInsensitiveSearch] == NSOrderedSame
            || [string compare:@"<null>" options:NSCaseInsensitiveSearch] == NSOrderedSame
            || [string compare:@"nil" options:NSCaseInsensitiveSearch] == NSOrderedSame
            || [string compare:@"<nil>" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return YES;
        }
        return NO;
    }
    return YES;
}


NSString *BMDefultString(id string, NSString *def) {
    if (BMStringNil(string)) {
        if (BMStringNil(def)) {
            return @"";
        }
        return def;
    }
    return string;
}


BOOL BMSetNil(id obj) {
    if (!obj) return YES;
    
    if ([obj isKindOfClass:[NSSet class]]) {
        NSSet *set = (NSSet *)obj;
        return set.allObjects.count == 0;
    }
    return YES;
}

BOOL BMDictionaryNil(id obj) {
    if (!obj) return YES;
    
    // dictionary
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)obj;
        return dictionary.allKeys.count == 0;
    }
    return YES;
}

BOOL BMArrayNil(id obj) {
    if (!obj) return YES;
    
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)obj;
        return array.count == 0;
    }
    return YES;
}

BOOL BMNil(id obj) {
    if (!obj) return YES;
    
    // string
    if ([obj isKindOfClass:[NSString class]]) {
        return BMStringNil(obj);
    }
    
    // dictionary
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return BMDictionaryNil(obj);
    }
    
    // array
    if ([obj isKindOfClass:[NSArray class]]) {
        return BMArrayNil(obj);
    }
    
    // set
    if ([obj isKindOfClass:[NSSet class]]) {
        return BMSetNil(obj);
    }
    
    return NO;
}
