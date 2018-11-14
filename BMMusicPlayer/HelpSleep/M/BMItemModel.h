//
//  BMItemModel.h
//  Calm
//
//  Created by BirdMichael on 2018/10/30.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMItemModel : NSObject

@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) NSTimeInterval duration;



@end

NS_ASSUME_NONNULL_END
