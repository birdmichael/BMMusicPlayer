//
//  BMItemModel.m
//  Calm
//
//  Created by BirdMichael on 2018/10/30.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMItemModel.h"

@implementation BMItemModel
- (BOOL)isEqual:(BMItemModel *)object {
    if (!self.url ||!object.url) return NO;
    if ([self.url isEqualToString:@""] || [object.url isEqualToString:@""])return NO;
    
    if ([self.url isEqualToString:object.url]) {
        return YES;
    }else {
        return NO;
    }
}
@end
